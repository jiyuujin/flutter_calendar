---
title: "Flutter アプリ flutter_calendar の開発"
---

では最後に、ここまでに開発した `calendar_widget` パッケージを使って簡単なカレンダー表示アプリを作ってみましょう。

ここで作るアプリは、以下のように 1 ヶ月ずつ前後に移動しながらその月のカレンダーを表示する、というものです。


![カレンダーアプリのデモ](https://github.com/chooyan-eng/flutter_calendar/blob/main/books/calendar-package/images/flutter_calendar_app.png?raw=true)

本来であればその月のカレンダーデータを算出し、それを元にカレンダー UI を構築する部分までをアプリ内に実装する必要がありますが、今回はすでにパッケージが用意できているためとても簡単にアプリ開発が進められます。

一方で、ユーザーの操作に応じて表示する月を変化させる部分については `flutter_calendar` アプリ固有の挙動であるため、この部分のコーディングに集中して開発を進めましょう。

# プロジェクトの作成

`flutter create` コマンドで `flutter_calendar` プロジェクトを作成します。`package_handson` ディレクトリに移動して、以下のコマンドを実行してください。

```
$ flutter create flutter_calendar
```

プロジェクトが作成できたらいつものように VS Code でプロジェクトを開きましょう。

# パッケージのインストール

まずは `pubspec.yaml` を編集してパッケージをイストールします。

ここでインストールするのは前のチャプターで開発した `calendar_widget` パッケージです。`calendar_logic` は `calendar_widget` の中で使われるものの、アプリが直接使うわけではないため不要です。

`pubspec.yaml` の `dependencies` を以下のように修正してください。

```yaml:pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  calendar_widget:
    path:
      ../calendar_widget
```

ここでも `path` でインストール先を指定することで、pub リポジトリではなくローカルのディレクトリからインストール対象のパッケージを指定しています。

ここまでのアプリとパッケージの依存関係を整理すると以下の図のようになります。

![依存関係の図（再掲）](https://github.com/chooyan-eng/flutter_calendar/blob/main/books/calendar-package/images/flutter_calendar_dependencies.png?raw=true)

# アプリの開発

では、カウンターアプリが記述された `main.dart` を修正してカレンダーアプリを作っていきましょう。

## 下準備

まずは下準備として、 `main.dart` に生成されるカウンターアプリを、以下のように修正してください。修正箇所はコメントで説明しています。

```dart:main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 自動生成されたコメントは全て削除
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar', // アプリのタイトルを修正
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(), // home 引数に指定する Widget を CalendarPage に変更
    );
  }
}

// MyHomePage を CalendarPage に変更（StatefulWidget のまま）
class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

// _MyHomePageState を _CalendarPageState に変更
class _CalendarPageState extends State<CalendarPage> {

  // カウンター用のプロパティとメソッドは全て削除

  @override
  Widget build(BuildContext context) {
    // build 内の処理も一度すべて削除
  }
}
```

## 必要なフィールドとメソッドの定義

UI を構築する前に、カレンダーの切り替えに必要なフィールド（状態）の定義とそれを操作するメソッドを用意しましょう。

今回のアプリは「指定した月」のカレンダーを表示し、それをユーザーの操作で「前後の月に移動できる」アプリであるため、以下のフィールドとメソッドが必要です。

- フィールド
  - 現在表示中の月を保持する `DateTime` 型の `_currentMonth` フィールド
- メソッド
  - `_currentMonth` を次の月に進める `_toNextMonth` メソッド
  - `_currentMonth` を前の月に戻す `_toPreviousMonth` メソッド

それでは、実装していきましょう。

### フィールド

まずは「現在表示中の月」という状態を表す `_currentMonth` フィールドです。初期値は現在時刻ということにして、`_CalendarPageState` に以下のように定義します。

```dart:main.dart
class _CalendarPageState extends State<CalendarPage> {
  var _currentDate = DateTime.now();

  （省略）
}
```

### メソッド

次に `_toNextMonth` と `_toPreviousMonth` メソッドです。

dart の `DateTime` クラスは、年と月を指定してオブジェクトの生成ができます。たとえば「2022 年 6 月」という情報を持った `_currentMonth` の次の月を表す `DateTime` オブジェクトを生成するには以下のように記述します。

```dart
DateTime(_currentMonth.year, _currentMonth.month + 1)
```

この処理は、`_currentMonth.month` が 12 の場合でも問題ありません。「2022 年 13 月」は自動的に「2023 年 1 月」と解釈されるためです。

```dart
print(DateTime(2022, 12 + 1)); // -> 2023-01-01 00:00:00.000
```

この性質を利用し、`_toNextMonth` と `_toPreviousMonth` メソッドを以下のように実装します。

```dart:main.dart
void _toNextMonth() {
  setState(() {
    _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
  });
}

void _toPreviousMonth() {
  setState(() {
    _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
  });
}
```

`_currentDate` を変更した結果リビルドが必要になりますので、`setState(() {})` で囲うのを忘れないでください。

これで、ユーザーの操作に合わせて UI を変化させる準備が整いました。

## UI の構築

では、`Calendar` を使ったカレンダー表示 UI の構築をしていきましょう。

まずは、カレンダーの上に表示する月の移動アイコンと現在の月を表す Widget を `_CalendarController` として用意しましょう。

![_CalendarController で構築する UI](https://github.com/chooyan-eng/flutter_calendar/blob/main/books/calendar-package/images/calendar_controller.png?raw=true)

左右それぞれのアイコンがタップされた際の処理は、コールバックとして `_CalendarPageState` に処理させる作りとします。

それらのコールバックと現在表示中の月を示す文字列を引数とし、以下のように `_CalendarController` を実装してください。

```dart:main.dart
class _CalendarController extends StatelessWidget {
  const _CalendarController({
    required this.currentMonth,
    required this.onPreviousTap,
    required this.onNextTap,
  });

  /// 現在の年月として表示する文字列
  final String currentMonth;

  /// 「前の月へ」アイコンがタップされた場合のコールバック
  final VoidCallback onPreviousTap;

  /// 「次の月へ」アイコンがタップされた場合のコールバック
  final VoidCallback onNextTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 「前の月へ」アイコン
        InkWell(
          onTap: onPreviousTap,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.navigate_before),
          ),
        ),
        // 現在表示中の年月
        Expanded(
          child: Center(
            child: Text(currentMonth),
          ),
        ),
        // 「次の月へ」アイコン
        InkWell(
          onTap: onNextTap,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.navigate_next),
          ),
        ),
      ],
    );
  }
}
```

この `_CalendarController` を使う部分のコードは以下のようになります。

```dart
_CalendarController(
  currentMonth: '${_currentDate.year}年 ${_currentDate.month}月',
  onNextTap: _toNextMonth,
  onPreviousTap: _toPreviousMonth,
),
```

各コールバックには先ほど実装した `_toNextMonth` `_toPreviousMonth` メソッドをそのまま渡してあげればよいでしょう。

次にカレンダー部分です。カレンダーの UI には `calendar_widget` パッケージの `Calendar` を利用しますが、先ほど実装した通り `Calendar` は引数として「表示したい月」を表す `DateTime` オブジェクトを受け取ります。今回のアプリでは以下のように `_currentMonth` をそのまま渡してあげれば OK です。

```dart
Calendar(_currentMonth)
```

では最後に、この `_CalendarController` と `Calendar` を縦に並べたページを `Scaffold` で構築してあげれば UI は完成です。ついでに余白も調整してレイアウトを整えておきましょう。

`_CalendarPageState` の `build` メソッドを以下のように実装してください。

```dart:main.dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Calendar')),
    body: SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _CalendarController(
              currentMonth: '${_currentDate.year}年 ${_currentDate.month}月',
              onNextTap: _toNextMonth,
              onPreviousTap: _toPreviousMonth,
            ),
            Calendar(date: _currentDate),
          ],
        ),
      ),
    ),
  );
}
```

ここまで実装できたら動作確認をしてみましょう。

`main.dart` の最終的なコードは以下を参照してください。

https://github.com/chooyan-eng/flutter_calendar/blob/main/lib/main.dart

# まとめ

お疲れ様でした！これで、UI を持たない `calendar_logic` の実装から始まったパッケージ開発と、それを使ったアプリ開発は完了です。

Dart のみで実装されたパッケージであれば、別の内容のパッケージでもこのハンズオンの内容を元に開発できるはずです。私が公開している `crop_your_image` も同じように開発しています。

実際に作って公開してみたいパッケージがある方は、このままパッケージ側の開発を進め、最後は以下のドキュメントを元に pub.dev への公開までチャレンジしてみてください。

https://docs.flutter.dev/development/packages-and-plugins/developing-packages

いろいろ書いてありますが、最終的に必要なのは以下の 2 ステップです。

1. `README` や `pubspec.yaml` など各ファイルにパッケージの情報を記述する
1. `flutter pub publish` コマンドで公開する

特に前者は英語でいろいろと書かなければならないため少し大変ですが、その分世界中の Flutter アプリ開発者の目にとまることを目指し挑戦してみてください。私も毎回頑張って書いています。

このハンズオンがみなさんの開発の幅を広げ、世界の Flutter コミュニティを盛り上げるひとつのきっかけになれたら嬉しいです。