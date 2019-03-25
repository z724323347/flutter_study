import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_book/global.dart';
import 'package:flutter_book/public.dart';
import 'package:flutter_book/util/event_bus.dart';
import 'user_manager.dart';
import 'constant.dart';
import 'e_color.dart';

import 'package:flutter_book/home/home_scene.dart';
import 'package:flutter_book/bookshelf/bookshelf_scene.dart';
import 'package:flutter_book/me/me_scene.dart';
import 'package:flutter_book/music/music_main_page_scene.dart';

class RootScene extends StatefulWidget {
  _RootSceneState createState() => _RootSceneState();
}

class _RootSceneState extends State<RootScene> {

  int _tabIndex = 1; //定义首页为第index个页面
  bool isFinishSetup =false;

  List<Image> _tabImages = [
    Image.asset('img/tab_bookshelf_n.png'),
    Image.asset('img/tab_bookstore_n.png'),
    Image.asset('img/tab_me_n.png'),
    Image.asset('img/tab_music_n.png'),
  ];
  List<Image> _tabSelectedImages = [
    Image.asset('img/tab_bookshelf_p.png'),
    Image.asset('img/tab_bookstore_p.png'),
    Image.asset('img/tab_me_p.png'),
    Image.asset('img/tab_music_p.png'),
  ];

  void initState() { 
    super.initState();
    
    setupApp();

    eventBus.on(EventUserLogin, (arg) {
      setState(() {});
    });

    eventBus.on(EventUserLogout, (arg){
      setState(() {});
    });

    eventBus.on(EventToggleTabBarIndex, (arg){
      setState(() {
       _tabIndex = arg; 
      });
    });

  }

  @override
  void dispose(){
    eventBus.off(EventUserLogin);
    eventBus.off(EventUserLogout);
    eventBus.off(EventToggleTabBarIndex);
    super.dispose();
  }

  setupApp() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
     isFinishSetup = true; 
    });
  }


  @override
  Widget build(BuildContext context) {

    if (!isFinishSetup) {
      return Container();
    }
    
    return Scaffold(
      body: IndexedStack(
        children: <Widget>[
          BookshelfScene(),
          HomeScene(),
          MeScene(),
          MusicMainPage()
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: EColor.primary,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: getTabIcon(0),title: Text('书架')),
          BottomNavigationBarItem(icon: getTabIcon(1),title: Text('书城')),
          BottomNavigationBarItem(icon: getTabIcon(2),title: Text('我的')),
          BottomNavigationBarItem(icon: getTabIcon(3),title: Text('音乐'))
        ],
        currentIndex: _tabIndex,
        onTap: (index){
          setState(() {
           _tabIndex =index; 
          });
        },
      ),
    );
  }

  Image getTabIcon(int index) {
    if (index ==_tabIndex) {
      return _tabSelectedImages[index];
    }else {
      return _tabImages[index];
    }
  }

}