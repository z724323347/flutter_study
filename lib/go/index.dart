import 'package:flutter/material.dart';
import 'package:flutter_book/go/testgo.dart';

// final RouteObserver<PageRoute> routeObserver =RouteObserver<PageRoute>();

class IndexGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'eBook',
      // navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primaryColor: Colors.white,
        dividerColor: Color(0xFFEEEEEE),
      ),
      home: TestGo(),
    );
  }
}