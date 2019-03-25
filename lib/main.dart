import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_book/app/app_scene.dart';

void main() {
  runApp(AppScene());

  //系统识别

  //android
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  //ios
  if (Platform.isIOS) {
    
  }
  
}
