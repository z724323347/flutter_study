import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';
import '../music/part/part_player.dart';
import '../music/page/page_main_playlist.dart';
import '../music/page/page_main_cloud.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Music...'),
        centerTitle: true,
      ),
      body: MainCloudPage(),
    );
  }

} 