import 'package:get/get.dart';

class ChartController extends GetxController {
  RxList chartData = [].obs;

  @override
  void onInit() {
    getChartData();
    super.onInit();
  }

  void getChartData(){

  }

}