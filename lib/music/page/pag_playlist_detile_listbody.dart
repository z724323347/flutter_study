import 'package:flutter/material.dart';

import '../part/part.dart';
import 'page_playlist_detail.dart';
import '../part/part_player.dart';
import '../page/page_playlist_detail_playlist_header.dart';

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
      ],
    );
  }

  Widget buildList(BuildContext context, int index) {
    if (index == 0) {
      return PlaylistDetailHeader(widget.playlist);
    }
    
  }
}

