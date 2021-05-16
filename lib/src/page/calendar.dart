import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockdiary/src/component/divider.dart';
import 'package:stockdiary/src/component/event_row.dart';
import 'package:stockdiary/src/controller/calendar_controller.dart';
import 'package:stockdiary/src/model/memo.dart';
import 'package:stockdiary/src/utils/common_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CommonUtils _utils = CommonUtils();
  final CalendarController _calendarController = Get.put(CalendarController());
  final TextEditingController _textMemoController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
              future: _calendarController.getMemos(),
              builder: (context, snapshot) => _calendar()),
          for(Memo memo in _calendarController.memoListDay)
            EventRowComponent(
              text: memo.text,
              checkYn: memo.checkYn,
              id: memo.id,
            )
        ],
      ),
    );
  }

  Widget _calendar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        locale: 'ko-KR',
        firstDay: DateTime.utc(1983, 1, 4),
        lastDay: DateTime.utc(2099, 12, 31),
        daysOfWeekHeight: 30,
        daysOfWeekStyle:
            DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.red)),
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.red),
          todayDecoration: BoxDecoration(
            color: Color(0xff00C78C).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            return events.length == 0
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          height: 15,
                          width: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.pinkAccent, shape: BoxShape.circle),
                          child: Text(events.length.toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)))
                    ],
                  );
          },
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: '주',
          CalendarFormat.twoWeeks: '월',
          CalendarFormat.week: '2주',
        },
        eventLoader: _calendarController.getEventsForDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _calendarController.getMemoListDay(selectedDay);
          }
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        focusedDay: _focusedDay,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget addDialog() {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 5,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(0xff01CAB9))),
                  SizedBox(width: 10),
                  Text('일정 입력',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              DividerComponent(),
              SizedBox(height: 10),
              Text(
                  '${_utils.getDate(_selectedDay)} (${_utils.getDay(_selectedDay)})',
                  style: TextStyle(fontSize: 16)),
              TextFormField(
                style: TextStyle(fontSize: 16),
                controller: _textMemoController,
                decoration: InputDecoration(
                    hintText: '메모를 입력하세요. (최대 30자)',
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none),
                autofocus: true,
              ),
              Spacer(),
              DividerComponent(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: () => Get.back(), child: Text('취소')),
                  TextButton(
                      onPressed: () {
                        Memo memo = Memo(
                          text: _textMemoController.text,
                          date: _utils.getDateDbType(_selectedDay),
                          checkYn: 0
                        );
                        _calendarController.insertMemoDay(memo);
                        _textMemoController.text = '';
                      },
                      child: Text('추가')),
                ],
              )
            ],
          ),
        ));
  }

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        '달력 및 메모',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.add, color: Color(0xff00C78C), size: 30),
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return addDialog();
                  });
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(),
        body: Obx(() => _body()));
  }
}
