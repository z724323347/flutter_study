import 'package:flutter/material.dart';
import 'package:flutter_book/music/music_main_page_scene.dart';
import '../page/page_playing.dart';

export '../page/page_playlist_detail.dart';
export '../page/page_playing_list.dart';
export '../page/page_playing.dart';
export 'package:flutter_book/music/music_main_page_scene.dart';


const ROUTE_MAIN = '/';

const ROUTE_LOGIN = '/login';

const ROUTE_PLAYLIST_DETATL = '/playlist/detail';

const ROUTE_PLAYING = '/playing';



//route
final Map<String, WidgetBuilder> routes = {
  //主页route
  ROUTE_MAIN : (context) => MusicMainPage(),
  //playing route
  ROUTE_PLAYING: (context) => PlayingPage(),
  // other route
};