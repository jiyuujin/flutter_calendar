---
title: "環境構築"
---

# Flutter 環境構築

順に進めていきましょう。

- Mac をお使いの方
- Windows をお使いの方
- OS 共通

## Mac をお使いの方

### パスを通す

`.bash_profile` を vi で開いて以下コマンドを叩きます。

```bash
mkdir ~/project
```

USER に置き換えて `PATH` を追加します。

```bash
export PATH="$PATH:/Users/<USER>/project/flutter/bin"
```

`PATH` を更新して以下コマンドを叩きます。

```bash
source ~/.bash_profile
```

### エディタをインストールする

それぞれ使用するエディタを任意の場所に `.dmg` をダウンロードします。

- [Download Android Studio](https://developer.android.com/studio/?hl=ja)
- [Download Mac Universal | Visual Studio Code](https://code.visualstudio.com/)

インストールウィザードの指示に従ってインストールします。初回起動時に SDK のインストールウィザードが出るが `Standard` を選択肢デフォルトの設定でインストールします。

### OS 共通へ進む

[OS共通へ進む](#os共通)

## Windows をお使いの方

### パスを通す

`C:\Program Files` のようにアクセス許可が必要な場所で行うと失敗する可能性があるので注意してください。

C 直下に `project` フォルダを作成、ダウンロードした `C:\project` 直下に解凍します。そして `bin` フォルダを環境変数に追加します。

### エディタをインストールする

それぞれ使用するエディタを任意の場所に `.exe` をダウンロードします。

- [Download Android Studio](https://developer.android.com/studio/?hl=ja)
- [Download Mac Universal | Visual Studio Code](https://code.visualstudio.com/)

インストールウィザードの指示に従ってインストールします。初回起動時に SDK のインストールウィザードが出るが `Standard` を選択肢デフォルトの設定でインストールします。

:::details HAXM のインストールでエラーが出る場合。

コマンドプロンプトを管理者権限で開きます。

`bcdedit/set hypervisorlaunchtype off` コマンドを叩きす。

BIOS を起動して VT-x を有効化、 SDK Tools で HAXM にチェックを入れます。

:::

### OS 共通へ進む

[OS共通へ進む](#os共通)

## OS 共通

### `flutter doctor --android-licenses`

Windows をお使いの方は `C:\src\flutterflutter_console.bat` を起動しそちらで叩きます。

```bash
flutter doctor --android-licenses
```

### リポジトリを利用する

こちら [リポジトリ URL](https://gitpod.io/#https://github.com/jiyuujin/template_flutter) から進めます。

https://github.com/jiyuujin/template_flutter
