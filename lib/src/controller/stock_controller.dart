import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockdiary/src/helper/db_helper.dart';
import 'package:stockdiary/src/model/stock.dart';

class StockController extends GetxController {
  static Database _database;
  RxList<Stock> stockList = <Stock>[].obs;
  RxList allStockList = [].obs;

  @override
  void onInit() {
    getAllStockList();
    super.onInit();
  }
  
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await DatabaseHelper().database;
    return _database;
  }

  void getStockList(String stockName) async {
    final db = await database;
    List list = await db.rawQuery("SELECT * FROM stock_list WHERE name = '$stockName' ORDER BY date DESC");

    stockList( list.map((e) => Stock.fromJsonDb(e)).toList() );
  }

  void getAllStockList() async {
    print('???');
    final db = await database;
    List list = await db.rawQuery("SELECT name, COUNT(name) AS amount FROM stock_list GROUP BY name");
    allStockList(list);
  }
}