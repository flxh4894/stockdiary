import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockdiary/src/component/datePicker.dart';
import 'package:stockdiary/src/controller/month_diary_controller.dart';
import 'package:stockdiary/src/page/diary_detail.dart';
import 'package:stockdiary/src/page/new_diary.dart';
import 'package:stockdiary/src/utils/common_utils.dart';

class MonthMemoPage extends StatelessWidget {
  final MonthDiaryController _monthDiaryController =
      Get.put(MonthDiaryController());
  final CommonUtils _utils = CommonUtils();

  Widget _body(BuildContext context) {
    var diary = _monthDiaryController.monthDiaryList;
    return Container(
      child: Column(
        children: [
          datePicker(),
          if(diary.length == 0)
            Expanded(
              child: Center(
                child: Text('작성된 다이어리가 없습니다.'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: diary.length,
                itemBuilder: (context, index) {
                  return dayRow(diary[index].id, CommonUtils().substringDate(diary[index].date),
                      diary[index].title, diary[index].tags);
                }
              ),
            )
        ],
      ),
    );
  }

  Widget datePicker() {
    DateTime now = _monthDiaryController.date.value;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xff01CAB9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.chevron_left, size: 30, color: Colors.white),
              onPressed: () => _monthDiaryController.changeDate(-1)),
          DatePickerComponent(now: DateTime.now(),fontColor: Colors.white, fontSize: 18),
          IconButton(
              icon: Icon(Icons.chevron_right, size: 30, color: Colors.white),
              onPressed: () => _monthDiaryController.changeDate(1)),
        ],
      ),
    );
  }

  Widget dayRow(int id, String day, String title, List tags) {
    var tagList = '';
    for (var tag in tags) {
      tagList = tagList + ' #${tag['name']}';
    }
    return InkWell(
      onTap: () => Get.to(() => DiaryDetail(id: id)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Colors.black.withOpacity(0.1)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                decoration: BoxDecoration(
                  color: Color(0xff01CAB9),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(day,
                    style: TextStyle(fontSize: 14, color: Colors.white))),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (tags == null)
                    Container()
                  else
                    Text(tagList,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black.withOpacity(0.5))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          '주식 다이어리',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Obx(() => _body(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(NewDiaryPage()),
        backgroundColor: Color(0xff00C78C),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
