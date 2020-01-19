import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_book/util/screen.dart';

class WatchClockWidget extends StatefulWidget {
  @override
  _WatchClockWidgetState createState() => _WatchClockWidgetState();
}

class _WatchClockWidgetState extends State<WatchClockWidget> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: WatchClock(),
      ),
    );
  }
}

class WatchClock extends CustomPainter {
  //大外圆
  Paint _bigCirclePaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..color = Colors.orange
    ..strokeWidth = 4;
  //粗刻度线
  Paint _linePaint = Paint()
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..color = Colors.orange
    ..strokeWidth = 4;
  //圆心
  Offset _centerOffset = Offset(0, 0);

  //圆半径
  double _bigRadius = math.min(Screen.width / 3, Screen.height / 3);
  final int lineHeight = 10;
  //角度转弧度
  num deg2Rad(num deg) => deg * (math.pi / 180.0);

  // 3、6、9、12 整点刻度
  List<TextPainter> _textPaint = [
    _getTextPainter("12"),
    _getTextPainter("3"),
    _getTextPainter("6"),
    _getTextPainter("9"),
  ];
  //文字画笔
  TextPainter _textPainter = new TextPainter(
      textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  TextPainter _textTimePainter =
      TextPainter(textAlign: TextAlign.left, textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    // print('_bigRadius: ${_bigRadius}');
    //绘制大圆
    canvas.drawCircle(_centerOffset, _bigRadius, _bigCirclePaint);
    //绘制圆心
    _bigCirclePaint.style = PaintingStyle.stroke;
    canvas.drawCircle(_centerOffset, _bigRadius / 40, _bigCirclePaint);
    //绘制刻度
    for (var i = 0; i < 60; i++) {
      _linePaint.strokeWidth = i % 5 == 0 ? (i % 3 == 0 ? 10 : 4) : 1;
      canvas.drawLine(Offset(0, _bigRadius - lineHeight), Offset(0, _bigRadius),
          _linePaint);
      canvas.rotate(2 * math.pi / 60);
    }
    //方法二:绘制数字,
    for (var i = 0; i < 12; i++) {
      //与restore配合使用保存当前画布
      canvas.save();

      ///平移画布画点于时钟的12点位置，+30为了调整数字与刻度的间隔
      canvas.translate(0.0, -_bigRadius + 30);
      _textPainter.text = TextSpan(
          style: TextStyle(color: Colors.orange, fontSize: 20),
          text: i.toString());
      //保持画数字的时候竖直显示
      canvas.rotate(-deg2Rad(30) * i);
      _textPainter.layout();
      _textPainter.paint(
          canvas, Offset(-_textPainter.width / 2, -_textPainter.height / 2));
      //画布重置,恢复到控件中心
      canvas.restore();
      //画布旋转一个小时的刻度，把数字和刻度对应起来
      canvas.rotate(deg2Rad(30));
    }
    // 绘制指针
    int hours = DateTime.now().hour;
    int minutes = DateTime.now().minute;
    int seconds = DateTime.now().second;
    // 绘制时间
    _textTimePainter.text = TextSpan(
        style: TextStyle(color: Colors.deepOrange, fontSize: 14),
        text:
            '${hours > 9 ? hours : '0$hours'} : ${minutes > 9 ? minutes : '0$minutes'} : ${seconds > 9 ? seconds : '0$seconds'}');
    _textTimePainter.layout();
    _textTimePainter.paint(canvas,
        Offset(-_textTimePainter.width / 2, _textTimePainter.height * 4));
    // print("时: ${hours} 分：${minutes} 秒: ${seconds}");
    //时针角度//以下都是以12点为0°参照
    //12小时转360°所以一小时30°
    //把分钟转小时之后*（2*pi/360*30） 一小时 30°
    double hoursAngle = (minutes / 60 + hours - 12) * (2 * math.pi / 360 * 30);
    //分针走过的角度,同理,一分钟6°
    double minutesAngle = (minutes + seconds / 60) * (2 * math.pi / 360 * 6);
    //秒针走过的角度,同理,一秒钟6°
    double secondsAngle = seconds * (2 * math.pi / 360 * 6);
    //画时针
    _linePaint.strokeWidth = 4;
    canvas.rotate(hoursAngle);
    canvas.drawLine(Offset(0, 0), Offset(0, -_bigRadius + 80), _linePaint);
    //画分针
    _linePaint.strokeWidth = 2;
    canvas.rotate(-hoursAngle); //先把之前画时针的角度还原。
    canvas.rotate(minutesAngle);
    canvas.drawLine(Offset(0, 0), Offset(0, -_bigRadius + 60), _linePaint);
    //画秒针
    _linePaint.strokeWidth = 1;
    canvas.rotate(-minutesAngle); //同理)
    canvas.rotate(secondsAngle);
    canvas.drawLine(Offset(0, 0), Offset(0, -_bigRadius + 30), _linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  static TextPainter _getTextPainter(String str) {
    return TextPainter(
        text: TextSpan(
            style: TextStyle(color: Colors.orange, fontSize: 20), text: str),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
  }
}
