import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';

import 'package:flutter_book/me/login_scene.dart';
import 'package:flutter_book/novel_detail/novel_detail_scene.dart';
import 'package:flutter_book/reader/reader_scene.dart';
import 'package:flutter_book/me/web_scene.dart';


class AppNavigator {
  static push(BuildContext context, Widget scene) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => scene,
      )
    );
  }

  static pushLogin(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder:(context){
      return LoginScene();
    }));
  }

  static pushNovelDetail(BuildContext context, Novel novel) {
    AppNavigator.push(context, NovelDetailScene(novel.id));
  }

  static pushReader(BuildContext context, int articleId) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ReaderScene(articleId: articleId);
    }));
  }

  static pushWeb(BuildContext context, String url, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return WebScene(url: url, title: title);
    }));
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }

}