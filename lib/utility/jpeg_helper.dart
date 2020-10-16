import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:edit_exif/edit_exif.dart';
import 'package:image/image.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/jpeg_exif.dart';

import 'application_profile.dart';

abstract class ExifItem {
  static const String TAG_IMAGE_DESCRIPTION = 'TAG_IMAGE_DESCRIPTION';
  static const String TAG_SOFTWARE = 'TAG_SOFTWARE';
  static const String TAG_DATETIME_ORIGINAL = 'TAG_DATETIME_ORIGINAL';
  static const String TAG_GPS_LATITUDE = "TAG_GPS_LATITUDE";
  static const String TAG_GPS_LATITUDE_REF = "TAG_GPS_LATITUDE_REF";
  static const String TAG_GPS_LONGITUDE = "TAG_GPS_LONGITUDE";
  static const String TAG_GPS_LONGITUDE_REF = "TAG_GPS_LONGITUDE_REF";
  static const String TAG_ORIENTATION = "TAG_ORIENTATION";
}

abstract class XmpItem {
  static const String LargeClassification = "photo:LargeClassification";
  static const String PhotoClassification = "photo:PhotoClassification";
}

abstract class ExifTagItem {
  static const int GPSLatitudeRef = 1;
  static const int GPSLatitude = 2;
  static const int GPSLongitudeRef = 3;
  static const int GPSLongitude = 4;
  static const int GPSInfo = 34853;
}

class JpegHelper {
  Future writeXmp(Image image, BlackboardItem bdItem) async {
    int idx;
    List<Uint8List> rawDatas = List<Uint8List>(image.exif.rawData.length + 1);
    for (idx = 0; idx < image.exif.rawData.length; idx++) {
      rawDatas[idx] = image.exif.rawData[idx].sublist(0);
    }
    OutputBuffer xmpData = new OutputBuffer();
    OutputBuffer buffer = new OutputBuffer();
    var stingXml = getXml(bdItem);
    buffer.clear();
    buffer.writeBytes('http://ns.adobe.com/xap/1.0/'.codeUnits);
    buffer.writeByte(0);
    buffer.writeBytes('<?xpacket begin="'.codeUnits);
    buffer.writeByte(0xEF);
    buffer.writeByte(0xBB);
    buffer.writeByte(0xBF);
    buffer.writeBytes('" id="W5M0MpCehiHzreSzNTczkc9d"?>'.codeUnits);
    buffer.writeBytes(utf8.encode(stingXml.toString()));
    buffer.writeBytes('<?xpacket end="w"?>'.codeUnits);
    xmpData.writeBytes(buffer.getBytes());
    rawDatas[idx] = Uint8List.fromList(xmpData.getBytes());
    image.exif.rawData = rawDatas;
  }

  Future<Map<String, dynamic>> readXmpAndExif(String path) async {
    Map<String, dynamic> info = {};
    Image image = decodeJpg(File(path).readAsBytesSync());
    bool isBig = true;
    if (image.exif.hasRawData) {
      image.exif.rawData.forEach((item) {
        InputBuffer buffer = new InputBuffer(item);
        if (buffer.readString() == "Exif") {
          //Exif
          buffer.readBytes(1);
          var endianBig = buffer.readByte();
          //バイト順取得 Big-M-77, Little-I-73
          if (endianBig != 77) {
            isBig = false;
          }
          buffer.readBytes(7);
          //IFDフィールドは循環的にGPSを見つけます
          var dirEntryCnt = _getInt16(buffer.readBytes(2).toUint8List(),
              isBig ? Endian.big : Endian.little);
          for (int idx = 0; idx < dirEntryCnt; idx++) {
            int tagIdx = _getUInt16(buffer.readBytes(2).toUint8List(),
                isBig ? Endian.big : Endian.little);
            if (tagIdx == ExifTagItem.GPSInfo) {
              //GPS情報を読み取る
              readGpsBuffer(
                  buffer, isBig ? Endian.big : Endian.little, info, idx);
              break;
            } else {
              //非GPSフィールドをスキップ
              buffer.readBytes(10);
            }
          }
        } else {
          //Xmp
          String xmp = Utf8Decoder().convert(buffer.buffer);
          List<String> result = xmp.split(XmpItem.LargeClassification);
          if (result.length > 2) {
            info.putIfAbsent(
                XmpItem.LargeClassification, () => _getXmpItem(result[1]));
          }
          result = xmp.split(XmpItem.PhotoClassification);
          if (result.length > 2) {
            info.putIfAbsent(
                XmpItem.PhotoClassification, () => _getXmpItem(result[1]));
          }
        }
      });
    }
    return info;
  }

  ///GPS情報を読み取る
  readGpsBuffer(
      InputBuffer buffer, Endian endian, Map<String, dynamic> info, int idx) {
    buffer.readBytes(6);
    int offset = _getUInt32(buffer.readBytes(4).toUint8List(), endian);
    buffer.readBytes(offset - (idx + 1) * 12 - 10);
    int ifdItemCnt = _getInt16(buffer.readBytes(2).toUint8List(), endian);
    for (var ifdIdx = 0; ifdIdx < ifdItemCnt; ifdIdx++) {
      int ifdIdx = _getUInt16(buffer.readBytes(2).toUint8List(), endian);
      buffer.readBytes(6);
      int ifdOffset = 0;
      int flagOffset = 0;
      switch (ifdIdx) {
        case ExifTagItem.GPSLatitudeRef:
          info.putIfAbsent(
              ExifItem.TAG_GPS_LATITUDE_REF, () => _getGpsDirection(buffer));
          break;
        case ExifTagItem.GPSLatitude:
          ifdOffset = _getUInt32(buffer.readBytes(4).toUint8List(), endian);
          flagOffset = buffer.offset;
          info.putIfAbsent(ExifItem.TAG_GPS_LATITUDE,
              () => _getGpsPosition(buffer, ifdOffset, endian));
          buffer.offset = flagOffset;
          break;
        case ExifTagItem.GPSLongitudeRef:
          info.putIfAbsent(
              ExifItem.TAG_GPS_LONGITUDE_REF, () => _getGpsDirection(buffer));
          break;
        case ExifTagItem.GPSLongitude:
          ifdOffset = _getUInt32(buffer.readBytes(4).toUint8List(), endian);
          flagOffset = buffer.offset;
          info.putIfAbsent(ExifItem.TAG_GPS_LONGITUDE,
              () => _getGpsPosition(buffer, ifdOffset, endian));
          buffer.offset = flagOffset;
          break;
        default:
          buffer.readBytes(4);
          break;
      }
    }
  }

  int _getInt16(Uint8List data, Endian endian) {
    return ByteData.view(Uint8List.fromList(data).buffer).getInt16(0, endian);
  }

  int _getUInt16(Uint8List data, Endian endian) {
    return ByteData.view(Uint8List.fromList(data).buffer).getUint16(0, endian);
  }

  int _getUInt32(Uint8List data, Endian endian) {
    return ByteData.view(Uint8List.fromList(data).buffer).getUint32(0, endian);
  }

  ///XMPフィールドテキスト読みだし
  String _getXmpItem(String oldStr) {
    if (oldStr.length > 3) {
      int itemLen = oldStr.length - 2;
      return oldStr.substring(1, itemLen);
    }
    return "";
  }

  ///GPS方向読みだし
  String _getGpsDirection(InputBuffer buffer) {
    String gpsDirection = buffer.readString(2);
    buffer.readBytes(2);
    return gpsDirection;
  }

  ///GPS座標読みだし
  String _getGpsPosition(InputBuffer buffer, int ifdOffset, Endian endian) {
    buffer.readBytes(ifdOffset - buffer.offset + 6);
    double degree = _getUInt32(buffer.readBytes(4).toUint8List(), endian) /
        _getUInt32(buffer.readBytes(4).toUint8List(), endian);
    double mint = _getUInt32(buffer.readBytes(4).toUint8List(), endian) /
        _getUInt32(buffer.readBytes(4).toUint8List(), endian);
    double second = _getUInt32(buffer.readBytes(4).toUint8List(), endian) /
        _getUInt32(buffer.readBytes(4).toUint8List(), endian);
    return '${degree.toStringAsFixed(0)}°${mint.toStringAsFixed(0)}\'$second\"';
  }

  Future writeExif(String path, JpegExif exifInfo, {Map location}) async {
    FlutterExif flutterExif = FlutterExif(path);
    Map<String, dynamic> exifInfoMap = {
      ExifItem.TAG_IMAGE_DESCRIPTION: exifInfo.imageDescription,
      ExifItem.TAG_SOFTWARE: exifInfo.software,
      ExifItem.TAG_DATETIME_ORIGINAL: exifInfo.dateTimeOriginal,
    };
    if (location != null) {
      var lat;
      var lng;
      if (ApplicationProfile.isIos) {
        lat = location['lat'];
        lng = location['lng'];
      } else {
        lat = _gpsInfoConvert(location['lat']);
        lng = _gpsInfoConvert(location['lng']);
      }
      exifInfoMap.putIfAbsent(ExifItem.TAG_GPS_LATITUDE, () => lat);
      exifInfoMap.putIfAbsent(
          ExifItem.TAG_GPS_LATITUDE_REF, () => location['lat'] > 0 ? 'N' : 'S');
      exifInfoMap.putIfAbsent(ExifItem.TAG_GPS_LONGITUDE, () => lng);
      exifInfoMap.putIfAbsent(ExifItem.TAG_GPS_LONGITUDE_REF,
          () => location['lng'] > 0 ? 'E' : 'W');
    }
    await flutterExif.setExif(exifInfoMap);
    return;
  }

  getXml(BlackboardItem item) {
    var stringXml = '';
    Map listMain = getXmlGroup(item, 0);
    Map listDetermine = getXmlGroup(item, 1);
    Map listClassificationRemarks = getXmlGroup(item, 2);
    Map listRemarks = getXmlGroup(item, 3);
    stringXml = stringXml + '<x:xmpmeta xmlns:x="adobe:ns:meta/">';
    stringXml = stringXml +
        '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">';
    stringXml = stringXml +
        '<rdf:Description rdf:about="" xmlns:photo="http://dcpadv.org/schema/3.0/photoinfo" xmlns:measurement="http://dcpadv.org/schema/3.0/measurement" xmlns:item="http://dcpadv.org/schema/3.0/measurementitem">';
    listMain.forEach((key, value) {
      stringXml = stringXml +
          '<photo:' +
          key +
          '>' +
          value.toString() +
          '</photo:' +
          key +
          '>';
    });
    stringXml = stringXml + '<photo:ClassificationRemarks><rdf:Seq>';
    listClassificationRemarks.forEach((key, value) {
      stringXml = stringXml + '<rdf:li>' + value.toString() + '</rdf:li>';
    });
    stringXml = stringXml + '</rdf:Seq></photo:ClassificationRemarks>';
    stringXml = stringXml + '<photo:Measurements>';
    stringXml = stringXml + '<rdf:Description>';
    stringXml = stringXml +
        '<measurement:Classification>0</measurement:Classification>';
    stringXml = stringXml + '<measurement:MeasurementItems>';
    stringXml = stringXml + '<rdf:Seq>';
    stringXml = stringXml + '<rdf:li>';
    stringXml = stringXml + '<rdf:Description>';
    listDetermine.forEach((key, value) {
      stringXml = stringXml +
          '<item:' +
          key +
          '>' +
          value.toString() +
          '</item:' +
          key +
          '>';
    });
    stringXml = stringXml + '<item:Remarks><rdf:Seq>';
    listRemarks.forEach((key, value) {
      stringXml = stringXml + '<rdf:li>' + value.toString() + '</rdf:li>';
    });
    stringXml = stringXml + '</rdf:Seq></item:Remarks>';
    stringXml = stringXml + '</rdf:Description>';
    stringXml = stringXml + '</rdf:li>';
    stringXml = stringXml + '</rdf:Seq>';
    stringXml = stringXml + '</measurement:MeasurementItems>';
    stringXml = stringXml + '</rdf:Description>';
    stringXml = stringXml + '</photo:Measurements>';
    stringXml = stringXml + '</rdf:Description></rdf:RDF></x:xmpmeta>';
    return stringXml;
  }

  getXmlGroup(BlackboardItem item, int type) {
    Map listMain = new Map();
    Map listDetermine = new Map();
    Map listClassificationRemarks = new Map();
    Map listRemarks = new Map();
    listMain['Contructor'] = item.contructor != null ? item.contructor : '';
    listMain['LargeClassification'] =
        item.largeClassification != null ? item.largeClassification : '';
    listMain['PhotoClassification'] =
        item.photoClassification != null ? item.photoClassification : '';
    listMain['ConstructionType'] =
        item.constructionType != null ? item.constructionType : '';
    listMain['MiddleClassification'] =
        item.middleClassification != null ? item.middleClassification : '';
    listMain['SmallClassification'] =
        item.smallClassification != null ? item.smallClassification : '';
    listMain['Title'] = item.title != null ? item.title : '';
    listClassificationRemarks['ClassificationRemarks1'] =
        item.classificationRemarks1 != null ? item.classificationRemarks1 : '';
    listClassificationRemarks['ClassificationRemarks2'] =
        item.classificationRemarks2 != null ? item.classificationRemarks2 : '';
    listClassificationRemarks['ClassificationRemarks3'] =
        item.classificationRemarks3 != null ? item.classificationRemarks3 : '';
    listClassificationRemarks['ClassificationRemarks4'] =
        item.classificationRemarks4 != null ? item.classificationRemarks4 : '';
    listClassificationRemarks['ClassificationRemarks5'] =
        item.classificationRemarks5 != null ? item.classificationRemarks5 : '';
    listMain['ShootingSpot'] =
        item.shootingSpot != null ? item.shootingSpot : '';
    listMain['IsRepresentative'] =
        item.isRepresentative == 1 ? 'True' : 'False';
    listMain['IsFrequencyOfSubmission'] =
        item.isFrequencyOfSubmission == 1 ? 'True' : 'False';
    listMain['ContractorRemarks'] =
        item.contractorRemarks != null ? item.contractorRemarks : '';
    listMain['Classification'] =
        item.classification != null ? item.classification : '';
    listDetermine['Name'] = item.name != null ? item.name : '';
    listDetermine['Mark'] = item.mark != null ? item.mark : '';
    listDetermine['DesignedValue'] =
        item.designedValue != null ? item.designedValue : '';
    listDetermine['MeasuredValue'] =
        item.measuredValue != null ? item.measuredValue : '';
    listDetermine['UnitName'] = item.unitName != null ? item.unitName : '';
    listRemarks['Remarks1'] = item.remarks1 != null ? item.remarks1 : '';
    listRemarks['Remarks2'] = item.remarks2 != null ? item.remarks2 : '';
    listRemarks['Remarks3'] = item.remarks3 != null ? item.remarks3 : '';
    listRemarks['Remarks4'] = item.remarks4 != null ? item.remarks4 : '';
    listRemarks['Remarks5'] = item.remarks5 != null ? item.remarks5 : '';
    if (type == 0) {
      return listMain;
    } else if (type == 1) {
      return listDetermine;
    } else if (type == 2) {
      return listClassificationRemarks;
    } else if (type == 3) {
      return listRemarks;
    }
  }

  _gpsInfoConvert(num coordinate) {
    String sb = '';
    if (coordinate < 0) {
      coordinate = -coordinate;
    }
    num degrees = coordinate.floor();
    sb += degrees.toString() + '/1,';
    coordinate -= degrees;
    coordinate *= 60.0;
    num minutes = coordinate.floor();
    sb += minutes.toString() + '/1,';
    coordinate -= minutes.toDouble();

    coordinate *= 600000.0;
    sb += coordinate.floor().toString() + '/10000,';
    return sb;
  }

  Image getRealImage(Image srcImg) {
    Image dstImg = srcImg;
    if (srcImg.exif.data.containsKey(274)) {
      switch (srcImg.exif.data[274]) {
        case 2: //top_right
          dstImg = flip(srcImg, Flip.horizontal);
          break;
        case 3: //bottom_right
          dstImg = copyRotate(srcImg, 180);
          break;
        case 4: //bottom_left
          dstImg = flip(srcImg, Flip.vertical);
          break;
        case 5: //left_top
          dstImg = copyRotate(srcImg, 90);
          dstImg = flip(dstImg, Flip.horizontal);
          break;
        case 6: //right_top
          dstImg = copyRotate(srcImg, 90);
          break;
        case 7: //right_bottom
          dstImg = copyRotate(srcImg, 90);
          dstImg = flip(dstImg, Flip.vertical);
          break;
        case 8: //left_bottom
          dstImg = copyRotate(srcImg, 270);
          break;
      }
    }

    return dstImg;
  }

  Image retRotateImage(Image srcImg) {
    Image dstImg = srcImg;
    if (srcImg.exif.data.containsKey(274)) {
      switch (srcImg.exif.data[274]) {
        case 2: //top_right
          dstImg = flip(srcImg, Flip.horizontal);
          break;
        case 3: //bottom_right
          dstImg = copyRotate(srcImg, 180);
          break;
        case 4: //bottom_left
          dstImg = flip(srcImg, Flip.vertical);
          break;
        case 5: //left_top
          dstImg = copyRotate(srcImg, 270);
          dstImg = flip(dstImg, Flip.horizontal);
          break;
        case 6: //right_top
          dstImg = copyRotate(srcImg, 270);
          break;
        case 7: //right_bottom
          dstImg = copyRotate(srcImg, 270);
          dstImg = flip(dstImg, Flip.vertical);
          break;
        case 8: //left_bottom
          dstImg = copyRotate(srcImg, 90);
          break;
      }
    }

    return dstImg;
  }
}
