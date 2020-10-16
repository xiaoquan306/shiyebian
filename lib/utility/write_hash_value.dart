import 'dart:ffi' as df;
import 'dart:io';

import 'package:ffi/ffi.dart' as f;

// load c library
final df.DynamicLibrary _writeHashLib = Platform.isAndroid
    ? df.DynamicLibrary.open("libwrite_hash.so")
    : df.DynamicLibrary.process();

/// bridging
final int Function(
        df.Pointer<f.Utf8> srcFilepath, df.Pointer<f.Utf8> destFilepath)
    _writeHashValue = _writeHashLib
        .lookup<
            df.NativeFunction<
                df.Int32 Function(df.Pointer<f.Utf8>,
                    df.Pointer<f.Utf8>)>>('JACIC_WriteHashValue')
        .asFunction();

/// Write hash value
///
/// Return value description:
/// * -101: 不正な引数が指定された場合
/// * -102: 読込元と出力先の画像ファイルパスが同じ
/// * -201: 読込元画像ファイルが存在しない
/// * -202: 出力先画像ファイルが既に存在する
/// * -203: ファイルオープン失敗
/// * -204: 読み込んだファイルサイズがゼロ
/// * -205: ファイル書き込み失敗
/// * -206: ファイルのクローズに失敗
/// * -301: Exif フォーマットが不正
/// * -302: APP5 セグメントが既に存在する
/// * -900: その他のエラー
int writeHashValue(srcFilepath, destFilepath) {
  return _writeHashValue(
      f.Utf8.toUtf8(srcFilepath), f.Utf8.toUtf8(destFilepath));
}
