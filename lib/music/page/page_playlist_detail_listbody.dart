import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../part/part.dart';
import 'page_playlist_detail.dart';
import '../part/part_player.dart';
import '../page/page_playlist_detail_playlist_header.dart';
import '../page/page_playlist_detail_opcitytitle.dart';
import 'package:flutter_book/music/widget/view_subscribe_button.dart';

import 'package:flutter_book/public.dart';

class PlaylistBody extends StatefulWidget {
  final PlaylistDetail playlist;
  
  List<Music> get musicList => playlist.musicList;

  PlaylistBody(this.playlist) : assert(playlist != null);

  _PlaylistBodyState createState() => _PlaylistBodyState();
}

class _PlaylistBodyState extends State<PlaylistBody> {
  SongTitleProvider songTitleProvider;
  ScrollController scrollController;
  ValueNotifier<double> appBarOpacity =ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint(
      'playlist detail : ${widget.playlist.id}, count : ${widget.musicList.length}'
    );

    songTitleProvider =SongTitleProvider('playlist_${widget.playlist.id}', widget.musicList);
    scrollController =ScrollController();
    scrollController.addListener((){
      var scrollHeight =scrollController.offset;
      double appBarHeight =MediaQuery.of(context).padding.top + kToolbarHeight;
      double areHeight = (HEIGHT_HEADER - appBarHeight);
      this.appBarOpacity.value = (scrollHeight / areHeight).clamp(0.0, 1.0);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlaylistBody oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    songTitleProvider =SongTitleProvider('pllaylist_${widget.playlist.id}', widget.musicList);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BoxWithBottomPlayerController(
          ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: 1 + (songTitleProvider?.size ?? 0),
            itemBuilder: buildList,
            controller: scrollController,
          ),
        ),
        Column(
          children: <Widget>[
            OpacityTitle(
              name: widget.playlist.name,
              defaultName: '歌单',
              appBarOpacity: appBarOpacity,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: '歌单内搜索',
                  onPressed: (){
                    Toast.showCenter('search');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  tooltip: '更多选项',
                  onPressed: (){
                    Toast.showCenter('功能未开发');
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildList(BuildContext context, int index) {
    if (index == 0) {
      return PlaylistDetailHeader(widget.playlist);
    }
    if (widget.musicList.isEmpty) {
      return EmptyPlaylistSection();
    }
    
    bool owner =widget.playlist.creator['userId'] == '';

    if (index == 1) {
      Widget tail;
      if (!owner) {
        tail = SubscribeButton(widget.playlist.subscribed,
              widget.playlist.subscribedCount, doSubscribeChanged);
      }
      return songTitleProvider?.buildListHeader(context, tail:tail);
    }
    return songTitleProvider?.buildWidget(index - 1, context,
        onDelete: !owner
            ? null
            : () async {
              var result =await neteaseRepository.playlistTracksEdit(
                PlaylistOperation.remove, 
                widget.playlist.id,
                [songTitleProvider.musics[index - 2].id]);

              if (result) {
                setState(() {
                 widget.playlist.musicList.removeAt(index - 2) ;
                });
                showSimpleNotification(context,Text('成功删除'));
              } else {
                showSimpleNotification(context,Text('删除失败'),
                  background: Theme.of(context).errorColor);
              }  
            });
  }

  Future<bool> doSubscribeChanged(bool subscribe) async {
    bool succeed;
    try {
      succeed =await showLoaderOverlay(context,
          neteaseRepository.playlistSubscribe(widget.playlist.id, !subscribe));
    } catch (e) {
      succeed =false;
    }

    String action = !subscribe ? '收藏':'取消收藏';
    if (succeed) {
      showSimpleNotification(context, Text('$action成功}'));
    } else {
      showSimpleNotification(context, Text('$action失败'),
          background: Theme.of(context).errorColor);
    }
    return succeed ? !subscribe :subscribe;
  }
}

class EmptyPlaylistSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Text('暂无音乐'),
      ),
    );
  }
}

