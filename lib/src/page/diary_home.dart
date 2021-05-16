import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockdiary/src/controller/ad_controller.dart';
import 'package:stockdiary/src/controller/stock_controller.dart';
import 'package:stockdiary/src/page/calendar.dart';
import 'package:stockdiary/src/page/month_memos.dart';
import 'package:stockdiary/src/page/stock_list.dart';

import 'ad_test.dart';

class DiaryHomePage extends StatefulWidget {
  const DiaryHomePage({Key key}) : super(key: key);
  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [MonthMemoPage(), StockListPage(), CalendarPage()];
  // final List<Widget> _children = [MonthMemoPage(), StockListPage(), AdTestPage()];

  void _onTap(int index) {
    if(index == 1) {
      final StockController _stockController = Get.find<StockController>();
      _stockController.getAllStockList();
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _children[_currentIndex],
          ),
          // AdTestPage(),
          SizedBox(height: 5)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: Color(0xff01CAB9),
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: '다이어리',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: '모아보기',
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.calendar_today),
            label: '메모',
          )
        ],
      ),
    );
  }
}
