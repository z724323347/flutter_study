import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_book/model/music.dart';


const MethodChannel channel =MethodChannel('flutter.native/player');

PlayerController playerController =PlayerController._();


class DurationRange {
  DurationRange(this.start, this.end);
  final Duration start;
  final Duration end;

  double startFraction(Duration duration) {
    return start.inMilliseconds / duration.inMilliseconds;
  }

  double endFfraction(Duration duration) {
    return end.inMilliseconds / duration.inMilliseconds;
  }

  @override
  String toString() {
    // TODO: implement toString
    return '$runtimeType(start: $start, end: $end)';
  }

  static DurationRange from(dynamic value) {
    final List<dynamic> pair =value;
    return DurationRange(
      Duration(milliseconds: pair[0]),
      Duration(milliseconds: pair[1])
    );
  }
}

///play mode determine [PlayingList] how to play next song
enum PlayMode {
  ///aways play single song
  single,

  ///play current list sequence
  sequence,

  ///random to play next song
  shuffle
}

enum PlaybackState { none, buffering, ready, ended }



class PlayerController extends ValueNotifier<PlayerControllerState> {
  PlayerController._() : super(PlayerControllerState.uninitialized()){
    _init();
  }

  void _init() {
    channel.setMethodCallHandler((method){
      switch (method.method) {
        case 'onPlayerStateChanged':
          PlaybackState newState;
          bool playWhenReady =method.arguments['playWhenReady'];
          switch (method.arguments['playbackState']) {
            case 1:
              newState =PlaybackState.none;
              break;
            case 2:
              newState =PlaybackState.buffering;
              break;
            case 3:
              newState =PlaybackState.ready;
              break;   
            case 4:
              newState =PlaybackState.ended;
              break; 
          }
          value =value.copyWith(playbackState: newState,playWhenReady: playWhenReady)
                .clerError();
          
          break;

        case 'onPlayerError':
          value =value.copyWith(
            errorMsg: method.arguments['message'],
            playWhenReady: false,
            playbackState: PlaybackState.none
          );
          debugPrint('on player error : ${method.arguments}');
          break;

        case 'onMusicChanged':
          value=value.copyWith(current: Music.fromMap(method.arguments));
          break; 

        case 'onPlaylistUpdated':
          var map =method.arguments as Map;
          value =value.copyWith(
              playingList: (map['list'] as List).cast<Map>().map(Music.fromMap).toList(),
              token: map['token']
          );
          break; 

        case 'onPositionChanged':
          value =value.copyWith(
              position: Duration(milliseconds: method.arguments['position']),
              duration: Duration(milliseconds: method.arguments['duration'])
          );
          break;   

        case 'onPlayModeChanged':
          value =value.copyWith(playMode: PlayMode.values[method.arguments % 3]);
          break;     

      }
    });
  }

  Future<Music> getPrevious() async {
    return Music.fromMap(await channel.invokeMethod('getPrevious'));
  }

  Future<Music> getNext() async {
    return Music.fromMap(await channel.invokeMethod('getNext'));
  }

  Future<Music> playNext() {
    return channel.invokeMethod('playNext');
  }

  Future<Music> playPrevious() {
    return channel.invokeMethod('playPrevious');
  }
  
  Future<void> init(
    List<Music> list, Music music, String token, PlayMode playMode
  ){
    return channel.invokeMethod('init',{
      'list':list == null ? null :list.map((m) => m.toMap()).toList(),
      'music':music?.toMap(),
      'token':token,
      'playMode':playMode
    });
  }

  Future<void> setPlayWhenReady(bool playWhenReady) {
    return channel.invokeMethod('setPlayWhenReady',playWhenReady);
  }

  Future<void> playWith(Music music) {
    assert(music != null);
    return channel.invokeMethod('playWith',music.toMap());
  }

  Future<void> updatePlaylist(List<Music> musics,String token) {
    assert(musics != null && musics.isNotEmpty);
    assert(token != null);
    return channel.invokeMethod('updatePlaylist',{
      'list':musics.map((m) => m.toMap()).toList(),
      'token':token
    });
  }

  Future<void> setPlayMode(PlayMode playMode) {
    return channel.invokeMethod('setPlayMode',playMode.index);
  }

  Future<void> seekTo(int position) async {
    value =value.copyWith(position: Duration(milliseconds: position));
    await channel.invokeMethod('seekTo',position);
  }

  Future<void> setVolume(double volume) {
    return channel.invokeMethod('setVolume',volume);
  }

  Future<Duration> get position async {
    return Duration(milliseconds: await channel.invokeMethod('position'));
  }

  Future<void> dispose() {
    value =PlayerControllerState.uninitialized();
    return channel.invokeMethod('dispose');
  }
  
}

class PlayerControllerState {
  PlayerControllerState(
    {this.duration,
    this.position,
    this.playWhenReady =false,
    this.buffered = const [],
    this.playbackState =PlaybackState.none,
    this.current,
    this.playingList =const [],
    this.token,
    this.playMode =PlayMode.sequence,
    this.errorMsg =ERROR_NONE}
  );

  static const String ERROR_NONE = 'NONE';
  PlayerControllerState.uninitialized() :this(duration: null);

  final Duration duration;
  final Duration position;

  final List<DurationRange> buffered;
  final PlaybackState playbackState;
  final bool playWhenReady;
  
  bool get isBuffering => playbackState == PlaybackState.buffering && !hasError;
  final String errorMsg;
  final Music current;
  final List<Music> playingList;
  final String token;
  final PlayMode playMode;

  bool get hasError => errorMsg != ERROR_NONE;
  bool get initialized => duration != null;
  bool get isPlaying => 
        (playbackState ==PlaybackState.ready) && playWhenReady && !hasError;

  PlayerControllerState clerError() {
    if (!hasError) {
      return this;
    }
    return copyWith(errorMsg: ERROR_NONE);
  }

  PlayerControllerState copyWith(
    {Duration duration,
    Duration position,
    bool playWhenReady,
    String errorMsg,
    List<DurationRange> buffered,
    PlaybackState playbackState,
    Music current,
    List<Music> playingList,
    String token,
    PlayMode playMode,}
  ){
    return PlayerControllerState(
      duration: duration ?? this.duration,
      position: position ?? this.position,
      playWhenReady: playWhenReady ?? this.playWhenReady,
      errorMsg: errorMsg ?? this.errorMsg,
      buffered: buffered ?? this.buffered,
      playbackState: playbackState ?? this.playbackState,
      playingList: playingList ?? this.playingList,
      current: current ?? this.current,
      playMode: playMode ?? this.playMode,
      token: token ?? this.token
    );
  }

}


