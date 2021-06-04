# Firebaseの環境切り替えについて(dev, release)

下記の設定を行うと、debugビルド時はschedule-app-dev、releaseビルド時はschedule-appのFirebaseプロジェクトへ接続されるようになります。


## 導入方法(Android)

以下のそれぞれのディレクトリにgoogle-services.jsonをコピーする。
android/app/src/debug/
android/app/src/release/ (ディレクトリがなければ作成する)

## 導入方法(iOS)

XcodeでRunner/Runner直下に以下のそれぞれのファイルをコピーする(Firebaseからダウンロードしたものをリネームする)。

GoogleService-Info-dev.plist
GoogleService-Info-release.plist