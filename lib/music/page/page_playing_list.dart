import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../part/part.dart';
import '../channel/channel_media_player.dart';
import '../page/page_playing_list.dart';

class PlaylistDialog extends StatelessWidget {

  Widget buildHeader(BuildContext context, int count) {
    PlayMode playMode = 
          PlayerState.of(context,aspect: PlayerStateAspect.playMode)
          .value
          .playMode;
    IconData icon;
    String name;

    switch (playMode) {
      case PlayMode.single:
        icon =Icons.repeat_one;
        name = '单曲循环';
        break;

      case PlayMode.sequence:
        icon =Icons.repeat;
        name = '列表循环';
        break;

      case PlayMode.shuffle:
        icon =Icons.shuffle;
        name = '随机播放';
        break;  
    }

    return Material(
      elevation: 0.5,
      child: Container(
        height: 48,
        child: Row(
          children: <Widget>[
            FlatButton.icon(
              onPressed: (){
                flutterPlay.changePlayMode();
              },
              icon: Icon(icon),
              label: Text('$name($count)'),
            ),
            Spacer(),
            FlatButton.icon(
              onPressed: () async {
                final ids =flutterPlay.value.playingList.map((m) => m.id).toList();
                if (ids.isEmpty) {
                  return;
                }
                final succeed =await PlaylistSelectorDialog.addSongs(context, ids);
                if (succeed == null) {
                  return;
                }
                if (succeed) {
                  showSimpleNotification(context,Text('添加到收藏夹成功'));
                } else {
                  showSimpleNotification(context,Text('添加到收藏夹失败'),
                  background: Theme.of(context).errorColor);
                }
              },
              icon: Icon(Icons.add_box),
              label: Text('全部收藏'),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () async {
                Navigator.pop(context);
                flutterPlay.dispose();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Music> playingList = 
            PlayerState.of(context, aspect:PlayerStateAspect.playlist)
            .value
            .playingList;
    Music music = 
            PlayerState.of(context, aspect:PlayerStateAspect.music).value.current;

    Widget header =buildHeader(context, playingList.length);  
    double offset =playingList.indexOf(music) * HEIGHT_MUSIC_TITLE;  
    if (offset < 0) {
      offset = 0;
    }       
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: <Widget>[
          header,
          Expanded(
            child: ListView.builder(
              controller: ScrollController(initialScrollOffset: offset),
              itemCount: playingList.length,
              itemBuilder: (context,index) {
                var item =playingList[index];
                return MusicTitle(music: item,playing: item ==music);
              },
            ),
          )
        ],
      ),
    );
  }
}

const HEIGHT_MUSIC_TITLE = 48.0;

class MusicTitle extends StatelessWidget {
  final Music music;
  final bool playing;

  MusicTitle({Key key, this.music, this.playing =false})
      : assert(music != null && playing != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget leading;
    Color name, artist;
    if (playing) {
      Color color =Theme.of(context).primaryColor;
      leading =Container(
        margin: EdgeInsets.only(right: 8),
        child: Icon(
          Icons.volume_up,
          color:color,
          size: 18,
        ),
      );
      name =color;
      artist =color;
    } else {
      leading =Container();
      name =Theme.of(context).textTheme.body1.color;
      artist =Theme.of(context).textTheme.caption.color;
    }

    return InkWell(
      onTap: () {
        flutterPlay.play(music: music);
      },
      child: Container(
        padding: EdgeInsets.only(left: 8),
        height: HEIGHT_MUSIC_TITLE,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor, width: 0.3
            )
          )
        ),
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Text.rich(
                TextSpan(children:[
                  TextSpan(text:music.title, style:TextStyle(color:name)),
                  TextSpan(
                    text: ' - ${music.artist.map((m) => m.name).join('/')}',
                    style: TextStyle(color: artist,fontSize: 12)
                  )
                ]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                flutterPlay.removeFromPlayingList(music);
              },
            ),
          ],
        ),
      ),
    );
  }
}