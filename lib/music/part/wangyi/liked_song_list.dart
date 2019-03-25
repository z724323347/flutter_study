import 'package:flutter/material.dart';
import 'package:flutter_book/model/music.dart';

class LikedSongList extends InheritedWidget {
  final List<int> ids;
  LikedSongList(
      this.ids, 
      {Key key, 
      @required Widget child,}) : super(key: key, child: child);

  static bool contains(BuildContext context,Music music) {
    final list =
         (context.inheritFromWidgetOfExactType(LikedSongList)as LikedSongList);
    assert(list != null);
    return list.ids?.contains(music.id)  ==true;     
  }

  @override
  bool updateShouldNotify( LikedSongList oldWidget) {
    return ids !=oldWidget;
  }
}