import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockdiary/src/component/divider.dart';
import 'package:stockdiary/src/controller/stock_controller.dart';
import 'package:stockdiary/src/page/stock_detail.dart';

class StockListPage extends StatelessWidget {
  final StockController _stockController = Get.put(StockController());

  Widget _body() {
    return Container(
      child: Column(
        children: [
          Obx(
            () => Expanded(
              child: _stockController.allStockList.length == 0 ? Container(
                  child: Center(child: Text('작성된 다이어리가 없습니다.'))) : ListView.separated(
                itemCount: _stockController.allStockList.length,
                itemBuilder: (context, index) {
                  return stockRow(_stockController.allStockList[index]['name'],
                      _stockController.allStockList[index]['amount']);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    DividerComponent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stockRow(String name, int amount) {
    return InkWell(
      onTap: () =>
          Get.to(StockDetailPage(stockName: name),
              transition: Transition.rightToLeft),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          children: [
            Expanded(child: Text(name)),
            SizedBox(
                width: 30,
                child: Text(amount.toString()))
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
        title: Text('종목 모아보기',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
      ),
      body: _body(),
    );
  }
}
