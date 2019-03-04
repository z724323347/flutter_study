import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:flutter_book/model/music.dart';
import '../channel/channel_media_player.dart';


const String PREF_KEY_PLAYING = 'flutter_player_playing';

const String PREF_KEY_PLAYLIST = 'flutter_player_playlist';

const String PREF_KEY_TOKEN = 'flutter_player_token';

const String PREF_KEY_PLAY_MODE = 'flutter_player_mode';

MusicPlayer flutterPlay = MusicPlayer._private();

class MusicPlayer implements ValueNotifier<PlayerControllerState> {

  MusicPlayer._private() :super() {
    ()async {
      var preference =await SharedPreferences.getInstance();
      Music current;
      List<Music> playingList;
      String token;
      PlayMode playMode;
      try {
        current =Music.fromMap(json.decode(preference.get(PREF_KEY_PLAYING)));
        token =preference.get(PREF_KEY_TOKEN);
        playingList= (json.decode(preference.get(PREF_KEY_PLAYLIST)) as List)
              .cast<Map>()
              .map(Music.fromMap)
              .toList();
        
      } catch (e) {
        debugPrint(e.toString());
      }

      debugPrint('loaded :  $current');
      debugPrint('loaded :  $playingList');
      debugPrint('loaded :  $token');
      debugPrint('loaded :  $playMode');

      addListener((){
        if (current != value.current) {
          preference.setString(PREF_KEY_PLAYING,
              json.encode(value.current, toEncodable: (e) => e.toMap()));
          current = value.current;
        }
        if (playingList != value.playingList) {
          preference.setString(PREF_KEY_PLAYLIST,
              json.encode(value.playingList, toEncodable: (e) => e.toMap()));
          playingList = value.playingList;
        }
        if (playMode != value.playMode) {
          preference.setInt(PREF_KEY_PLAY_MODE, value.playMode.index);
          playMode = value.playMode;
        }
        if (token != value.token) {
          preference.setString(PREF_KEY_TOKEN, value.token);
          token = value.token;
        }
      });
      controller.init(playingList, current, token, playMode);
    }();

  }


  PlayerController get controller => playerController;

  Future<void> play({Music music}) async {
    if (music == null) {
      return;
    }
    if (!value.playingList.contains(music)) {
      await insertToNext(music);
    }
    await performPlay(music);
  }

  Future<void> insertToNext(Music music) {
    return insertToNext2([music]);
  }

  Future<void> insertToNext2(List<Music> list) async {
    final playingList =List.of(value.playingList);
    playingList.removeWhere((m) => list.contains(m));

    final index=playingList.indexOf(value.current);
    playingList.insertAll(index, list);
    await controller.updatePlaylist(playingList, value.token);
  }

  Future<void> removeFromPlayingList(Music music) async {
    if (!value.playingList.contains(music)) {
      return;
    }
    final list =List.of(value.playingList);
    list.remove(music);
    await controller.updatePlaylist(list, value.token);
  }

  Future<void> playWithList(Music music, List<Music> list, String token) async {
    debugPrint('playWithList  ${list.map((m) => m.title).join(",")}');
    debugPrint('playWithList token = $token');
    assert(list != null && token != null);
    if (list.isEmpty) {
      return;
    }
    if (music == null) {
      music =list.first;
    }
    await controller.updatePlaylist(list, token);
    await controller.playWith(music);
  }


  Future<void> performPlay(Music music) async {
    assert(music != null);

    if (value.current ==music &&
          controller.value.playbackState !=PlaybackState.none) {

      return await controller.setPlayWhenReady(true);
    }
    
    assert(music.url !=null &&
            music.url.isNotEmpty, 'music url can not be null');
    return await controller.playWith(music);
  }

  Future<void> pause() {
    return controller.setPlayWhenReady(false);
  }

  void dispose_player() {
    controller.dispose();
  }

  Future<void> playNext() async {
    await controller.playNext();
  }

  Future<void> playPrevious() async {
    await controller.playPrevious();
  }

  Future<Music> getNext() {
    return controller.getNext();
  }

  Future<Music> getPrevious() {
    return controller.getPrevious();
  }

  Future<void> seekTo(int position) {
    return controller.seekTo(position);
  }

  Future<void> setVolume(double volume) {
    return controller.setVolume(volume);
  }

  Future<void> changePlayMode() {
    PlayMode next =PlayMode.values[(value.playMode.index + 1) % 3];
    return controller.setPlayMode(next);
  }

  
  @override
  PlayerControllerState get value => controller.value;

  @override
  void addListener(listener) {
    controller.addListener(listener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => controller.hasListeners;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    controller.notifyListeners();
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
    controller.removeListener(listener);
  }

  @override
  void set value(PlayerControllerState newValue) {
    // TODO: implement value
    throw 'Unsupported operation';
  }
  
}


class FluttetPlay extends StatefulWidget {
  final Widget child;

  FluttetPlay({Key key, @Required() this.child}) : super(key: key);

  _FluttetPlayState createState() => _FluttetPlayState();
}

class _FluttetPlayState extends State<FluttetPlay> {

  PlayerControllerState value;

  void onPlayerChange() {
    setState(() {
     value = flutterPlay.value; 
     if (value.hasError) {
       showSimpleNotification(
          context,Text('播放 ${value.current?.title ?? ''} 失败'),
          // icon:Icon(Icons.error),
          background: Theme.of(context).errorColor,
       );
     }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    value =flutterPlay.value;
    flutterPlay.addListener(onPlayerChange);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterPlay.removeListener(onPlayerChange);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: widget.child,
    );
  }
}

class PlayerState extends InheritedModel<PlayerStateAspect> {

  PlayerState({@required Widget child, @required this.value}) :super(child:child);

  final PlayerControllerState value;

  static PlayerState of(BuildContext context, {PlayerStateAspect aspect}) {
    return context.inheritFromWidgetOfExactType(PlayerState,aspect:aspect);
  }

  @override
  bool updateShouldNotify(PlayerState oldWidget) {
    // TODO: implement updateShouldNotify
    return value != oldWidget.value;
  }

  @override
  bool updateShouldNotifyDependent(
            PlayerState oldWidget, Set<PlayerStateAspect> dependencies) {

    // TODO: implement updateShouldNotifyDependent
    if (dependencies.contains(PlayerStateAspect.position) &&
          (value.position !=oldWidget.value.position)) {
      return true;
    }

    if (dependencies.contains(PlayerStateAspect.playBackState) &&
          ((value.playbackState !=oldWidget.value.playbackState) || 
          (value.playWhenReady !=oldWidget.value.playWhenReady ||
          value.hasError !=oldWidget.value.hasError))) {
      return true;
    }   

    if (dependencies.contains(PlayerStateAspect.playlist) && 
          (value.playingList !=oldWidget.value.playingList)) {
      return true;
    }       

    if (dependencies.contains(PlayerStateAspect.music) && 
          (value.current !=oldWidget.value.current)) {
      return true;
    }

    if (dependencies.contains(PlayerStateAspect.playMode) && 
          (value.playMode !=oldWidget.value.playMode)) {
      return true;
    }
   
   return false;
   
  }
  
}

enum PlayerStateAspect {
  position,

  playBackState,

  music,

  playlist,

  playMode,
}