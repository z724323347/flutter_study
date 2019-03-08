import 'package:flutter/material.dart';

import '../repository/netease_image.dart';
import '../part/part_player_service.dart';
import '../page/page_playing_list.dart';

import 'package:flutter_book/public.dart';

class BoxWithBottomPlayerController extends StatelessWidget {
  
  final Widget child;

  BoxWithBottomPlayerController(this.child);

  @override
  Widget build(BuildContext context) {
    
    //hide bottom player controller when view inserts
    //bottom too height (such as typing with soft keyboard)
    bool hide = MediaQuery.of(context).viewInsets.bottom /
            MediaQuery.of(context).size.height >
        0.4;
    return Column(
      children: <Widget>[
        Expanded(child: child),
        hide ? Container() : BottomControllerBar(),
      ],
    );
  }
}

class BottomControllerBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var state =PlayerState.of(context, aspect:PlayerStateAspect.playbackState).value;
    var music =PlayerState.of(context, aspect:PlayerStateAspect.music).value.current;

    if (music == null) {
      return Container();
    }
    return InkWell(
      onTap: () {
        if (music != null) {
          Toast.showCenter('正在播放歌曲 ${music}');
        }
      },
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(4.0),
            topRight: const Radius.circular(4.0)
          )
        ),
        child: Container(
          height: 56,
          child: Row(
            children: <Widget>[
              Hero(
                tag: 'album_cover',
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      child: music.album.coverImageUrl ==null
                          ? Container(color: Colors.grey)
                          :Image(
                            fit: BoxFit.cover,
                            image: NeteaseImage(music.album.coverImageUrl),
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text(
                        music.title,
                        style:Theme.of(context).textTheme.body1
                      ),
                      Padding(padding: const EdgeInsets.only(top: 2)),
                      Text(
                        music.subTitle,
                        style:Theme.of(context).textTheme.caption,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Builder(builder: (context){
                if (state.isPlaying) {
                  return IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: (){
                      flutterPlay.pause();
                    },
                  );
                } else if (state.isBuffering) {
                  return Container(
                    height: 24,
                    width: 24,
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(4),
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: (){
                      flutterPlay.play();
                    },
                  );
                }
              }),
              IconButton(
                tooltip: '当前播放列表',
                icon: Icon(Icons.menu),
                onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return PlaylistDialog();
                    }
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}