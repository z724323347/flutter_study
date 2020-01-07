import 'package:flutter/material.dart';
import 'package:flutter_book/generated/i18n.dart';
import 'package:flutter_book/global/global.dart';
import 'package:flutter_book/public.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'root_scene.dart';
import 'e_color.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eBook',
      navigatorObservers: [routeObserver],
      navigatorKey: GlobalNavigator.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        dividerColor: Color(0xFFEEEEEE),
        scaffoldBackgroundColor: EColor.paper,
        textTheme: TextTheme(body1: TextStyle(color: EColor.darkGray)),
      ),
      home: RootScene(),
      localizationsDelegates: const [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
