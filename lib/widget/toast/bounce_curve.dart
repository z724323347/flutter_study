import 'package:flutter/material.dart';

class BounceOutCurve extends Curve {
  const BounceOutCurve.curve();

  @override
  double transform(double t) {
    t -= 1.0;
    return t * t * ((2 + 1) * t + 2) + 1.0;
  }
}