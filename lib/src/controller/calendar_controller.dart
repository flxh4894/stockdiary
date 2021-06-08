import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockdiary/src/helper/db_helper.dart';
import 'package:stockdiary/src/model/memo.dart';
import 'package:stockdiary/src/utils/common_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  static Database _database;
  final CommonUtils _utils = CommonUtils();
  Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  RxList<Memo> memoList = <Memo>[].obs; // 전체 메모 리스트
  RxList<Memo> memoListDay = <Memo>[].obs; // 선택 당일 메모 리스트

  @override
  void onInit() {
    super.onInit();
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  // 달력 호출시 FutureBuilder 로 해당 메모 가지고 옴
  Future<bool> getMemos() async {
    if(memoList.length == 0) {
      final db = await database;
      List list = await db.rawQuery(
          "SELECT * FROM memo ORDER BY date DESC, id DESC");
      memoList(list.map((e) => Memo.fromJson(e)).toList());
    }
    return true;
  }


  // 달력 하단 당일 메모 출력리스트 생성
  List<Memo> getEventsForDay(DateTime day) {
    String _day = _utils.getDateDbType(day);
    List<Memo> list = <Memo>[];

    memoList.forEach((e) {
      if(_day == e.date)
        list.add(e);
    });
    return list;
  }

  void getMemoListDay(DateTime day) {
    String _day = _utils.getDateDbType(day);

    memoListDay.clear();
    memoList.forEach((e) {
      if(_day == e.date) {
        memoListDay.add(e);
      }
    });
  }

  // 해당일 메모 추가
  void insertMemoDay(Memo memo) async {
    final db = await database;
    
    int id = await db.insert('memo', memo.toMapDb());
    memo.id = id;

    // 메모 추가 후 전체 메모 리스트와 해당 메모리스트에 메모 추가.
    memoList.add(memo);
    memoListDay.add(memo);
    Get.back();
  }

  // 메모 체크리스트 업데이트
  void updateMemoStatus(int id, int status) async {
    final db = await database;

    db.rawUpdate("UPDATE memo SET check_yn = $status WHERE id = $id");
    // 업데이트 후 해당 메모 찾아서 상태값 변화
    memoList.asMap().forEach((key, value) {
      if(id == value.id) {
        memoList[key].checkYn = status;
        memoList.refresh();
      }
    });
  }
}
