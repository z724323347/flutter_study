import 'package:flutter/material.dart';
import 'package:battery/battery.dart';

import 'package:flutter_book/public.dart';

class BatteryView extends StatefulWidget {
  _BatteryViewState createState() => _BatteryViewState();
}

class _BatteryViewState extends State<BatteryView> {

  double batteryLevel = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBatteryLevel();

  }

  getBatteryLevel() async {
    var level =await Battery().batteryLevel;
    setState(() {
     this.batteryLevel =level / 100 ; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       width: 27,
       height: 12,
       child: Stack(
         children: <Widget>[
           Image.asset('img/reader_battery.png'),
           Text('$batteryLevel %',style: TextStyle(fontSize: 12,color: EColor.gray)),
           Container(
             margin: EdgeInsets.fromLTRB(2, 2, 2, 3),
             width:  20 * batteryLevel,
             color: EColor.blue,
           )
         ],
       ),
    );
  }
}