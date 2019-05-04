import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:flutter_book/public.dart';
import 'part.dart';
import 'package:flutter_book/model/music.dart';
import '../repository/netease.dart';

export 'package:flutter_book/model/music.dart';

typedef SongTitleCallback =  void Function(Music music);

/// provider song list item widget
class SongTitleProvider {
  SongTitleProvider(this.token, this.musics)
      : assert(token != null),
        assert(musics != null);

  final List<Music> musics;

  final String token;

  //song item length plus a header
  get size => musics.length + 1;

  void _playAll(BuildContext context) {
    if (flutterPlay.value.token == token && flutterPlay.value.isPlaying) {
      //打开音乐播放页面
      ToastUtil.showCenter('打开音乐播放页面');
    } else {
      flutterPlay.playWithList(musics[0], musics, token);
    }
  }

  void _play(int index, BuildContext context) {
    var toPlay = musics[index];
    if (flutterPlay.value.token == token &&
        flutterPlay.value.isPlaying &&
        flutterPlay.value.current == toPlay) {
        //打开音乐播放页面
        ToastUtil.showCenter('打开音乐播放页面 ing');
    } else {
      flutterPlay.playWithList(toPlay, musics, token);
    }
  }

  ///size : the music count of this list
  Widget buildListHeader(BuildContext context, {Widget tail, int size}) {
    size = size ?? musics.length;
    return SongListHeader(size, _playAll, tail: tail);
  }

  ///build title for song list
  /// index = 0 -> song list header
  /// index = other -> song tile
  ///
  /// leadingType : the leading of a song tile, detail for [SongTileLeadingType]
  Widget buildWidget(
    int index,
    BuildContext context, {
    SongTitleLeadingType leadingType = SongTitleLeadingType.number,
    SongTitleCallback onTap,
    VoidCallback onDelete,
    bool showAlbumPopupItem = true,
  }) {
    if (index == 0) {
      return buildListHeader(context);
    }
    if (index - 1 < musics.length) {
      var item = musics[index - 1];
      return SongTile(
        item,
        index,
        onTap: () => onTap == null ? _play(index - 1, context) : onTap(item),
        leadingType: leadingType,
        onDelete: onDelete,
        // playing: token == PlayerState.of(context).value.token &&
        //     item == PlayerState.of(context).value.current,
        showAlbumPopupItem: showAlbumPopupItem,
      );
    }
    return null;
  }
}

/// song list header
class SongListHeader extends StatelessWidget {
  SongListHeader(this.count, this.onTap, {this.tail});

  final int count;

  final void Function(BuildContext) onTap;

  final Widget tail;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(context),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: 0.5)
                    )
              ),
        child: Row(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16)),
            Icon(
              Icons.play_circle_outline,
              size: 18,
              color: Theme.of(context).iconTheme.color,
            ),
            Padding(padding: EdgeInsets.only(left: 4)),
            Text(
              "播放全部",
              style: Theme.of(context).textTheme.body1,
            ),
            Padding(padding: EdgeInsets.only(left: 2)),
            Text(
              "(共$count首)",
              style: Theme.of(context).textTheme.caption,
            ),
            Spacer(),
            tail,
          ]..removeWhere((v) => v == null),
        ),
      ),
    );
  }
}

///the leading for song tile
///default is show a number in the front of song tile
enum SongTitleLeadingType {
  none,
  cover,
  number,
}

/// song item widget
class SongTile extends StatelessWidget {
  SongTile(this.music, this.index,
      {this.onTap,
      this.leadingType = SongTitleLeadingType.number,
      this.playing = false,
      this.onDelete,
      this.showAlbumPopupItem = true})
      : assert(leadingType != null);

  /// song data
  final Music music;

  /// [music]'index in list, start with 1
  final int index;

  final bool playing;

  final GestureTapCallback onTap;

  final SongTitleLeadingType leadingType;

  ///callback when popup menu delete selected
  ///if [onDelete] be null , popup menu will not show delete menu
  final VoidCallback onDelete;

  ///是否在更多中显示 [SongPopupMenuType.album] 按钮
  final bool showAlbumPopupItem;

  Widget buildLeading(BuildContext context) {
    if (leadingType != SongTitleLeadingType.none && playing) {
      return Container(
        margin: const EdgeInsets.only(left: 8, right: 8),
        width: 40,
        height: 40,
        child: Center(
          child: Icon(Icons.volume_up, color: Theme.of(context).primaryColor),
        ),
      );
    }
    Widget leading;
    switch (leadingType) {
      case SongTitleLeadingType.number:
        leading = Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          width: 40,
          height: 40,
          child: Center(
            child: Text(
              index.toString(),
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        );
        break;
      case SongTitleLeadingType.none:
        leading = Padding(padding: EdgeInsets.only(left: 16));
        break;
      case SongTitleLeadingType.cover:
        leading = Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image(
              image: NetworkImage(music.album.coverImageUrl),
            ),
          ),
        );
        break;
    }
    return leading;
  }

  void _onPopupMenuSelected(
      BuildContext context, SongPopupMenuType type) async {
    switch (type) {
      case SongPopupMenuType.addToNext:
        flutterPlay.insertToNext(music);
        break;
      case SongPopupMenuType.comment:
        ToastUtil.showCenter('comment page \n评论');
        break;
      case SongPopupMenuType.delete:
        bool delete = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("确认将所选音乐从列表中删除?"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("取消")),
                  FlatButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("确认")),
                ],
              );
            });
        if (delete != null && delete && onDelete != null) {
          onDelete();
        }
        break;
      case SongPopupMenuType.addToPlaylist:
        final id = await showDialog(
            context: context,
            builder: (context) {
              return PlaylistSelectorDialog();
            });
        if (id != null) {
          bool succeed = await neteaseRepository
              .playlistTracksEdit(PlaylistOperation.add, id, [music.id]);
          var scaffold = Scaffold.of(context);
          if (scaffold == null) {
            //not notify when scaffold is empty
            return;
          }
          if (succeed) {
            showSimpleNotification(context, Text("已添加到收藏"));
          } else {
            showSimpleNotification(context, Text("收藏歌曲失败!"),
                background: Theme.of(context).errorColor);
          }
        }
        break;
      case SongPopupMenuType.album:
        ToastUtil.showCenter('AlbumDetailPage');
        break;
      case SongPopupMenuType.artists:
        ToastUtil.showCenter('artists');
        break;
      case SongPopupMenuType.download:
        ToastUtil.showCenter('download');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildLeading(context),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 0.3))),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Spacer(),
                        Text(
                          music.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body1,
                        ),
                        Padding(padding: EdgeInsets.only(top: 3)),
                        Text(
                          music.subTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Spacer(),
                      ],
                    )),
                    _MvIcon(music),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      itemBuilder: (context) =>
                          <PopupMenuItem<SongPopupMenuType>>[
                            PopupMenuItem(
                              child: Text("下一首播放"),
                              value: SongPopupMenuType.addToNext,
                            ),
                            PopupMenuItem(
                              child: Text("收藏到歌单"),
                              value: SongPopupMenuType.addToPlaylist,
                            ),
                            PopupMenuItem(
                              child: Text("下载"),
                              value: SongPopupMenuType.download,
                            ),
                            PopupMenuItem(
                              child: Text("评论"),
                              value: SongPopupMenuType.comment,
                            ),
                            PopupMenuItem(
                                child: Text(
                                    "歌手: ${music.artist.map((a) => a.name).join('/')}",
                                    maxLines: 1),
                                //如果所有artist的id为0，那么disable这个item
                                enabled: music.artist
                                        .fold(0, (c, ar) => c + ar.id) !=
                                    0,
                                value: SongPopupMenuType.artists),
                            !showAlbumPopupItem
                                ? null
                                : PopupMenuItem(
                                    child: Text("专辑:${music.album.name}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    value: SongPopupMenuType.album),
                            onDelete == null
                                ? null
                                : PopupMenuItem(
                                    child: Text("删除"),
                                    value: SongPopupMenuType.delete,
                                  ),
                          ]..removeWhere((v) => v == null),
                      onSelected: (type) => _onPopupMenuSelected(context, type),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///歌曲item的mv icon
class _MvIcon extends StatelessWidget {
  final Music music;

  const _MvIcon(this.music, {Key key})
      : assert(music != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (music.mvId == 0) {
      return Container();
    }
    return Tooltip(
      message: 'mv',
      child: InkWell(
          child: Container(
            constraints: BoxConstraints.expand(width: 40),
            child: Icon(Icons.videocam),
          ),
          onTap: () {
            ToastUtil.showCenter('mv !');
          }),
    );
  }
}

enum SongPopupMenuType {
  addToNext,
  comment,
  delete,

  ///添加到歌单
  addToPlaylist,

  ///导航到专辑
  album,

  ///导航到歌手
  artists,
  download,
}


// class SongTitleProvider {
//   final String token;
//   final List<Music> musics;

//   SongTitleProvider(this.token, this.musics)
//       :assert(token != null),
//        assert(musics !=null);
  
//   get size => musics.length + 1;

//   void playAll(BuildContext context) {
//     if (flutterPlay.value.token ==token && flutterPlay.value.isPlaying) {
//       //打开音乐播放页面
//       Toast.showCenter('打开音乐播放页面');
//     } else {
//       flutterPlay.playWithList(musics[0], musics, token);
//     }
//   }

//   void play(int index, BuildContext context) {
//     var toPlay =musics[index];
//     if (flutterPlay.value.token ==token &&
//           flutterPlay.value.isPlaying &&
//           flutterPlay.value.current ==toPlay) {
//       //打开音乐播放页面
//       Toast.showCenter('打开音乐播放页面');
//     }else {
//       flutterPlay.playWithList(toPlay, musics, token);
//     }
//   }

//   Widget buildListHeader(BuildContext context, {Widget tail, int size}) {
//     size =size ?? musics.length;
//     return SongListHeader(size, playAll, tail:tail);
//   }

//   Widget buildWidget(
//     int index,
//     BuildContext context,{
//     SongTitleLeadingType leadingType = SongTitleLeadingType.number,
//     SongTitleCallback onTap,
//     VoidCallback onDelete,
//     bool showAlbumPopupItem =true,
//     }) {
//       if (index == 0) {
//         return buildListHeader(context);
//       }
//       if (index - 1 < musics.length) {
//         var item =musics[index - 1];
//         return SongTitle(
//           item,
//           index,
//           onTap: () => onTap == null ? play(index -1 ,context) :onTap(item),
//           leadingType: leadingType,
//           onDelete: onDelete,

//           playing: token ==PlayerState.of(context).value.token &&
//                 item ==PlayerState.of(context).value.current,
//           showAlbumPopupItem: showAlbumPopupItem,
//         );
//       }
//     return null;
//   }

// }

// class SongListHeader extends StatelessWidget {
//   final Widget tail;
//   final int count;
//   final Function(BuildContext) onTap;

//   SongListHeader(this.count, this.onTap, {this.tail});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => onTap(context),
//       child: Container(
//         height:  40,
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: Theme.of(context).dividerColor,width: 0.5
//             )
//           ),
//         ),
//         child: Row(
//           children: <Widget>[
//             Padding(padding: EdgeInsets.only(left: 16)),
//             Icon(
//               Icons.play_circle_outline,
//               size: 18,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             Padding(padding: EdgeInsets.only(left: 4)),
//             Text(
//               '全部播放',
//               style:Theme.of(context).textTheme.body1
//             ),
//             Padding(padding: EdgeInsets.only(left: 2)),
//             Text(
//               '(共$count 首)',
//               style: Theme.of(context).textTheme.caption,
//             ),
//             Spacer(),
//             tail
//           ]..removeWhere((v) => v == null),
//         ),
//       ),
//     );
//   }
// }

// class SongTitle extends StatelessWidget {

//   final Music music;
//   final int index;
//   final bool playing;
//   final GestureTapCallback onTap;
//   final SongTitleLeadingType leadingType;
//   final VoidCallback onDelete;
//   final bool showAlbumPopupItem;
  
//   SongTitle(this.music,this.index,
//     {this.onTap,
//      this.leadingType =SongTitleLeadingType.number,
//      this.playing =false,
//      this.onDelete ,
//      this.showAlbumPopupItem =true})
//     :assert(leadingType !=null);

//   Widget buildLeading(BuildContext context) {
//     if (leadingType !=SongTitleLeadingType.none && playing) {
//       return Container(
//         margin: const EdgeInsets.only(left: 8,right: 8),
//         width: 40,
//         height: 40,
//         child: Center(
//           child: Icon(Icons.volume_up, color:Theme.of(context).primaryColor),
//         ),
//       );
//     }
//     Widget leading;
//     switch (leadingType) {
//       case SongTitleLeadingType.number:
//         leading =Container(
//           margin: const EdgeInsets.only(left: 8,right: 8),
//           width: 40,
//           height: 40,
//           child: Center(
//             child: Text(
//               index.toString(),
//               style:Theme.of(context).textTheme.body2
//             ),
//           ),
//         );
//         break;

//       case SongTitleLeadingType.none:
//         leading =Padding(padding: EdgeInsets.only(left: 16));
//         break;

//       case SongTitleLeadingType.cover:
//         leading =Container(
//           margin: const EdgeInsets.only(left: 8,right: 8),
//           width: 40,
//           height: 40,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(3),
//             child: Image(
//               image: NetworkImage(music.album.coverImageUrl),
//             ),
//           ),
//         );
//         break;
//     }
//     return leading;
//   }  

//   void onPopupMenuSelected(
//     BuildContext context, SongPopupMenuType type) async {
    
//     switch (type) {
//       case SongPopupMenuType.addtoNext:
//         flutterPlay.insertToNext(music);
//         break;

//       case SongPopupMenuType.comment:
//         Toast.showCenter('comment page \n评论');
//         break; 

//       case SongPopupMenuType.delete:
//         bool delete =await showDialog<bool>(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               content: Text('确认删除列表中选择的音乐'),
//               actions: <Widget>[
//                 FlatButton(
//                   onPressed: () => Navigator.pop(context,false),
//                   child: Text('取消'),
//                 ),
//                 FlatButton(
//                   onPressed: (){
//                     Navigator.pop(context,true);
//                     Toast.showCenter('模拟数据删除');
//                   },
//                   child: Text('确定'),
//                 )
//               ],
//             );
//           }
//         );
//         if (delete !=null && delete && onDelete !=null) {
//           onDelete();
//         }
//         break; 

//       case SongPopupMenuType.addToPlaylist:
//         final id =await showDialog(
//           context: context,
//           builder: (context) {
//             return PlaylistSelectorDialog();
//           }
//         );
//         if (id !=null) {
//           bool succeed =await neteaseRepository
//                 .playlistTracksEdit(PlaylistOperation.add, id, [music.id]);
//           var scaffold =Scaffold.of(context);
//           if (scaffold == null) {
//             return;
//           }
//           if (succeed) {
//             showSimpleNotification(context,Text('已添加到收藏'));
//           }else {
//             showSimpleNotification(context,Text('添加收藏失败'),
//             // icon:Icon(Icons.error),
//             background: Theme.of(context).errorColor);
//           }
//         }
//         break;  
      
//       case SongPopupMenuType.album:
//         Toast.showCenter('album');
//         break;    

//       case SongPopupMenuType.artists:
//         Toast.showCenter('artists');
//         break;  

//       case SongPopupMenuType.download:
//         Toast.showCenter('download');
//         break;    
//       default:
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56,
//       child: InkWell(
//         onTap: onTap,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             buildLeading(context),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                       color: Theme.of(context).dividerColor,
//                       width: 0.3
//                     )
//                   )
//                 ),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: <Widget>[
//                           Spacer(),
//                           Text(
//                             music.title,
//                             maxLines:1,
//                             overflow:TextOverflow.ellipsis,
//                             style:Theme.of(context).textTheme.body1
//                           ),
//                           Padding(padding: EdgeInsets.only(top: 3)),
//                           Text(
//                             music.subTitle,
//                             maxLines:1,
//                             overflow:TextOverflow.ellipsis,
//                             style:Theme.of(context).textTheme.caption,
//                           ),
//                           Spacer()
//                         ],
//                       ),
//                     ),
//                     MvIcon(music),
//                     PopupMenuButton(
//                       icon: Icon(
//                         Icons.more_vert,
//                         color: Theme.of(context).iconTheme.color,
//                       ),
//                       itemBuilder: (context){
//                         <PopupMenuItem<SongPopupMenuType>>[
//                           PopupMenuItem(
//                             child: Text('播放下一首'),
//                             value: SongPopupMenuType.addtoNext,
//                           ),
//                           PopupMenuItem(
//                             child: Text('收藏到歌单'),
//                             value: SongPopupMenuType.addToPlaylist,
//                           ),
//                           PopupMenuItem(
//                             child: Text('下载'),
//                             value: SongPopupMenuType.download,
//                           ),
//                           PopupMenuItem(
//                             child: Text('评论'),
//                             value: SongPopupMenuType.comment,
//                           ),
//                           PopupMenuItem(
//                             child: Text('歌手: ${music.artist.map((m) => m.name).join('/')}',maxLines: 1),
//                             //artist id == 0 ,disable item
//                             enabled: music.artist.fold(0, (c,ar) => c + ar.id) != 0,
//                             value: SongPopupMenuType.artists
//                           ),
//                           !showAlbumPopupItem ? null :PopupMenuItem(
//                             child: Text(
//                               '专辑: ${music.album.name}',
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             value: SongPopupMenuType.album,
//                           ),
//                           onDelete == null ? null :PopupMenuItem(
//                             child: Text('删除'),
//                             value: SongPopupMenuType.delete,
//                           )
//                         ]..removeWhere((v) => v == null);
//                       },
//                       onSelected: (type) => onPopupMenuSelected(context,type),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class MvIcon extends StatelessWidget {
//   final Music music;

//   MvIcon(this.music, {Key key}) 
//       :assert(music != null),
//        super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (music.mvId == 0) {
//       return Container();
//     }
//     return Tooltip(
//       message: 'mv',
//       child: InkWell(
//         child: Container(
//           constraints: BoxConstraints.expand(width: 40),
//           child: Icon(Icons.videocam),
//         ),
//         onTap: () {
//           Toast.showCenter('play MV !');
//         },
//       ),
//     );
//   }
// }

// enum SongTitleLeadingType {
//   none,
  
//   cover,

//   number,
// }

// enum SongPopupMenuType {
//   addtoNext,

//   comment,

//   delete,

//   addToPlaylist,

//   album,
//   artists,
//   download,
// }
