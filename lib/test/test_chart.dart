import 'package:flutter/material.dart';
import 'package:flutter_book/widget/chart/chart_bean.dart';
import 'package:flutter_book/widget/chart/chart_pie_bean.dart';
import 'package:flutter_book/widget/chart/view/chart_bar.dart';
import 'package:flutter_book/widget/chart/view/chart_line.dart';
import 'package:flutter_book/widget/chart/view/chart_pie.dart';

class TestChartPage extends StatefulWidget {
  @override
  _TestChartPageState createState() => _TestChartPageState();
}

class _TestChartPageState extends State<TestChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          _buildChartLine(context),
          _buildChartCurve(context),
          _buildChartBarCircle(context),
          _buildChartPie(context),
        ],
      ),
    );
  }

  Widget _buildChartLine(context) {
    var chartLine = ChartLine(
        chartBeans: [
          ChartBean(x: '01-12', y: 40),
          ChartBean(x: '01-13', y: 80),
          ChartBean(x: '01-14', y: 60),
          ChartBean(x: '01-15', y: 10),
          ChartBean(x: '01-16', y: 80),
          ChartBean(x: '01-17', y: 90),
          ChartBean(x: '01-17', y: 50),
        ],
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 5 * 1.6),
        isCurve: false,
        lineWidth: 2,
        lineColor: Colors.pink,
        fontColor: Colors.white,
        xyColor: Colors.white,
        shaderColors: [
          Colors.blue.withOpacity(0.8),
          Colors.blue.withOpacity(0.5)
        ],
        fontSize: 12,
        yNum: 8,
        isAnimation: true,
        isReverse: false,
        isCanTouch: true,
        isShowPressedHintLine: true,
        pressedPointRadius: 4,
        pressedHintLineWidth: 0.5,
        pressedHintLineColor: Colors.white,
        duration: Duration(milliseconds: 2000));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.5),
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  Widget _buildChartCurve(context) {
    var chartLine = ChartLine(
      chartBeans: [
        ChartBean(x: '12-01', y: 30),
        ChartBean(x: '12-02', y: 60),
        ChartBean(x: '12-03', y: 40),
        ChartBean(x: '12-04', y: 20),
        ChartBean(x: '12-05', y: 50),
        ChartBean(x: '12-06', y: 70),
        ChartBean(x: '12-07', y: 80),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.6),
      isAnimation: true,
      isCurve: true,
      lineWidth: 2,
      lineColor: Colors.orange,
      fontColor: Colors.blue,
      xyColor: Colors.white,
      shaderColors: [
        Colors.blueAccent.withOpacity(0.8),
        Colors.blueAccent.withOpacity(0.4)
      ],
      fontSize: 12,
      yNum: 8,
      isReverse: false,
      isCanTouch: true,
      isShowPressedHintLine: true,
      pressedPointRadius: 4,
      pressedHintLineWidth: 0.5,
      pressedHintLineColor: Colors.white,
      duration: Duration(milliseconds: 2000),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(8),
      semanticContainer: true,
      child: chartLine,
      clipBehavior: Clip.antiAlias,
    );
  }

  Widget _buildChartBarCircle(context) {
    var chartBar = ChartBar(
      chartBeans: [
        ChartBean(x: '', y: 70, color: Colors.red),
        ChartBean(x: '', y: 30, color: Colors.yellow),
        ChartBean(x: '', y: 40, color: Colors.blue),
        ChartBean(x: '', y: 60, color: Colors.orange),
        ChartBean(x: '', y: 20, color: Colors.blueGrey),
        ChartBean(x: '', y: 50, color: Colors.green),
        ChartBean(x: '', y: 60, color: Colors.pink),
      ],
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height / 5 * 1.8),
      rectColor: Colors.deepPurple,
      isShowX: true,
      fontColor: Colors.white,
      rectShadowColor: Colors.white.withOpacity(0.5),
      isCanTouch: true,
      isShowTouchShadow: true,
      isShowTouchValue: true,
      rectRadiusTopLeft: 5,
      rectRadiusTopRight: 5,
      duration: Duration(milliseconds: 800),
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.all(8),
      semanticContainer: true,
      color: Colors.blue.withOpacity(0.4),
      child: chartBar,
      clipBehavior: Clip.antiAlias,
    );
  }

  Widget _buildChartPie(context) {
    var chartPie = ChartPie(
      chartBeans: [
        ChartPieBean(type: 'type1', value: 80, color: Colors.blueGrey),
        ChartPieBean(type: 'type2', value: 50, color: Colors.red),
        ChartPieBean(type: 'type3', value: 20, color: Colors.green),
        ChartPieBean(type: 'type4', value: 70, color: Colors.orange),
        ChartPieBean(type: 'type5', value: 50, color: Colors.pink),
        ChartPieBean(type: 'type6', value: 90, color: Colors.yellowAccent),
      ],
      size: Size(
          MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      R: MediaQuery.of(context).size.width / 3,
      centerR: 2,
      duration: Duration(milliseconds: 2000),
      centerColor: Colors.white,
      fontColor: Colors.white,
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: Colors.orangeAccent.withOpacity(0.6),
      clipBehavior: Clip.antiAlias,
      borderOnForeground: true,
      child: chartPie,
    );
  }
}
