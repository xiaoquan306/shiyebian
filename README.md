# 電子小黒板 APP

Futter（bloc）開発に基づいて、Android Studio＋Futter Pluginの開発を推奨します。

## 1. 開発環境のインストール

Flutter-SDK

- [Windows](https://flutter.dev/docs/get-started/install/windows)
- [macOS](https://flutter.dev/docs/get-started/install/macos)
- [Linux](https://flutter.dev/docs/get-started/install/linux)

Android Studio

- [Android Studio Install](https://developer.android.com/studio)
- Flutter & Dart Plugins
  - Android Studio Menu > File > Settings > Plugins
  - 「Flutter」を検索してインストール
  - Restart Android Studio


## 2. 開発環境の設定(Android Studio)

1. Android Studio Menu > Run > Edit Configurations... > Add(+) > Flutter

```
Name: main
Dart entrypoint: /PATH/TO/site_blackboard_app/lib/app/main.dart
```

2. 複製「.env.sample」->「.env」、設定パラメータを変更

3. Android Studio Menu > Run > Run 'main'
