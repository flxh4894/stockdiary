import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:stockdiary/src/controller/diary_controller.dart';
import 'package:stockdiary/src/model/stock.dart';
import 'package:stockdiary/src/utils/common_utils.dart';

class NewDiaryPage extends StatefulWidget {
  const NewDiaryPage({Key key}) : super(key: key);

  @override
  _NewDiaryPageState createState() => _NewDiaryPageState();
}

class _NewDiaryPageState extends State<NewDiaryPage> {
  final CommonUtils _utils = CommonUtils();
  final DiaryController _diaryController = Get.put(DiaryController());
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _textDateController = TextEditingController();
  final TextEditingController _textTitleController = TextEditingController();
  List<Stock> stockList = [
    // Stock(name: '', dealType: 1, price: 0, amount: 0),
  ];
  List<String> dropdownList = ['매수'];

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _datePicker(),
          _divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _textTitleController,
              decoration: InputDecoration(
                  hintText: '제목을 입력해주세요.', border: InputBorder.none),
            ),
          ),
          _divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _textController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(50)
              ],
              decoration: InputDecoration(
                  hintText: '내용을 입력해주세요. (최대 500자)',
                  border: InputBorder.none),
              keyboardType: TextInputType.multiline,
              maxLines: 15,
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
          saveButton(),
        ],
      ),
    );
  }

  Widget _datePicker() {
    initializeDateFormatting('ko', 'KR');
    return FormBuilderDateTimePicker(
      name: 'date',
      initialValue: DateTime.now(),
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
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.paid_outlined),
                border: InputBorder.none, hintText: '가격을 입력하세요.'),
          ),
          Center(child: Text("( ${_utils.priceFormat(stockList[index].price)} )")),
          SizedBox(height: 10),
          TextFormField(
            onChanged: (value) => stockList[index].amount = int.parse(value),
            keyboardType: TextInputType.number,
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
        width: 150,
        height: 30,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Color(0xff00C78C), borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            Text('종목 추가하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return GestureDetector(
      onTap: () {
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

        _diaryController.insertDiary(
            _textTitleController.text,
            _textController.text,
            CommonUtils().convertDateFormat(_textDateController.text),
            stockList);
      },
      child: Container(
        width: 300,
        height: 50,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color(0xff00C78C),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Colors.white),
              SizedBox(width: 10),
              Text('등록하기', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('새 다이어리', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        elevation: 0,
        // actions: [
        //   TextButton(
        //       onPressed: () {
        //         _diaryController.insertDiary(
        //             _textTitleController.text,
        //             _textController.text,
        //             CommonUtils().convertDateFormat(_textDateController.text),
        //             stockList);
        //       },
        //       child: Text('완료',
        //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        // ],
      ),
      body: _body(context),
    );
  }
}
