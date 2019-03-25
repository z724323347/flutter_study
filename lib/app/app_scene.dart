import 'package:flutter/material.dart';
import 'package:flutter_book/public.dart';
import 'root_scene.dart';
import 'e_color.dart';

final RouteObserver<PageRoute> routeObserver =RouteObserver<PageRoute>();

class AppScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'eBook',
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        dividerColor: Color(0xFFEEEEEE),
        scaffoldBackgroundColor: EColor.paper,
        textTheme: TextTheme(body1: TextStyle(color: EColor.darkGray)),
      ),
      home: RootScene(),
    );
  }
}