import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:stockdiary/src/controller/diary_controller.dart';
import 'package:stockdiary/src/model/diary.dart';
import 'package:stockdiary/src/model/stock.dart';
import 'package:stockdiary/src/utils/common_utils.dart';

class EditDiaryPage extends StatefulWidget {

  @override
  _EditDiaryPageState createState() => _EditDiaryPageState();
}

class _EditDiaryPageState extends State<EditDiaryPage> {
  final DiaryController _diaryController = Get.find<DiaryController>();
  final CommonUtils _utils = CommonUtils();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textDateController = TextEditingController();
  final TextEditingController _textTitleController = TextEditingController();
  List<Stock> stockList = [];
  List<String> dropdownList = [];

  @override
  void initState() {
    stockList = _diaryController.stockList;
    for (var stock in stockList) {
      if (stock.dealType == 1)
        dropdownList.add('매수');
      else
        dropdownList.add('매도');
    }
    super.initState();
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _datePicker(),
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _textTitleController
                  ..text = _diaryController.diaryInfo.value.title,
                decoration: InputDecoration(
                    hintText: '제목을 입력해주세요.', border: InputBorder.none),
              ),
            ),
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _textController
                  ..text = _diaryController.diaryInfo.value.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50)
                ],
                decoration: InputDecoration(
                    hintText: '내용을 입력해주세요. (최대 500자)',
                    border: InputBorder.none),
                keyboardType: TextInputType.multiline,
                maxLines: 20,
              ),
            ),
            _divider(),
            for (int i = 0; i < stockList.length; i++) _stockList(i),
            addButton(),
            _divider(),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //         hintText: '종목명을 입력하세요. ex) #테슬라 #삼성전자',
            //         border: InputBorder.none),
            //   ),
            // ),
            _divider(),
          ],
        ),
      ),
    );
  }

  Widget _datePicker() {
    initializeDateFormatting('ko', 'KR');
    String date = _diaryController.diaryInfo.value.date;
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);

    return FormBuilderDateTimePicker(
      name: 'date',
      initialValue: _utils.convertDateTime(year, month, day),
      fieldHintText: '날짜 선택',
      inputType: InputType.date,
      format: DateFormat('yyyy.MM.dd (EEEE)', 'ko-KR'),
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.calendar_today_sharp)),
      controller: _textDateController,
    );
  }

  Widget _stockList(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: stockList[index].name,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title_outlined),
                      border: InputBorder.none, hintText: '종목명을 입력하세요.'),
                  onChanged: (value) => stockList[index].name = value,
                ),
              ),
              stockList.length - 1 == index
                  ? IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      stockList.removeAt(index);
                      dropdownList.removeAt(index);
                    });
                  })
                  : Container()
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
                onChanged: (value) {
                  setState(() {
                    dropdownList[index] = value;
                    if (value == '매수') {
                      stockList[index].dealType = 1;
                    } else {
                      stockList[index].dealType = 2;
                    }
                  });
                },
                isExpanded: true,
                value: dropdownList[index],
                items: ['매수', '매도']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList()),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                if(value == "")
                  stockList[index].price = 0;
                else
                  stockList[index].price = int.parse(value);
              });
            },
            keyboardType: TextInputType.number,
            initialValue: stockList[index].price.toString(),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.paid_outlined),
                border: InputBorder.none, hintText: '가격을 입력하세요.'),
          ),
          Center(child: Text("( ${_utils.priceFormat(stockList[index].price)} )")),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) {
              if(value == '')
                value = '0';
              stockList[index].amount = int.parse(value);
            },
            keyboardType: TextInputType.number,
            initialValue: stockList[index].amount.toString(),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.add_shopping_cart),
                border: InputBorder.none, hintText: '수량을 입력하세요.'),
          ),
          _divider()
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

  Widget addButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          stockList.add(
              Stock(name: '', dealType: 1, price: 0, amount: 0));
          dropdownList.add('매수');
        });
      },
      child: Container(
        width: 100,
        height: 30,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            Text('추가하기', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('다이어리 수정',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                if(_textDateController.text == ""){
                  Get.defaultDialog(
                      barrierDismissible: true,
                      title: '',
                      textCancel: '확인',
                      content: Center(
                        child: Text('날짜를 입력해 주세요.'),
                      )
                  );
                  return;
                }

                if(_textController.text == ""){
                  Get.defaultDialog(
                      barrierDismissible: true,
                      title: '',
                      textCancel: '확인',
                      content: Center(
                        child: Text('내용을 입력해 주세요.'),
                      )
                  );
                  return;
                }

                if(_textTitleController.text == ""){
                  Get.defaultDialog(
                      barrierDismissible: true,
                      title: '',
                      textCancel: '확인',
                      content: Center(
                        child: Text('제목을 입력해 주세요.'),
                      )
                  );
                  return;
                }

                for(Stock stock in stockList) {
                  if(stock.name == ""){
                    Get.defaultDialog(
                        barrierDismissible: true,
                        title: '',
                        textCancel: '확인',
                        content: Center(
                          child: Text('종목명을 입력해 주세요.'),
                        )
                    );
                    return;
                  }
                  if(stock.price == 0){
                    Get.defaultDialog(
                        barrierDismissible: true,
                        title: '',
                        textCancel: '확인',
                        content: Center(
                          child: Text('가격을 입력해 주세요.'),
                        )
                    );
                    return;
                  }
                  if(stock.amount == 0){
                    Get.defaultDialog(
                        barrierDismissible: true,
                        title: '',
                        textCancel: '확인',
                        content: Center(
                          child: Text('수량을 입력해 주세요.'),
                        )
                    );
                    return;
                  }
                }


                var id = _diaryController.diaryInfo.value.id;
                Diary diary = Diary(
                  title: _textTitleController.text,
                  text: _textController.text,
                  date: CommonUtils().convertDateFormat(
                      _textDateController.text));
                _diaryController.updateDiary(id, diary, stockList);
              },
              child: Text('완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        ],
      ),
      body: _body(),
    );
  }
}
