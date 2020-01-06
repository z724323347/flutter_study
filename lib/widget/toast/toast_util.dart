
import 'package:flutter/material.dart';
import 'package:flutter_book/global/global.dart';
import 'package:flutter_book/widget/toast/toast_show.dart';

class AnimToast{
  static BuildContext context = GlobalNavigator.navigatorKey.currentState.overlay.context;
  static OverlayState overlayState = GlobalNavigator.navigatorKey.currentState.overlay;

  static toast(String message, {int time ,ToastPosition position}){
    Toast.show(message, time ,position);
  }
}