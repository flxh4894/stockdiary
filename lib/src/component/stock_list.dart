import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockdiary/src/page/stock_detail.dart';

class StockListComponent extends StatelessWidget {
  final String name;
  final int dealType;
  final int price;
  final int amount;
  final formatCurrency = new NumberFormat.simpleCurrency(
      locale: 'ko-KR', name: '', decimalDigits: 0);

  StockListComponent(
      {@required this.name,
      @required this.dealType,
      @required this.price,
      @required this.amount});

  Widget _dealType() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      width: 50,
      decoration: BoxDecoration(
          color: dealType == 1 ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: dealType == 1
            ? Text('매수',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            : Text('매도',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => StockDetailPage(stockName: name)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            SizedBox(width: 90, child: Text(name)),
            _dealType(),
            Expanded(
                child: Center(child: Text('${formatCurrency.format(price)} 원'))),
            SizedBox(
                width: 60,
                child: Center(child: Text('${formatCurrency.format(amount)} 주')))
          ],
        ),
      ),
    );
  }
}
