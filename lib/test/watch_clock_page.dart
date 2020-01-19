import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_book/public.dart';
import 'package:flutter_book/util/ui_image_util.dart';

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter_book/widget/toast/toast.dart';
import 'package:flutter_book/widget/watch.dart';
import 'package:transparent_image/transparent_image.dart';

class WatchClockPage extends StatefulWidget {
  @override
  _WatchClockPageState createState() => _WatchClockPageState();
}

class _WatchClockPageState extends State<WatchClockPage> {
  Timer timer;

  int hours = DateTime.now().hour;
  int minutes = DateTime.now().minute;
  int seconds = DateTime.now().second;

  ui.Image _image1;
  ui.Image _image2;

  String imageUrl =
      'https://user-gold-cdn.xitu.io/2019/4/15/16a1ec70cd5f8fcf?w=679&h=960&f=png&s=1165530';

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        hours = DateTime.now().hour;
        minutes = DateTime.now().minute;
        seconds = DateTime.now().second;
      });
    });
    // _prepareImg();
    initTest();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void initTest() async {
    // ui.Image i =
    //     await UiImageUtil().rootBundleImage('img/daily_list_background.webp');
    // // AnimToast.toast(i.toString());
    // setState(() {
    //   _image2 = i;
    // });

    // ui.Image s = await UiImageUtil().loadImage('img/bookshelf_bg.png', false);
    ui.Image s = await UiImageUtil().loadImage(imageUrl, true);
    setState(() {
      _image1 = s;
    });
    AnimToast.toast(s.toString());
    print('loadImage  -- ${s}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('Wacth'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(height: 180),
              WatchClockWidget(),
              // buildTime(),
              SizedBox(height: 230),
              buildPaint(),
              Container(
                alignment: Alignment.center,
                child: buildPaintImage(),
              )
              // FadeInImage.assetNetwork(
              //   image: imageUrl,
              //   width: 200,
              //   placeholder: 'img/bookshelf_bg.png',
              // ),
              // FadeInImage.memoryNetwork(
              //   placeholder: kTransparentImage,
              //   image: imageUrl,
              //   width: 200,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTime() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      child: Text(
        "${hours} : ${minutes} : ${seconds}",
        style: TextStyle(color: Colors.deepOrange),
      ),
    );
  }

  Widget buildPaint() {
    return Container(
      child: CustomPaint(
        painter: PaintWidget(),
      ),
    );
  }

  Widget buildPaintImage() {
    return Container(
      height: 300,
      width: Screen.width,
      child: CustomPaint(
        painter: PaintImageWidget(image: _image1),
      ),
    );
  }
}

class PaintWidget extends CustomPainter {
  //圆
  Paint myPaint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..color = Colors.deepOrange
    ..strokeWidth = 1;
  //圆半径
  double radius = math.min(Screen.width / 8, Screen.width / 8);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, 36);
    int n = 30;
    var range = List<int>.generate(n, (i) => i + 1);
    for (int i in range) {
      double x = 2 * math.pi / n;
      double dx = radius * math.sin(i * x);
      double dy = radius * math.cos(i * x);
      canvas.drawCircle(Offset(dx, dy), radius, myPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PaintImageWidget extends CustomPainter {
  final ui.Image image;
  PaintImageWidget({@required this.image});
  Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true
    ..color = Colors.deepOrange
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) async {
    print('image  --- ${this.image}');
    // 平移画布
    canvas.translate(50, 50);
    //clipRRect 裁剪圆角矩形
    canvas.clipRRect(
        RRect.fromRectXY(
            Rect.fromLTWH(20, 0, image.width - 360.0, 300), 20, 20),
        doAntiAlias: false);
    // canvas.clipPath(Path()
    //   ..moveTo(100, 100)
    //   ..lineTo(200, 100)
    //   ..lineTo(200, 200)
    //   ..lineTo(100, 200));
    canvas.drawImage(this.image, Offset(-Screen.width / 2, -0), _paint);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
