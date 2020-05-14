import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_book/app/app_scene.dart';
import 'package:flutter_book/generated/l10n.dart';
import 'package:flutter_book/util/sp_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app/root_scene.dart';
import 'global/global.dart';

void main() {
  runApp(AppScene());
  // runApp(MyApp());

  //系统识别

  //android
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  //ios
  if (Platform.isIOS) {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      navigatorKey: GlobalNavigator.navigatorKey,
      theme: ThemeData(platform: TargetPlatform.iOS),
      locale: Locale('zh'),
      localizationsDelegates: [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        print('deviceLocale: $deviceLocale');
        return deviceLocale;
      },
      home: RootScene(),
    );
  }
}
