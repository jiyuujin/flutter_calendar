import 'package:calendar_widget/calendar_widget.dart';
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

  var _currentDate = DateTime.now();

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
}

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
