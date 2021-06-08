import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockdiary/src/component/divider.dart';
import 'package:stockdiary/src/component/stock_list.dart';
import 'package:stockdiary/src/controller/diary_controller.dart';
import 'package:stockdiary/src/model/stock.dart';
import 'package:stockdiary/src/page/edit_diary.dart';
import 'package:stockdiary/src/utils/common_utils.dart';

class DiaryDetail extends StatelessWidget {
  final DiaryController _diaryController = Get.put(DiaryController());
  final CommonUtils _utils = CommonUtils();
  final id;

  DiaryDetail({this.id});

  Widget _body() {
    List<Stock> list = _diaryController.stockList;

    return SingleChildScrollView(
      child: Container(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              showDate(),
              _description(),
              DividerComponent(),
              for (int i = 0; i < _diaryController.stockList.length; i++)
                StockListComponent(
                    name: list[i].name,
                    dealType: list[i].dealType,
                    amount: list[i].amount,
                    price: list[i].price),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget showDate() {
    var now = _diaryController.date.value;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
      child: Center(
          child: Text('${_utils.getDate(now)} (${_utils.getDay(now)})',
              style: TextStyle(fontSize: 16))),
    );
  }

  // Widget _datePicker() {
  //   CommonUtils utils = CommonUtils(now: _diaryController.date.value);
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
  //     decoration: BoxDecoration(
  //         border: Border(bottom: BorderSide(
  //             width: 1, color: Colors.black.withOpacity(0.1)))
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         IconButton(icon: Icon(Icons.chevron_left, size: 30), onPressed: () => _diaryController.changeDate(-1)),
  //         Text('${utils.getDate()} ${utils.getDay()}' , style: TextStyle(fontSize: 18)),
  //         IconButton(icon: Icon(Icons.chevron_right, size: 30), onPressed: () => _diaryController.changeDate(1)),
  //       ],
  //     ),
  //   );
  // }

  Widget _description() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Obx(() => Text(_diaryController.diaryInfo.value.text,
          style: TextStyle(fontSize: 16, height: 1.5))),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget confirmButton = TextButton(
      child: Text("네"),
      onPressed: () {
        Get.back();
        _diaryController.removeDiary(id);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("아니오"),
      onPressed: () => Get.back(),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("정말 삭제할까요?"),
      content: Text("해당 다이어리를 삭제할까요?"),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _diaryController.getDiaryInfo(id);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Obx(() => Text(
              _diaryController.diaryInfo.value.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        actions: [
          IconButton(
              onPressed: () {
                showAlertDialog(context);
                // _diaryController.removeDiary(id);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.blue,
              )),
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff00C78C),
        onPressed: () => Get.to(() => EditDiaryPage()),
        child: Icon(Icons.edit),
      ),
    );
  }
}
