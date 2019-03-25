import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_book/public.dart';

import '../part/part.dart';
import '../channel/channel_media_player.dart';
import '../repository/netease.dart';

import '../page/page_playing_list.dart';
import  '../part/wangyi/liked_song_list.dart';
import '../part//wangyi//netease.dart';

/**
 * 音乐播放页面
 */
class PlayingPage extends StatefulWidget {
  PlayingPage();
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {

  Music music;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    music =flutterPlay.value.current;
    flutterPlay.addListener(onPlayerStateChanged);
    debugPrint('PlayingPageState :  init stated');
  }

  void onPlayerStateChanged() {
    if (music != flutterPlay.value.current) {
      music =flutterPlay.value.current;
      if (music == null) {
        Navigator.pop(context);
      } else {
        setState(() {
          
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flutterPlay.removeListener(onPlayerStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //
          Material(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[

              ],
            ),
          ),

        ],
      ),
    );
  }
}


class ControllerBar extends StatelessWidget {
  Widget getPlayModeIcon(context, Color color) {
    var playMode =PlayerState.of(context,aspect: PlayerStateAspect.playMode)
          .value
          .playMode;
    switch (playMode) {
      case PlayMode.single:
        return Icon(
            Icons.repeat_one,
            color: color,
        );
      case PlayMode.sequence:
        return Icon(
          Icons.repeat,
          color: color,
        );
      case PlayMode.shuffle:
        return Icon(
          Icons.shuffle,
          color: color,
        );
    }  

    return Container();
  }

  ControllerBar();

  @override
  Widget build(BuildContext context) {

    var color =Theme.of(context).primaryIconTheme.color;
    var state =PlayerState.of(context,aspect:PlayerStateAspect.playbackState).value;

    final iconPlayPause =IndexedStack(
      index: state.isPlaying ? 0 :state.isBuffering ? 2 : 1,
      children: <Widget>[
        IconButton(
          tooltip: '暂停',
          iconSize: 40,
          icon: Icon(
            Icons.pause_circle_outline,
            color:color
          ),
          onPressed: (){
            flutterPlay.pause();
          },
        ),
        IconButton(
          tooltip: '播放',
          iconSize: 40,
          icon: Icon(
            Icons.play_circle_outline,
            color:color
          ),
          onPressed: (){
            flutterPlay.play();
          },
        ),
        Container(
          height: 56,
          width: 56,
          child: Center(
            child: Container(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(),
            ),
          ),
        )
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: getPlayModeIcon(context, color),
            onPressed: (){
              flutterPlay.changePlayMode();
            },
          ),
          IconButton(
            tooltip: '上一首',
            iconSize: 36,
            icon: Icon(
              Icons.skip_previous,
              color:color
            ),
            onPressed: (){
              flutterPlay.playPrevious();
            },
          ),
          iconPlayPause,
          IconButton(
            tooltip: '下一首',
            iconSize: 36,
            icon: Icon(
              Icons.skip_next,
              color:color
            ),
            onPressed: (){
              flutterPlay.playNext();
            },
          ),
          IconButton(
            tooltip: '当前播放列表',
            icon: Icon(
              Icons.menu,
              color: color,
            ),
            onPressed: (){
              showModalBottomSheet(
                context: context,
                builder: (context){
                  return PlaylistDialog();
                }
              );
            },
          ),
        ],
      ),
    );
  }
}

class DurationProgressBar extends StatefulWidget {

  _DurationProgressBarState createState() => _DurationProgressBarState();
}

class _DurationProgressBarState extends State<DurationProgressBar> {
  bool isUserTracking =false;
  double trackingPosition = 0;
  @override
  Widget build(BuildContext context) {
    var theme =Theme.of(context).primaryTextTheme;
    var state =PlayerState.of(context).value;

    Widget progressIndicator;
    String durationText;
    String positionText;

    if (state.initialized) {
      var duration =state.duration.inMilliseconds;
      var position =isUserTracking
          ? trackingPosition.round()
          : state.position.inMilliseconds;

      durationText =getTimeStamp(duration);
      positionText =getTimeStamp(position);

      int maxBuffering = 0;

      for (DurationRange range in state.buffered) {
        final int end = range.end.inMilliseconds;
        if (maxBuffering > end) {
          maxBuffering =end;
        }
      }

      progressIndicator =Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Slider(
            value: position.toDouble().clamp(0.0, duration.toDouble()),
            min: 0.0,
            activeColor: theme.body1.color.withOpacity(0.75),
            inactiveColor: theme.caption.color.withOpacity(0.3),
            max: duration.toDouble(),
            onChangeStart: (value){
              setState(() {
               isUserTracking =true;
               trackingPosition =value; 
              });
            },
            onChanged: (value){
              setState(() {
               trackingPosition =value; 
              });
            },
            onChangeEnd: (value) async {
              isUserTracking =false;
              flutterPlay.seekTo(value.round());
              if (!flutterPlay.value.playWhenReady) {
                flutterPlay.play();
              }
            },
          ),
        ],
      );

    } else {
      progressIndicator =Slider(value: 0,onChanged: (_) => {});

    }


    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: <Widget>[
          Text(positionText ?? '00:00',style:theme.body1),
          Padding(padding: EdgeInsets.only(left: 4)),
          Expanded(
            child: progressIndicator,
          ),
          Padding(padding: EdgeInsets.only(left: 4)),
          Text(durationText ?? '00:00', style:theme.body1),
        ],
      ),
    );
  }
}

class OpertionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iconColor =Theme.of(context).primaryIconTheme.color;

    final music =flutterPlay.value.current;
    final liked = LikedSongList.contains(context, music);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(
            liked ? Icons.favorite :Icons.favorite_border,
            color:iconColor
          ),
          onPressed: (){
            if (liked) {
              Netease.of(context).dislikeMusic(music);
            } else {
              Netease.of(context).likeMusic(music);
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.file_download,
            color:iconColor
          ),
          onPressed: (){
            notImplemented(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.comment,
            color:iconColor
          ),
          onPressed: (){
            if (music == null) {
              return;
            }
            Toast.showCenter('进入 comment page');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.share,
            color:iconColor
          ),
          onPressed: (){
            notImplemented(context);
          },
        ),
      ],
    );
  }
}


class CenterSection extends StatefulWidget {
  final Music music;

  CenterSection({Key key, @required this.music}) : super(key: key);

  _CenterSectionState createState() => _CenterSectionState();
}

class _CenterSectionState extends State<CenterSection> {
  bool showLyric =false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedCrossFade(
        crossFadeState: 
              showLyric ? CrossFadeState.showSecond :CrossFadeState.showFirst,
        layoutBuilder: (Widget topChild, Key topChildKey,
            Widget bottomChild, Key bottomChildKey){
          return Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Center(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Center(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        }, 
        duration: Duration(milliseconds: 300),
        firstChild: GestureDetector(
          onTap: (){
            setState(() {
             showLyric = !showLyric; 
            });
          },
          child: AlbumCover(music: widget.music),
        ),    
        secondChild: CloudLyric(
          music: widget.music,
          onTap: (){
            setState(() {
             showLyric = !showLyric; 
            });
          },
        ), 
      ),
    );
  }
}

class AlbumCover extends StatefulWidget {
  final Music music;

  AlbumCover({Key key, @required this.music}) : super(key: key);

  _AlbumCoverState createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<AlbumCover> with TickerProviderStateMixin{

  AnimationController needleController;
  Animation<double> needleAnimation;
  AnimationController translateController;
  bool needleAttachCover =false;
  bool coverRotating =false;

  double coverTranslateX = 0;
  bool beDragging =false;
  bool previousNextDirty =false;

  Music previous;
  Music current;
  Music next;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    bool attachToCover =flutterPlay.value.playWhenReady &&
            (flutterPlay.value.isPlaying || flutterPlay.value.isBuffering);

    needleController =AnimationController(
      value: attachToCover ? 1.0 : 0.0,
      vsync: this,
      duration: Duration(milliseconds: 500),
      animationBehavior: AnimationBehavior.normal
    );        
    needleAnimation =Tween<double>(begin:-1 / 12, end: 0)
            .chain(CurveTween(curve:Curves.easeInOut))
            .animate(needleController);

    flutterPlay.addListener(onMusicStateChanged);  
    current =widget.music;

    () async {
      previous =await flutterPlay.getPrevious();
      next =await flutterPlay.getNext();
      if (mounted) {
        setState(() {});
      }
    }();      
  }


  @override
  void didUpdateWidget(AlbumCover oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (current ==widget.music) {
      if (previousNextDirty) {
        previousNextDirty =false;
        () async {
          previous =await flutterPlay.getPrevious();
          next =await flutterPlay.getNext();
          if (mounted) {
            setState(() {});
          }
        }();
      }
      return;
    }
    rotateNeedle(false);
    setState(() {
     double offset = 0;
     if (widget.music ==previous) {
       offset =MediaQuery.of(context).size.width;
     } else if (widget.music ==next) {
       offset = -MediaQuery.of(context).size.width;
     }
     animateCoverTranslateTo(offset, onCompleted:(){
       setState(() {
        coverTranslateX = 0;
        current =widget.music;
        previousNextDirty =false; 
        () async {
          next =await flutterPlay.getNext();
          previous =await flutterPlay.getPrevious();
          if (mounted) {
            setState(() {});
          }
        }();
       });
     });

    });
    
  }

  void onMusicStateChanged() {
    var state =flutterPlay.value;
    var isPlaying =state.isPlaying;
    setState(() {
     coverRotating =isPlaying && needleAttachCover; 
    });

    bool attachToCover =state.playWhenReady &&
          (state.isPlaying || state.isBuffering) &&
          !beDragging &&
          translateController == null;
    rotateNeedle(attachToCover);      
  }

  void rotateNeedle(bool attachToCover) {
    if (needleAttachCover ==attachToCover) {
      return;
    }
    
    needleAttachCover =attachToCover;
    if (attachToCover) {
      needleController.forward(from: needleController.value);
    } else {
      needleController.reverse(from: needleController.value);
    }
  }

  void animateCoverTranslateTo(double des, {void onCompleted()}) {
    translateController?.dispose();
    translateController =null;
    translateController =AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    );
    final animation = Tween(begin: -coverTranslateX,end: des).animate(translateController);
    animation.addListener((){
      setState(() {
       coverTranslateX =animation.value; 
      });
    });
    animation.addStatusListener((status){
      if (status ==AnimationStatus.completed) {
        translateController?.dispose();
        translateController = null;
        if (onCompleted != null) {
          onCompleted();
        }
      }
    });
    translateController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flutterPlay.removeListener(onMusicStateChanged);
    needleController.dispose();
    translateController?.dispose();
    translateController = null;
    super.dispose();
  }

  static const double HEIGHT_SPACE_ALBUM_TOP = 100;


  

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onHorizontalDragStart: (detail) {
            beDragging =true;
            rotateNeedle(false);
          },
          onHorizontalDragUpdate: (detail) {
            if (beDragging) {
              setState(() {
               coverTranslateX +=detail.primaryDelta; 
              });
            }
          },
          onHorizontalDragEnd: (detail) {
            beDragging =false;
            if (coverTranslateX.abs() > MediaQuery.of(context).size.width / 2) {
              var des =MediaQuery.of(context).size.width;
              if (coverTranslateX < 0) {
                des = -des;
              }
              animateCoverTranslateTo(des, onCompleted: () {
                setState(() {
                 coverTranslateX = 0;
                 if (des > 0) {
                   current =previous;
                   flutterPlay.playPrevious();
                 } else {
                   current =next;
                   flutterPlay.playNext();
                 }
                 previousNextDirty =true;
                });
              });
            } else {
              animateCoverTranslateTo(0);
            }
          },
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.only(
              left: 64, right: 64, top: HEIGHT_SPACE_ALBUM_TOP
            ),
            child: Stack(
              children: <Widget>[
                Transform.scale(
                  scale: 1.035,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipOval(
                      child: Container(
                        color: Colors.white10,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(coverTranslateX - MediaQuery.of(context).size.width, 0),
                  child: RotationCoverImage(
                    rotating: false,
                    music: previous,
                  ),
                ),
                Transform.translate(
                  offset: Offset(coverTranslateX, 0),
                  child: RotationCoverImage(
                    rotating: coverRotating && !beDragging,
                    music: current,
                  ),
                ),
                Transform.translate(
                  offset: Offset(coverTranslateX + MediaQuery.of(context).size.width, 0),
                  child: RotationCoverImage(
                    rotating: false,
                    music: next,
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: Container(
            child: Align(
              alignment: Alignment(0, -1),
              child: Transform.translate(
                offset: Offset(40, -15),
                child: RotationTransition(
                  turns: needleAnimation,
                  alignment:
                    const Alignment(-1 + 44 * 2 / 273, -1 + 37 * 2 /402),
                  child: Image.asset(
                    'assets/playing_page_needle.png',
                    height:HEIGHT_SPACE_ALBUM_TOP * 1.8
                  ),  
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class CloudLyric extends StatefulWidget {
  final Music music;
  final VoidCallback onTap;

  CloudLyric({Key key,this.onTap,@required this.music}) : super(key: key);

  _CloudLyricState createState() => _CloudLyricState();
}

class _CloudLyricState extends State<CloudLyric> {

  ValueNotifier<int> position = ValueNotifier(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterPlay.addListener(onMusicStateChanged);
    onMusicStateChanged();
  }

  void onMusicStateChanged() {
    position.value =flutterPlay.value.position.inMilliseconds;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flutterPlay.removeListener(onMusicStateChanged);
    position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =Theme.of(context)
          .textTheme
          .body1
          .copyWith(height: 1.5,fontSize: 16, color: Colors.white);

    return Loader<LyricContent>(
      key: Key('lyric_${widget.music.id}'),
      loadTask: () async {
        final str =await neteaseRepository.lyric(widget.music.id);
        if (str == null) {
          Toast.showCenter('暂未歌词');
          throw '暂无歌词';
        }
        return LyricContent.from(str);
      },
      failedWidgetBuilder: (context,result,msg){
        if (!(msg is String)) {
          msg = '加载歌词出错';
          // Toast.showCenter('加载歌词出错');
        }
        return Container(
          child: Center(
            child: Text(msg, style: style),
          ),
        );
      },
      builder: (context,result){
        return LayoutBuilder(builder: (context,constraints){
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Lyric(
              lyric: result,
              lyricLineStyle: style.copyWith(color: style.color.withOpacity(0.7)),
              highlight: style.color,
              position: position,
              onTap: widget.onTap,
              size: Size(
                constraints.maxWidth, 
                constraints.maxHeight ==double.infinity ? 0 :constraints.maxHeight
                ),
            ),
          );
        });
      },
    );
  }
}

class RotationCoverImage extends StatefulWidget {
  final bool rotating;
  final Music music;

  RotationCoverImage(
      {Key key, @required this.rotating, @required this.music})
       : assert(rotating !=null),
       super(key: key);

  _RotationCoverImageState createState() => _RotationCoverImageState();
}

class _RotationCoverImageState extends State<RotationCoverImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}