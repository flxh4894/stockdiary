import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdTestPage2 extends StatefulWidget {
  const AdTestPage2({Key key}) : super(key: key);
  @override
  _AdTestPage2State createState() => _AdTestPage2State();
}

class _AdTestPage2State extends State<AdTestPage2> {
  @override
  void initState() {
    print('load');
    super.initState();
  }
  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }



  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('1111111')
        ],
      ),
    );
  }
}
