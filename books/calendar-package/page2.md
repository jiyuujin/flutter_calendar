---
title: "Flutter 環境構築"
---

Flutter の開発環境が整っていない方は、このチャプターからスタートしてください。

すでに `flutter create` コマンドでのプロジェクト作成と、`flutter run` コマンドによるアプリのデバッグ実行ができる状態になっている方は次のチャプターまで飛ばしてしまって問題ありません。

# Flutter 環境構築

順に進めていきましょう。

- SDK をインストールする
- パスを通す
- エディタ (今回使う Visual Studio Code) をインストールする
- リポジトリ (今回使うテンプレート) をクローンする
- 拡張機能をインストールする

## SDK をインストールする

各自の環境に合わせて SDK をダウンロード、それぞれの環境でインストールしてください。

なお、今回の Flutter バージョンは `3.0.0-stable` を使う予定です。

- macOS
   - [SDK for Intel](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.0.0-stable.zip)
   - [SDK for Apple Silicon](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.0.0-stable.zip)
- Windows
   - [SDK](https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.0-stable.zip)

## パスを通す

### Mac をお使いの方

`.bash_profile` を vi で開いて以下コマンドを叩きます。

```bash
mkdir ~/project
```

`<USER>` を個別のユーザー名に置き換えて `PATH` を追加します。

```bash
export PATH="$PATH:/Users/<USER>/project/flutter/bin"
```

`PATH` を更新して以下コマンドを叩きます。

```bash
source ~/.bash_profile
```

### Windows をお使いの方

`C:\Program Files` のようにアクセス許可が必要な場所で行うと失敗する可能性があるので注意してください。

C 直下に `project` フォルダを作成、ダウンロードした `C:\project` 直下に解凍します。そして `bin` フォルダを環境変数に追加します。

## エディタをインストールする

:::message

今回のハンズオンでは [Visual Studio Code](https://code.visualstudio.com/) (以下 VS Code と呼ぶ) を使います。

:::

それぞれ使用するエディタを任意の場所に `.dmg` (Windows をお使いの方は `.exe`) をダウンロードします。

https://code.visualstudio.com/

:::details HAXM のインストールでエラーが出る場合。

コマンドプロンプトを管理者権限で開きます。

`bcdedit/set hypervisorlaunchtype off` コマンドを叩きす。

BIOS を起動して VT-x を有効化、 SDK Tools で HAXM にチェックを入れます。

:::

## `flutter doctor --android-licenses`

Windows をお使いの方は `C:\src\flutterflutter_console.bat` を起動しそちらで叩きます。

```bash
flutter doctor --android-licenses
```

## リポジトリをクローンする

こちら [リポジトリ URL](https://gitpod.io/#https://github.com/jiyuujin/template_flutter) から進めます。

https://github.com/jiyuujin/template_flutter

## 拡張機能をインストールする

VS Code では、拡張機能も合わせてインストールしないと、勿体無いです。

中でも下に示す拡張機能は Flutter 公式のものです。

https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

折角なので入れておきましょう。

### VS Code で操作する

ウィンドウ左に存在する `拡張機能: マーケットプレイス` をクリックします。

そこで `flutter` と検索すると、トップに表示されるはずです。

![](https://i.imgur.com/PtREPPQ.png)

### その他

もちろんこれだけをインストールすれば良いというものでは無いが、掻い摘んで列挙してみました。

- Awesome Flutter Snippets
- Flutter Tree
- Flutter Widget Snippets

#### Awesome Flutter Snippets

Flutter 開発の定番といえばこれ、と言える拡張機能です。

https://marketplace.visualstudio.com/items?itemName=Nash.awesome-flutter-snippets

#### Flutter Tree

Widget 名を `>` で継ぎ足して入力することで、自動的にコード整形してくれます。

https://marketplace.visualstudio.com/items?itemName=marcelovelasquez.flutter-tree

:::details そもそも Widget とは。

Flutter の UI は、各パーツが Widget として構成されています。

公式ウェブサイトにも [その旨](https://docs.flutter.dev/resources/architectural-overview#widgets) が記載されています。

> Flutter emphasizes widgets as a unit of composition. Widgets are the building blocks of a Flutter app’s user interface, and each widget is an immutable declaration of part of the user interface.

上の記述を日本語に訳すと Flutter は構成の単位として Widget を重視しています。 Widget は Flutter アプリのユーザーインタフェース (UI) の構成要素であり、各 Widget はユーザーインタフェースの一部のイミュータブルな宣言となることが書かれています。

:::

#### Flutter Widget Snippets

Widget 名を入力することで、必要なプロパティを自動的にコード整形してくれます。

https://marketplace.visualstudio.com/items?itemName=alexisvt.flutter-snippets
