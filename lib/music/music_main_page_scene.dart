import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';
import '../music/part/part_player.dart';
import '../music/page/page_main_playlist.dart';
import '../music/page/page_main_cloud.dart';

// import 'package:flutter_book/music/pages/page_main_cloud.dart';
// import 'package:flutter_book/music/pages/page_main_playlist.dart';


class MusicMainPage extends StatefulWidget {
  final Widget child;

  MusicMainPage({Key key, this.child}) : super(key: key);

  _MusicMainPageState createState() => _MusicMainPageState();
}

class _MusicMainPageState extends State<MusicMainPage> with
      SingleTickerProviderStateMixin{

  TabController tabController;  

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ProxyAnimation transitionAnimation = ProxyAnimation(kAlwaysDismissedAnimation);   



  @override
  Widget build(BuildContext context) {
    // return buildSingle(context);
    return buildDouble(context);
    // return buildNet(context);
  }
  

  Widget buildDouble(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                Tab(text: '管理'),
                Tab(text: '云音乐')
              ],
            ),
          ),
          backgroundColor: EColor.white,
          elevation: 0,
        ),
        body: TabBarView(
          children: <Widget>[
            MainPlaylistPage(),
            MainCloudPage()
          ],
        ),
      ),
    );
  }

  Widget buildSingle(BuildContext context) {
     return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Music...'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              ToastUtil.showCenter('search');
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: MainCloudPage(),
      // body: BoxWithBottomPlayerController(Container(
      //   // child: MainCloudPage(),
      //   child: MainPlaylistPage(),
      // )),
    );
  }

  Widget buildNet(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Music...'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              ToastUtil.showCenter('search');
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: BoxWithBottomPlayerController(TabBarView(
          // controller: _tabController,
          children: <Widget>[
            MainPlaylistPage(), 
            MainCloudPage()],
        )),
    );
  }

} 
