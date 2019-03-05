import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';

import '../page/page_playlist_detail_selection.dart';
import '../repository/netease.dart';
import '../part/part.dart';
import '../channel/channel_palette_generator.dart';

import '../page/page_playlist_detail_header.dart';
import '../page/page_playlist_detail_playlist_header.dart';
import '../page/pag_playlist_detail_opcitytitle.dart';
import '../page/pag_playlist_detile_listbody.dart';


import 'package:flutter_book/public.dart';


const double HEIGHT_HEADER = 300;
const Color default_background =Colors.black38;

class PlaylistDetailPage extends StatefulWidget {
  final int playlistId;
  final PlaylistDetail playlist;

  PlaylistDetailPage(this.playlistId, {this.playlist}) : assert(playlistId != null);

  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {

  Color primaryColor =default_background;
  bool primaryColorGenerated =false;

  void loadPrimaryColor(PlaylistDetail playlist) async {
    if (primaryColorGenerated) {
      return;
    }
    primaryColorGenerated =true;
    final color =await PaletteGenerator.getPrimaryColor(NeteaseImage(playlist.coverUrl));
    setState(() {
     this.primaryColor =color; 
    });
  }

  Widget buildPreview(BuildContext context, Widget content) {
    if (widget.playlist !=null) {
      loadPrimaryColor(widget.playlist);
    }

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            widget.playlist == null 
                ? null
                :PlaylistDetailHeader(widget.playlist),
            Expanded(child: SafeArea(child: content)),    
          ]..removeWhere((v) => v == null),
        ),
        Column(
          children: <Widget>[
            OpacityTitle(
              name:null,
              defaultName: '歌单',
              appBarOpacity:ValueNotifier(0),
            ),
          ],
        ),  
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
        primaryColorDark: primaryColor,
        accentColor: primaryColor
      ),
      child: Scaffold(
        body: Loader<PlaylistDetail>(
          initialData: neteaseLocalData.getPlaylistDetail(widget.playlistId),
          loadTask: () => neteaseRepository.playlistDetail(widget.playlistId),
          loadingBuilder: (context) {
            return buildPreview(
              context, 
              Container(
                height: 200,
                child: Center(child: Text('loading....')),
              ));
          },
          failedWidgetBuilder: (context, result, msg) {
            return buildPreview(
              context,
              Container(
                height: 200,
                child: Center(child: Text('loading error')),
              ));
          },
          builder: (context, result) {
            loadPrimaryColor(result);
            return PlaylistBody(result);
          },
        ),
      ),
    );
  }
}



