import 'package:flutter/material.dart';
import '../part.dart';
import 'package:flutter_book/music/repository/netease.dart';


class Netease extends StatefulWidget {
  final Widget child;

  Netease({Key key, @required this.child}) : super(key: key);

  _NeteaseState createState() => _NeteaseState();

  static _NeteaseState of(BuildContext context) {
    return context.ancestorStateOfType(TypeMatcher<_NeteaseState>());
  }
}

class _NeteaseState extends State<Netease> {

  Map user=neteaseRepository.user.value;
  
  List<int> likedSongList = [];

  // 加入收藏
  Future<void> likeMusic(Music music) async {
    final succeed =await neteaseRepository.like(music.id, true);
    if (succeed) {
      setState((){
        likedSongList =List.from(likedSongList)..add(music.id);
      });
    }
  }

  //取消收藏
  Future<void> dislikeMusic(Music music) async {
    final succeed =await neteaseRepository.like(music.id, false);
    if (succeed) {
      setState((){
        likedSongList =List.from(likedSongList)..remove(music.id);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    neteaseRepository.user.addListener(onUserChanged);
    loadUserLikedList();
  }

  void onUserChanged() {
    setState(() {
     this.user =neteaseRepository.user.value; 
     loadUserLikedList();
    });
  }

  Future loadUserLikedList() async {
    if (user == null) {
      return;
    }
    likedSongList = (await neteaseLocalData['likedSongList'] as List)?.cast() ?? const[];
    setState(() {});
    
    try {
      likedSongList = await neteaseRepository.likedList(user['account']['id']);
      neteaseLocalData['likedSongList'] =likedSongList;
      setState(() {});
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    neteaseRepository.user.removeListener(onUserChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: widget.child,
    );
  }
}