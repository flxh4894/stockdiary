import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockdiary/src/controller/stock_controller.dart';
import 'package:stockdiary/src/model/stock.dart';
import 'package:stockdiary/src/page/chart.dart';
import 'package:stockdiary/src/utils/common_utils.dart';

class StockDetailPage extends StatelessWidget {
  final CommonUtils _utils = CommonUtils();
  final StockController _stockController = Get.put(StockController());
  final stockName;

  StockDetailPage({this.stockName});

  Widget _body() {
    _stockController.getStockList(stockName);
    List<Stock> stockList = _stockController.stockList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        chartButton(),
        SizedBox(height: 10),
        Expanded(
            child: Obx(
          () => ListView.builder(
              itemCount: stockList.length,
              itemBuilder: (context, index) {
                var date = stockList[index].dealDay;
                var dealType = stockList[index].dealType;
                var price = stockList[index].price;
                var amount = stockList[index].amount;
                var prePrice;
                if (index == stockList.length - 1)
                  prePrice = price;
                else
                  prePrice = stockList[index + 1].price;

                DateTime datetime = DateTime(
                    int.parse(date.substring(0, 4)),
                    int.parse(date.substring(4, 6)),
                    int.parse(date.substring(6, 8)));

                return _stockList(_utils.getDate(datetime), dealType, price,
                    amount, prePrice);
              }),
        )),
        SizedBox(height: 5),
        SizedBox(height: 10),
      ],
    );
  }

  Widget chartButton() {
    // return TextButton(
    //     onPressed: () => Get.to(() => StockChart()), child: Text('차트보기'));
    //

    return GestureDetector(
      onTap: () => Get.to(() => StockChart()),
      child: Container(
        height: 50,
        color: Color(0xff01CAB9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insights, color: Colors.white),
            SizedBox(width: 10),
            Text('차트보기',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget _stockList(
      String date, int dealType, int price, int amount, int prePrice) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      color: dealType == 1
          ? Colors.red.withOpacity(0.1)
          : Colors.blue.withOpacity(0.1),
      child: Row(
        children: [
          SizedBox(width: 80, child: Center(child: Text(date))),
          VerticalDivider(
            width: 5,
          ),
          SizedBox(
              width: 50,
              child: Center(
                child: dealType == 1 ? Text('매수') : Text('매도'),
              )),
          VerticalDivider(
            width: 5,
          ),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(_utils.priceFormat(price)),
                Text(
                  '( ${(100 - (price / prePrice * 100)).toStringAsFixed(2).toString()} %)',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), fontSize: 12),
                ),
              ])),
          VerticalDivider(
            width: 5,
          ),
          SizedBox(
              width: 60,
              child: Center(child: Text('${_utils.setComma(amount)}주'))),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          stockName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: _body(),
    );
  }
}
