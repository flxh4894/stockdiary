import 'package:flutter/material.dart';

class DividerComponent extends StatelessWidget {
  const DividerComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 1,
      decoration: BoxDecoration(
          border: Border(
              bottom:
              BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
    );
  }
}
