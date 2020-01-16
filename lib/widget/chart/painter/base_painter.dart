import 'package:flutter/material.dart';
import 'package:flutter_book/widget/chart/chart_bean.dart';

class BasePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  ///计算极值 最大值,最小值
  List<double> calculateMaxMin(List<ChartBean> chartBeans) {
    if (chartBeans == null || chartBeans.length == 0) return [0, 0];
    double max = 0.0, min = 0.0;
    for (ChartBean bean in chartBeans) {
      if (max < bean.y) {
        max = bean.y;
      }
      if (min > bean.y) {
        min = bean.y;
      }
    }
    return [max, min];
  }
}
