//Toast 显示位置控制
import 'package:flutter/material.dart';
import 'package:flutter_book/global/global.dart';
import 'package:flutter_book/widget/toast/toast_view.dart';
import 'package:flutter_book/widget/toast/toast_widget.dart';

import 'bounce_curve.dart';

class Toast {
  static ToastView preToast;
  // 显示位置
  static ToastPosition _p;
  static show(String msg, [int time, ToastPosition position]) {
    preToast?.dismiss();
    preToast = null;
    _p = position != null ? position : ToastPosition.bottom;
    OverlayState overlayState =
        GlobalNavigator.navigatorKey.currentState.overlay;

    var controllerShowAnim = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var controllerShowOffset = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 350),
    );
    var controllerHide = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var opacityAnim1 =
        new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
    var controllerCurvedShowOffset = new CurvedAnimation(
        parent: controllerShowOffset, curve: BounceOutCurve.curve());
    var offsetAnim =
        new Tween(begin: 30.0, end: 0.0).animate(controllerCurvedShowOffset);
    var opacityAnim2 = new Tween(begin: 1.0, end: 0.0).animate(controllerHide);

    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context) {
      return ToastWidget(
        opacityAnim1: opacityAnim1,
        opacityAnim2: opacityAnim2,
        offsetAnim: offsetAnim,
        child: buildToastLayout(msg, _p),
      );
    });
    var toastView = ToastView();
    toastView.overlayEntry = overlayEntry;
    toastView.controllerShowAnim = controllerShowAnim;
    toastView.controllerShowOffset = controllerShowOffset;
    toastView.controllerHide = controllerHide;
    toastView.overlayState = overlayState;
    preToast = toastView;
    toastView.show(time);
  }

  static LayoutBuilder buildToastLayout(String msg, ToastPosition p) {
    return LayoutBuilder(builder: (context, constraints) {
      return IgnorePointer(
        ignoring: true,
        child: Container(
          child: Material(
            color: Colors.white.withOpacity(0),
            child: Container(
              child: Container(
                child: Text(
                  "${msg.toString()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              margin: EdgeInsets.only(
                top: p == ToastPosition.top
                    ? constraints.biggest.height * 0.15
                    : 0,
                bottom: constraints.biggest.height * 0.15,
                left: constraints.biggest.width * 0.2,
                right: constraints.biggest.width * 0.2,
              ),
            ),
          ),
          alignment: setAlignment(p),
        ),
      );
    });
  }

  /// 设置toast位置
  static AlignmentGeometry setAlignment(ToastPosition postion) {
    if (postion == ToastPosition.top) {
      return Alignment.topCenter;
    } else if (postion == ToastPosition.center) {
      return Alignment.center;
    } else {
      return Alignment.bottomCenter;
    }
  }
}

enum ToastPosition {
  top,
  center,
  bottom,
}
