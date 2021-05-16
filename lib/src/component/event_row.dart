import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockdiary/src/controller/calendar_controller.dart';

class EventRowComponent extends StatelessWidget {
  final CalendarController _calendarController = Get.find<CalendarController>();
  final int id;
  final String text;
  final int checkYn;
  EventRowComponent({@required this.text, @required this.checkYn, @required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(width: 5, height: 40, decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(0xff01CAB9),
          ),),
          SizedBox(width: 5),
          Expanded(
            child: Text( text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                decoration: checkYn == 1 ? TextDecoration.lineThrough : null,
                color: checkYn == 1 ? Colors.black.withOpacity(0.5) : null,
              )
            ),
          ),
          Checkbox(
            value: checkYn == 1,
            onChanged: (bool value) {
              int status = value == true ? 1 : 0;
              _calendarController.updateMemoStatus(id, status);
            },
            activeColor: Color(0xff01CAB9),
          )
        ],
      )
    );
  }
}
