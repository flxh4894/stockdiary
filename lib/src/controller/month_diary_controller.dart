import 'package:get/get.dart';
import 'package:stockdiary/src/helper/db_helper.dart';
import 'package:stockdiary/src/model/diary.dart';

class MonthDiaryController extends GetxController {

  // 날짜 (현재일 기본값)
  Rx<DateTime> _date = DateTime.now().obs;
  get date => _date;
  // 다이어리 월별 리스트
  RxList<Diary> monthDiaryList = <Diary>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('작성시 두번 호출인가요?');
    getMonthDiaryList();
  }

  // 월 변경
  void changeDate(int count) {
    int daysInMonth(DateTime date){
      var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
      var firstDayNextMonth = new DateTime(firstDayThisMonth.year, firstDayThisMonth.month + count, firstDayThisMonth.day);
      return firstDayNextMonth.difference(firstDayThisMonth).inDays;
    }

    _date( _date.value.add(Duration(days: daysInMonth(_date.value))) );
    getMonthDiaryList();
  }

  void changeDateSelected(String date) {
    date = date.replaceAll('.', '');
    int year = int.parse(date.substring(0,4));
    int month = int.parse(date.substring(4,6));
    DateTime dateTime = DateTime(year, month, 1);

    _date(dateTime);
    getMonthDiaryList();
  }

  // 월별 다이어리 리스트 가져오기
  void getMonthDiaryList() async {
    final db = await DatabaseHelper().database;
    final year = _date.value.year;
    final month = _date.value.month < 10 ? '0${_date.value.month}' : _date.value.month;
    final yearMonth = '$year$month';

    var list = await db.rawQuery("SELECT * FROM diary WHERE date BETWEEN '${yearMonth}01' AND '${yearMonth}31' ORDER BY date DESC, id DESC");
    list = await getTagList(list, db);
    monthDiaryList( list.map((e) => Diary.fromJson(e)).toList() );
  }

  // 리스트에 태그목록 추가
  Future<List<Map<String, dynamic>>> getTagList(List list, var db) async {
    List<Map<String, dynamic>> returnList = <Map<String, dynamic>>[];

    for(var diary in list) {
      List tags = await db.rawQuery("SELECT name FROM stock_list WHERE diary_id = ${diary['id']}");
      Map<String, dynamic> data = Map.from(diary);
      data['tags'] = tags;
      returnList.add(data);
    }

    return returnList;
  }

}