import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockdiary/src/controller/month_diary_controller.dart';
import 'package:stockdiary/src/helper/db_helper.dart';
import 'package:stockdiary/src/model/diary.dart';
import 'package:stockdiary/src/model/stock.dart';
import 'package:stockdiary/src/page/diary_home.dart';

class DiaryController extends GetxController {
  final MonthDiaryController _monthDiaryController =
      Get.find<MonthDiaryController>();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  // 날짜 (현재일 기본값)
  Rx<DateTime> _date = DateTime.now().obs;

  get date => _date;

  // 다이어리 작성 & 상세에 표시되는 주식 정보
  RxList<Stock> stockList = <Stock>[].obs;

  // 다이어리 상세 정보
  Rx<Diary> diaryInfo = Diary(title: '', text: '', date: '').obs;

  // 다이어리 정보 삽입
  void insertDiary(
      String title, String text, String date, List<Stock> list) async {
    final db = await DatabaseHelper().database;
    var id =
        await db.insert('diary', {'title': title, 'text': text, 'date': date});
    await insertStock(id, list, date);

    _monthDiaryController.getMonthDiaryList();
    Get.back();
  }

  // 다이어리별 주식 목록 저장
  Future insertStock(int diaryId, List<Stock> stockList, String date) async {
    final db = await DatabaseHelper().database;
    for (Stock stock in stockList) {
      stock.name = stock.name.toUpperCase();
      await db.insert('stock_list', {...stock.toMapDb(diaryId), 'date': date});
    }
  }

  // 다이어리 상세 정보 가져오기
  void getDiaryInfo(int id) async {
    final db = await DatabaseHelper().database;
    var info = await db.rawQuery('SELECT * FROM diary WHERE id = $id');
    diaryInfo(Diary.fromJson(info[0]));

    var year = diaryInfo.value.date.substring(0, 4);
    var month = diaryInfo.value.date.substring(4, 6);
    var day = diaryInfo.value.date.substring(6, 8);

    getDayStockList(id);
    _date(DateTime(int.parse(year), int.parse(month), int.parse(day)));
  }

  // 상세페이지 주식 목록
  void getDayStockList(int id) async {
    final db = await DatabaseHelper().database;
    var info =
        await db.rawQuery('SELECT * FROM stock_list WHERE diary_id = $id');
    stockList(info.map((e) => Stock.fromJsonDb(e)).toList());
  }

  // 다이어리 삭제
  void removeDiary(int id) async {
    final db = await database;
    db.rawDelete("DELETE FROM stock_list WHERE diary_id = $id");
    db.rawDelete("DELETE FROM diary WHERE id = $id");

    _monthDiaryController.getMonthDiaryList();
    Get.back();
  }

  void updateDiary(int id, Diary diary, List<Stock> list) async {
    final db = await database;
    db.rawUpdate(
        "UPDATE diary SET title='${diary.title}', text='${diary.text}', date='${diary.date}' WHERE id=$id");
    db.rawDelete("DELETE FROM stock_list WHERE diary_id = $id");
    await insertStock(id, list, diary.date);
    _monthDiaryController.getMonthDiaryList();
    Get.offAll(() => DiaryHomePage());
  }
}
