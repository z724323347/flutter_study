import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_book/app/root_scene.dart';
import 'package:flutter_book/bookshelf/bookshelf_scene.dart';
import 'package:flutter_book/home/home_scene.dart';
import 'package:flutter_book/me/me_scene.dart';
import 'package:flutter_book/music/music_main_page_scene.dart';

class TestGo extends StatefulWidget {
  @override
  _TestGoState createState() => _TestGoState();
}

class _TestGoState extends State<TestGo> {
  int _tabIndex = 1; //定义首页为第index个页面
  bool isFinishSetup = false;

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
  Image getTabIcon(int index) {
    if (index ==_tabIndex) {
      return _tabSelectedImages[index];
    }else {
      return _tabImages[index];
    }
  }

  @override
  Widget build(BuildContext context) {

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
        activeColor: Colors.pink,
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('go'),
    //   ),
    //   body: Column(
    //     children: <Widget>[
    //       OutlineButton(
    //         onPressed: () {
    //           Navigator.push(
    //               context, MaterialPageRoute(builder: (_) => RootScene()));
    //         },
    //         child: Text('go'),
    //       ),
    //       Image.asset('img/tab_bookshelf_n.png'),
    //       Image.network(
    //           'https://upload-images.jianshu.io/upload_images/266795-85352c51166d8386.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp')
    //     ],
    //   ),
    // );
  }
}
