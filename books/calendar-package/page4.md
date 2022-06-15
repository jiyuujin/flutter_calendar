---
title: "Dart パッケージ calendar_logic の開発"
---

それでは、1 ヶ月分のカレンダーデータを生成する `CalendarBuilder` クラスを提供する `calendar_logic` パッケージを開発しましょう。

# CalendarBuilder クラスの仕様

`CalendarBuilder` クラスは、`DateTime` 型のオブジェクトを引数として受け取り、その `DateTime` オブジェクトが所属する月の 1 ヶ月分のカレンダーデータを `List<List<int?>>` 型で返却する `build()` メソッドを提供します。

利用側のコードは以下のようになります。

```dart
final calendarBuilder = CalendarBuilder();
final data = calendarBuilder.build(DateTime(2022, 6, 1));
print(data);
```

上記のコードの実行結果は以下の通りです。

```
[
    [null, null, 1, 2, 3, 4, 5], 
    [6, 7, 8, 9, 10, 11, 12], 
    [13, 14, 15, 16, 17, 18, 19], 
    [20, 21, 22, 23, 24, 25, 26], 
    [27, 28, 29, 30, null, null, null]
]
```

2022 年 6 月の実際のカレンダーを確認すると、6/1(水)をスタートとし、5 週目の 6/30(木)が最終日となっています。

`build` メソッドの出力は月曜日を最初として 1 週間分が 1 つの `int?` 型のリストとなっていて、それが週の数だけさらにリストになっています。また、別の月に所属する箇所は `null` になる仕様となっています。

`CalendarBuilder` の仕様はわかったでしょうか。それでは、このようなクラスを提供する `calendar_logic` パッケージを実際に作っていきましょう。

# プロジェクトの作成

今回のハンズオンでは、`package_handson` ディレクトリを任意の場所に作成し、その中に各プロジェクトを配置する以下のようなディレクトリ構成を前提として進めます。

```
package_handson
  |- calendar_logic
  |- calendar_widget
  |- flutter_calendar
```

`package_handson` ディレクトリを任意の場所に作成したら、ターミナルから以下のコマンドで `calendar_logic` プロジェクトを作成します。

```
$ cd calenar_handson
$ flutter create -t package calendar_logic
```

最後に以下のメッセージが出たら OK です。

```
All done!
Your package code is in calendar_logic/lib/calendar_logic.dart
```

それでは、作成した `calendar_logic` プロジェクトを VS Code で開いてください。

# プロジェクト構成の確認

前のチャプターで説明した通り、Dart パッケージプロジェクトにはソースコードだけでなく `README.md` や `LICENSE` などさまざまなファイルが配置されています。

```
calendar_logic $ ls

CHANGELOG.md		analysis_options.yaml	pubspec.lock
LICENSE			calendar_logic.iml	pubspec.yaml
README.md		lib			test
```

パッケージを実際に公開する際はこれらのファイルに適切な記述をする必要がありますが、今回のハンズオンの内容に公開は含まれないため、一旦個別のファイルは置いておいて、ソースコードが置かれている `lib/calendar_logic.dart` を開いてみましょう。

自動生成された状態のコードは以下の通りです。

```dart:calendar_logic.dart
library calendar_logic;

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
```

`libarary` ディレクティブが記述されている以外は通常の Dart コードであることがわかるのではないかと思います。

では、このファイルを修正して `CalendarBuilder` クラスと `build` メソッドを作成していきましょう。

# コーディング

先述の通り、このパッケージが公開するのは以下の 2 つだけです。

- `CalendarBuilder` クラス
- `build` メソッド

`lib/calendar_logic.dart` ファイルを以下のように修正してください。コメントは任意ですが、pub.dev は __public なクラス、フィールド、メソッドにドキュメントとしてコメントが記述されていること__ を PUB POINTS の評価対象としているため、pub.dev への公開を考える場合は記述するクセをつけるとよいでしょう。[^1]

```dart:calendar_logic.dart
/// 1ヶ月分のカレンダーを生成するクラス
class CalendarBuilder {
  /// [date]が表す日が所属する月のカレンダーを生成します
  List<List<int?>> build(DateTime date) {
  }
}
```

さて、ここからは先述の仕様に従っている限りコードの内容は自由です。自分で考えながらコーディングしてみたい方はここで Book を閉じてみるのも良いでしょう。

実際に動くものを一旦作ってしまいたいという方は、以下のサンプルコードを参考にしながらコーディングしてみてください。

## 返却するリストを定義

まずは、`build` メソッドが返却するカレンダーを表す `List<List<int?>>` 型のオブジェクトを定義し、戻り値として `return` するコードを書いてしまいましょう。

```dart:calendar_logic.dart
List<List<int?>> build(DateTime date) {
  final calendar = <List<int?>>[];
  return calendar;
}
```

## カレンダーを決定する 2 つの要素を求める

返却すべきリストができたら、具体的なデータをそこに詰めていきます。

カレンダーの数値は必ず順番に並んでいますので、基本的には以下の情報があれば機械的にデータを生成できそうです。

- 一日（いっぴ）が何曜日か
- 最後は何日か

これらを明らかにする private なメソッドを定義し、それぞれに処理を書いていきましょう。ここでは一日の曜日を求めるメソッドを `_calcFirstWeekday`、最後の日を求めるメソッドを `_calcLastDate` としています。

```dart:calendar_logic.dart
List<List<int?>> build(DateTime date) {
  final calendar = <List<int?>>[];

  final firstWeekday = _calcFirstWeekday(date);
  final lastDate = _calcLastDate(date);

  return calendar;
}

/// [date] が所属する月の一日の曜日を計算します。
/// 月曜日を 1 とし、日曜日は 7 です。
int _calcFirstWeekday(DateTime date) {
}

/// [date] が所属する月の最後の日を計算します。
int _calcLastDate(DateTime date) {
}
```

順番に各メソッドを実装します。

### _calcFirstWeekday

曜日の情報は `DateTime` オブジェクトが保持しています。例えば、「2022 年 6 月 10 日」の曜日は以下のように取得できます。

```dart
// 2022/6/10 は金曜日
final weekday = DateTime(2022, 6, 10).weekday;
print(weekday); // -> 5 
```

この仕組みを利用することで、その月の最初の曜日は以下の手順で計算できます。

- 引数で受け取った `date` オブジェクトの年と月は保持しつつ、日が 1 である新しい `DateTime` オブジェクトを生成する。
- そのオブジェクトの `.weekday` を呼び出す。

つまり、`_calcFirstWeekday` メソッドは以下のように実装できます。

```dart:calendar_logic.dart
/// [date] が所属する月の一日の曜日を計算します。
/// 月曜日を 1 とし、日曜日は 7 です。
int _calcFirstWeekday(DateTime date) {
  return DateTime(date.year, date.month, 1).weekday;
}
```

### _calcLastDate

ある月の最後の日付を計算するのは少々複雑です。その月は 31 日までかもしれませんし、28 日かもしれません。閏年には 2 月は 29 日までになったりもします。この辺りをすべて考慮したロジックを書くのは少々面倒です。

そこで、 Dart の `DateTime` クラスの性質を利用します。

先ほど、その月の一日を計算するために `DateTime` のコンストラクタの `date` の部分に `1` を渡しましたが、ここを `0` にすると、 __前の月の最終日__ を表す `DateTime` オブジェクトが生成されます。

```dart
final lastDayOfLastMonth = DateTime(2022, 6, 0);
print(lastDayOfLastMonth); // -> 2022-05-31 00:00:00.000
```

つまり、引数で受け取った `date` オブジェクトが所属する月の最終日は以下のような実装で計算できます。

```dart
/// [date] が所属する月の最後の日を計算します。
int _calcLastDate(DateTime date) {
  return DateTime(date.year, date.month + 1, 0).day;
}
```

これで、以下の 2 つの情報が計算できました。

- 一日（いっぴ）が何曜日か
- 最後は何日か

これらを使ってカレンダーを生成していきましょう。

### 1 週目のカレンダーデータを生成する

各週のデータを生成する上で、 1 週目は少し特殊です。開始が月曜日ではないためです。そこで、1 週目は個別にデータを生成するのが分かりやすいでしょう。

1 週目のデータは以下のように生成します。

- その月の一日より前はすべて `null`
- 一日を `1` とし、日曜日になるまでインクリメントした日付を埋める

これをコードで表現するために `List.generate` メソッドを利用してみましょう。

`List.generate` メソッドは、第 1 引数に指定した `length` の数だけ第 2 引数の `generator` 関数が呼び出されます。そして、その `generator` 関数の戻り値を集めたリストが生成され、 `List.generate` 全体の戻り値となる、という仕組みです。

```dart
final generatedList = List.generate(7, (index) => 'dart');
print(generatedList); // -> ['dart','dart','dart','dart','dart','dart','dart']
```

`generator` 関数の引数 `index` には、「現在何回目の呼び出しか」が 0 はじまりの整数で渡されるため、それを利用して生成するリストのひとつひとつの要素を変化させることも可能です。

```dart
final generatedList = List.generate(7, (index) => index < 3 ? null : index); // index < 3 の場合は null
print(generatedList); // -> [null, null, null, 3, 4, 5, 6]
```

つまり、`generator` 関数で「`index` の値が一日の曜日よりも小さければ `null` を、そうでなければ `1` から始まる数値を返す」処理を書けば 1 週目のカレンダーが生成できそうです。

たとえば以下のように実装します。

```dart
final firstWeek = List.generate(7, (index) {
  final i = index + 1; // index は 0 はじまりのため、1 はじまりの曜日と合わせる
  final offset = i - firstWeekday; // 一日の曜日との差
  return i < firstWeekday ? null : 1 + offset;
});
```

さいごに生成された 1 週目のデータを `calendar` に追加し、できあがった `build` メソッドの実装は以下の通りです。

```dart:calendar_logic.dart
List<List<int?>> build(DateTime date) {
  final calendar = <List<int?>>[];

  final firstWeekday = _calcFirstWeekday(date);
  final lastDate = _calcLastDate(date);

  final firstWeek = List.generate(7, (index) {
    final i = index + 1; // index は 0 はじまりのため、1 はじまりの曜日と合わせる
    final offset = i - firstWeekday; // 一日の曜日との差
    return i < firstWeekday ? null : 1 + offset;
  });

  calendar.add(firstWeek);

  return calendar;
}
```

### 2 週目以降のカレンダーデータを生成する

1 週目のカレンダーができたら、2 週目以降は `lastDate` に達するまで 1 週 7 日間のリストを作っては `calendar` リストに追加するのみです。

いろいろな実装方法が考えられますが、例として `List.generate` と while ループを使って以下のように書いてみます。

```dart
while(true) {
  final firstDateOfWeek = calendar.last.last! + 1; // 前の週の最終日の次の日がスタート

  final week = List.generate(7, (index) {
    final date = firstDateOfWeek + index; // 追加する日付
    return date <= lastDate ? date : null; // 最終日以前なら採用、それ以降は null
  });

  calendar.add(week); // 週のリストを月のリストに追加

  // すでに最終日まで追加し終わっていたら終了
  final lastDateOfWeek = week.last;
  if (lastDateOfWeek == null || lastDateOfWeek >= lastDate) {
    break;
  }
}
```

---

以上です。最終的な `calendar_logic.dart` ファイルのソースコードは以下の通りです。

```dart:calendar_logic.dart
/// 1ヶ月分のカレンダーを生成するクラス
class CalendarBuilder {
  /// [date]が表す日が所属する月のカレンダーを生成します
  List<List<int?>> build(DateTime date) {
    final calendar = <List<int?>>[];

    final firstWeekday = _calcFirstWeekday(date);
    final lastDate = _calcLastDate(date);

    final firstWeek = List.generate(7, (index) {
      final i = index + 1; // index は 0 はじまりのため、1 はじまりの曜日と合わせる
      final offset = i - firstWeekday; // 一日の曜日との差
      return i < firstWeekday ? null : 1 + offset;
    });

    calendar.add(firstWeek);

    while (true) {
      final firstDateOfWeek = calendar.last.last! + 1; // 前の週の最終日の次の日がスタート

      final week = List.generate(7, (index) {
        final date = firstDateOfWeek + index; // 追加する日付
        return date <= lastDate ? date : null; // 最終日以前なら採用、それ以降は null
      });

      calendar.add(week); // 週のリストを月のリストに追加

      // すでに最終日まで追加し終わっていたら終了
      final lastDateOfWeek = week.last;
      if (lastDateOfWeek == null || lastDateOfWeek >= lastDate) {
        break;
      }
    }

    return calendar;
  }

  /// [date] が所属する月の一日の曜日を計算します。
  /// 月曜日を 1 とし、日曜日は 7 です。
  int _calcFirstWeekday(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday;
  }

  /// [date] が所属する月の最後の日を計算します。
  int _calcLastDate(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }
}
```

[^1]: 本来であればコメントは英語で書くことが望ましいですが、このハンズオンでは分かりやすさを優先して日本語で書いています。