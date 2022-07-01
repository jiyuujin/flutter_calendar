---
title: "Flutter パッケージ calendar_widget の開発"
---

カレンダーデータを生成する `calendar_logic` パッケージが完成したら、次はそれを使ってカレンダーの UI を構築する `Calendar` Widget を提供する `calendar_widget` パッケージを作成しましょう。

# Calendar の仕様

`Calendar` は、コンストラクタの引数 `date` に `DateTime` 型のオブジェクトを渡すことで、`date` が所属する月のカレンダーを表示する Widget です。

たとえば、以下のように記述すると、次のような UI が形成されます。

```dart
Calendar(date: DateTime(2022, 6)),
```

![Calendar が構築する UI](https://github.com/chooyan-eng/flutter_calendar/blob/main/books/calendar-package/images/flutter_calendar_widget.png?raw=true)

コンストラクタで受け取った `date` を元に 1 ヶ月分のカレンダーデータを生成するのも `Calendar` の役割です。これにより、 `Calendar` を利用する側はどのように 1 ヶ月分のデータを生成するのかを気にすることなく、とりあえず表示したい月を渡すだけでカレンダーの UI を実現できるようになり、とても便利です。

では、そんな `Calendar` を提供する `calendar_widget` パッケージを作成していきましょう。

# プロジェクトの作成

`flutter create` でパッケージプロジェクトを生成する際、それが `Widget` を提供する Flutter パッケージでも、ピュアな Dart パッケージでも実行するコマンドに変わりはありません。

`package_handson` ディレクトリで以下のコマンドを実行し、`calendar_widget` プロジェクトを作成してください。

```
$ flutter create -t package calendar_widget
```

`calendar_widget` プロジェクトが生成できたら、VS Code で開きましょう。

# dependencies の設定

`Calendar` を実装する前に、依存関係を設定します。

`Calendar` は中で `CalendarBuider` を利用してカレンダーデータを生成するため、あらかじめ `calendar_logic` パッケージをインストールしておく必要があります。

インストールの方法は通常 Flutter アプリを開発する場合と同様で、`pubspec.yaml` ファイルの `dependencies` にパッケージ名を記述すれば OK です。

ただし、今回インストールするのは `riverpod` のような pub リポジトリに公開済みのパッケージではなく、先ほど開発してローカルに保存してあるだけのパッケージであるため、 __「ローカルから読み込む」__ ための記述をしなければなりません。

`pubspec.yaml` の `dependencies` を以下のように修正してください。

```yaml:pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  calendar_logic:
    path:
      ../calendar_logic
```

`calendar_logic: ^1.0.0` のようにパッケージ名とバージョンを記述するのではなく、 `path: ../calendar_logic` とパッケージのパスを指定することで、__pub リポジトリではなく指定したパスからパッケージのソースコードを取得__ できます。

この方法は、たとえば社内専用の非公開のパッケージを開発する場合に利用できるだけでなく、実際に公開されている任意のパッケージのソースコードを GitHub からクローンして読み込む場合にも利用できます。それによってローカルで修正しながらデバッグしたり内部実装を理解したり、といった用途にも活用できるので、覚えておいて損はないでしょう。

他にも、`path` の代わりに `git` を指定することで、GitHub などインターネット上に存在する Git 管理されたリポジトリから直接読み取ることも可能です。

```yaml:pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  calendar_logic:
    git: https://github.com/chooyan-eng/calendar_logic.git
```

この他にも、ブランチを指定したり、リポジトリの特定のディレクトリ内のプロジェクトを読み込んだりと、細かい指定の方法が用意されています。詳しくは Dart 公式ドキュメントの [Package dependencies](https://dart.dev/tools/pub/dependencies) ページを参照してみてください。

ただし、依存するパッケージの取得先を `path` や `git` で指定したままの pub リポジトリへの公開はできません。以下のような警告が出ますので、指示に従って `pubspec.yaml` の先頭に、「このパッケージは公開用ではない」ことを表す `publish_to: none` の記述を追記してください。

```
Publishable packages can't have 'path' dependencies.
Try adding a 'publish_to: none' entry to mark the package as not for publishing or remove the path dependency.dart(invalid_dependency)
```

```yaml:pubspec.yaml
publish_to: none #追記
name: calendar_widget
description: A new Flutter package project.
version: 0.0.1
```

# コーディング

では、`Calendar` を実装していきましょう。

Widget クラスを作る場合でも、やることは通常 Flutter アプリを開発する上で自作の Widget クラスを作る場合と変わりはありません。

まずは、`lib/calendar_widget.dart` ファイルに自動生成される `Calculator` クラスの実装を削除し、以下のように `Calendar` クラスを `StatelessWidget` のサブクラスとして定義します。

```dart:calendar_widget.dart
library calendar_widget;

import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

次に、コンストラクタの引数として `DateTime` 型の `date` を受け取るようにします。`Calendar` クラスに `date` フィールドと引数を追加し、 `calendar_widget.dart` ファイルを以下のように修正してください。

```dart:calendar_widget.dart
library calendar_widget;

import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

なお、コンストラクタ内の `super.key` の書き方は Flutter 3 （正確には Dart 2.17）で追加された書き方であるため、Flutter 2.x を利用している場合など環境によってはエラーが出る場合があります。

その場合は以下のようにコンストラクタを修正してください。

```dart
const Calendar({
  Key? key,
  required this.date,
}) : super(key: key);
```

これで、先述した通りに `Calendar(date: DateTime(2022, 6))` のような呼び出し方ができるようになりました。

先ほどのチャプターと同様、ここから自分でコーディングしたい方は一度本を閉じていただき、実際に動くものを作ってしまいたいという方は以下のサンプルコードを参考にしながらコーディングしてみてください。

## カレンダーデータの生成

まずは受け取った `date` オブジェクトを元にカレンダーデータを生成しましょう。

Widget 内で利用するデータの生成処理のタイミングは、以下のように実装の内容によっていくつかのパターンが考えられます。

- `build` メソッド内で行う
- `Calendar` を `StatefulWidget` のサブクラスに変更し、 `initState` メソッド内で行う
- コンストラクタ内で変換してしまい、フィールドで保持する

ここで注意したいのは、通常アプリ開発で利用するような `provider` や `riverpod` などの状態管理パッケージは極力利用しない方がよいということです。

`calendar_widget` パッケージ自体が特定の状態管理パッケージの特定のバージョンに依存してしまうことで、`calendar_widget` パッケージを利用したいアプリのビルド時に依存関係の解決に問題が生じてしまう可能性があるためです。

パッケージを開発する際は、極力別のパッケージに依存しないことも念頭に設計するとよいでしょう。

さて、今回はこの中の __`build` メソッド内で行う__ 方法を採用します。本来 `build` メソッドで Widget の構築以外の処理をすることはアプリの処理効率の観点から好ましくはありませんが、今回は実装の容易さを重視します。

`Calendar` の `build` メソッドを以下のように修正してください。

```dart:calendar_widget.dart
@override
Widget build(BuildContext context) {
  final calendarData = CalendarBuilder().build(date);
  return Container();
}
```

インポートのエラーが出ますので、以下の `import` 文も追加します。

```dart
import 'package:calendar_logic/calendar_logic.dart';
```

あとは、この `calendar` を利用してカレンダーの UI を構築していきます。

## カレンダー UI 構築の方針

目的の UI を実装する手順はいろいろな方法が考えられますが、今回は以下のような流れで進めます。

1. 1 日分の枠を表す Widget を作成
2. 1 週間分の行を表す Widget を作成
3. 1 ヶ月全体のカレンダー UI を作成

細かい Widget から順番に作っていく流れですね。ではひとつずつコーディングしてみましょう。

## 1 日分の枠を表す Widget を作成

まずは、1 日分の枠を表す `_DateBox` を作ります。

`_DateBox` は指定した日付を正方形の枠内に表示する Widget で、要件としては以下のようになります。

- 正方形の枠を構築する
- 指定した文字列を枠の真ん中に表示する
- 枠線を表示する
- 土曜日の場合は枠内を青く、日曜日の場合は枠内を赤く塗りつぶす
- 「月」「火」といったヘッダ行も同じ `_DateBox` を使って表示する

そのため、引数を含めたクラスとコンストラクタの定義は以下のようになるでしょう。

```dart
class _DateBox extends StatelessWidget {
  const _DateBox(
    this.label, {
    required this.weekday,
  });

  /// 表示文字列（日付の他、「月」「火」といった曜日の場合もあり）
  final String label;

  /// 曜日（土曜日は青、日曜日は赤く塗りつぶす）
  final int weekday;

  @override
  Widget build(BuildContext context) {
    // TODO: UI を実装 
  }
}
```

あとは、これらの引数を使って `build` メソッドを実装します。

Widget の組み立て方に正解はありませんが、たとえば以下のようなコードで実現できます。

```dart
@override
Widget build(BuildContext context) {
  return AspectRatio(
    aspectRatio: 1, // 正方形にする
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 1),
        color: weekday == 6 // 土曜日は青
            ? Colors.blue.shade50
            : weekday == 7 // 日曜日は赤
                ? Colors.red.shade50
                : Colors.white, // その他は白
      ),
      child: Center(
        child: Text(label),
      ),
    ),
  );
}
```

ポイントとして、`_DateBox` 内ではサイズは指定しません。Flutter においては、__サイズの制約はなるべくその Widget を使う側が指定する__ ものであるからです。`Calendar` のサイズは使われ方によって変化することを考慮しつつ、具体的な値は指定しないようにしておきましょう。[^1]

そのかわり、`_DateBox` には `AspectRatio` で「正方形にする」とだけ指定しておくことで、利用する側が用意した幅（場合によっては高さ）に従って計算されたサイズで常に正方形の枠が確保されるようにしておきます。

## 1 週間分の列を表す Widget を作成

では次に、 `_DateBox` を 7 つ並べた「1 週間」を表す `_WeekRow` を作りましょう。

`_WeekRow` に必要なのは「1 週間分の表示文字列リスト」です。例えば 6 日 ~ 12 日の 1 週間分であれば `['6', '7', '8', '9', '10', '11', '12']` というリストになり、ヘッダ行であれば `['月', '火', '水', '木', '金', '土', '日']` です。

以上を踏まえた `_WeekRow` クラスの定義は以下のようになります。

```dart
class _WeekRow extends StatelessWidget {
  const _WeekRow(this.datesOfWeek);

  final List<String> datesOfWeek;

  @override
  Widget build(BuildContext context) {
    // TODO: UI を実装 
  }
}
```

次に、`build` メソッドを実装します。`_WeekRow` は `_DateBox` を横に並べるだけのシンプルな `Row` ですので、たとえば以下のような実装になります。

```dart
@override
Widget build(BuildContext context) {
  return Row(
    children: List.generate(
      datesOfWeek.length,
      (index) => Expanded(
        child: _DateBox(
          datesOfWeek[index], 
          weekday: index + 1, // 曜日は 1 始まりなので 1 を足す
        ),
      ),
    ).toList(),
  );
}
```

今回はリストの中身の他、「その要素が何番目か」という情報も曜日の判定に必要なため、`List.generate` を利用して `index` を受け取りつつ `Row` の `children` に渡す Widget のリストを生成しています。

また、各 `_DateBox` は `_WeekRow` に与えられた幅に対して可能な限り大きなサイズを確保するよう、`Expanded` で囲んでいます。

## 1 ヶ月全体のカレンダー UI を作成

最後に、1 ヶ月全体のカレンダー UI を担当する `Calendar` の `build` メソッドを実装しましょう。

`Calendar` の役割は、`CalendarBuilder` で生成したカレンダーデータを元に、ヘッダ行とその月の週の数だけ `_WeekRow` を縦に並べることです。

ヘッダ行はその場で曜日を表す文字のリストを生成して `_WeekRow` に渡すこととし、`build` メソッドは以下のようになります。

```dart
@override
Widget build(BuildContext context) {
  final calendarData = CalendarBuilder().build(date);

  return Column(
    children: [
      const _WeekRow(['月', '火', '水', '木', '金', '土', '日']),
      ...calendarData.map(
        (week) => _WeekRow(
          // 日付を文字列に変換。前後の月に所属する日付は null のため、その場合は空文字。
          week.map((date) => date?.toString() ?? '').toList(),
        ),
      ),
    ],
  );
}
```

以上です。

最後に、完成した `Calendar` クラス全体のソースコードを載せておきます。

```dart:calendar_widget.dart
library calendar_widget;

import 'package:calendar_logic/calendar_logic.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final calendarData = CalendarBuilder().build(date);

    return Column(
      children: [
        const _WeekRow(['月', '火', '水', '木', '金', '土', '日']),
        ...calendarData.map(
          (week) => _WeekRow(
            week.map((date) => date?.toString() ?? '').toList(),
          ),
        ),
      ],
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow(this.datesOfWeek);

  final List<String> datesOfWeek;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        datesOfWeek.length,
        (index) => Expanded(
          child: _DateBox(
            datesOfWeek[index],
            weekday: index + 1,
          ),
        ),
      ).toList(),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox(
    this.label, {
    required this.weekday,
    super.key,
  });

  final String label;
  final int weekday;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          color: weekday == 6
              ? Colors.blue.shade50
              : weekday == 7
                  ? Colors.red.shade50
                  : Colors.white,
        ),
        child: Center(
          child: Text(label),
        ),
      ),
    );
  }
}
```

# 動作確認する

Widget を提供する Flutter パッケージの動作確認方法は以下の 2 つが考えられます。

- Widget テストを書いて実行する
- example プロジェクトを作成する

ユニットテストと Widget テストの違いはあるものの、テストを書く場所や実行方法は前のチャプターと同様です。

ここでは、別の方法として `example` プロジェクトを作成してアプリを実行する方法で `Calendar` の見た目を確認していきましょう。

`example` プロジェクトを作ることで、実際のアプリで利用した場合にどのような見た目になるのかが確認できるだけでなく、`example` プロジェクトの `main.dart` はパッケージの公開時に pub.dev の "Example" タブに表示される仕組みになっているため、利用者に効果的にパッケージの使い方を伝えられます。

## example プロジェクトの作成

`example` プロジェクトは通常の Flutter アプリプロジェクトと同じように作成します。

VS Code のターミナルから、 `calendar_widget` プロジェクトのルートディレクトリで以下のコマンドを実行してください。

```
$ flutter create example
```

プロジェクトを作成したら、 `example/pubspec.yaml` に以下のように記述し、`calendar_widget` パッケージを取り込みましょう。


```yaml:example/pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  calendar_widget:
    path:
      ../
```

次に、`lib/main.dart` を以下のように修正します。

```dart:lib/main.dart
import 'package:calendar_widget/calendar_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const _CalendarSample(),
    );
  }
}

class _CalendarSample extends StatelessWidget {
  const _CalendarSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CalendarSample')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Calendar(date: DateTime(2022, 6)),
      ),
    );
  }
}
```

`example` アプリを実行し、以下のように表示できたら完成です。

![example アプリを実行](https://github.com/chooyan-eng/flutter_calendar/blob/main/books/calendar-package/images/calendar_widget_example.png?raw=true)

---

以上で `calendar_widget` パッケージの開発は完了です。次のチャプターではここまでに開発したパッケージを取り込んだ簡単なカレンダーアプリを作成します。

[^1]: Flutter の基本的な考え方として、`Everything is a Widget` というものがあります。そのため、Widget はどのような状況でも他の Widget と同じように扱えるのが理想です。`Calendar` も、例えば `Text` や `Icon` などと同じような感覚で使えることを意識して設計すると使い勝手がぐっと上がるはずです。
