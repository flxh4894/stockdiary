import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockdiary/src/controller/stock_controller.dart';
import 'package:stockdiary/src/model/stock.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'ad_test.dart';

class StockChart extends StatefulWidget {

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  final StockController _stockController = Get.find<StockController>();

  Widget _body(){
    List<Stock> stockList = _stockController.stockList;
    return Column(
      children: [
        Container(
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.currency(
                    decimalDigits: 0,
                    symbol: "")
            ),
            enableAxisAnimation: true,
            tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '당일매수가격',
                format: 'point.y 원'
            ),
            trackballBehavior: TrackballBehavior(
                enable: true,
                lineDashArray: <double>[5,5],
                markerSettings: TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible),
                lineType: TrackballLineType.horizontal,
                tooltipSettings: InteractiveTooltip(
                    format: '당일매수가격 : point.y원'
                )
            ),
            zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                zoomMode: ZoomMode.x
            ),
            series: <SplineSeries<Stock, String>>[
              SplineSeries<Stock, String>(
                dataSource: stockList,
                xValueMapper: (Stock sales, _) => sales.dealDay,
                yValueMapper: (Stock stock, _) => stock.price,
                markerSettings: MarkerSettings(isVisible: true),
                color: Colors.blueAccent
              )
            ],
          ),
        ),
        SizedBox(height: 5),
        AdTestPage(),
        SizedBox(height: 5),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          _stockController.stockList[0].name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: _body(),
    );
  }
}
