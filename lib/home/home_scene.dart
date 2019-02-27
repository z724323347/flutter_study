import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';
import 'package:flutter_book/app/e_color.dart';
import 'home_tablist_view.dart';

class HomeScene extends StatefulWidget {
  _HomeSceneState createState() => _HomeSceneState();
}

class _HomeSceneState extends State<HomeScene> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TabBar(
              labelColor: EColor.darkGray,
              labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
              unselectedLabelColor: EColor.gray,
              indicatorColor: EColor.secondary,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              indicatorPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              tabs: <Widget>[
                Tab(text: '精选'),
                Tab(text: '小说'),
                Tab(text: '推荐'),
                Tab(text: '漫画')
              ],
            ),
          ),
          backgroundColor: EColor.white,
          elevation: 0,
        ),
        body: TabBarView(children: <Widget>[
          HomeListView(HomeListType.excellent),
          HomeListView(HomeListType.female),
          HomeListView(HomeListType.male),
          HomeListView(HomeListType.cartoon)
          
        ],),
        
      ),
    );
  }
}