package com.soit.flutter.player


/**
 *
 * PlayMode of MusicPlayer
 *
 * please ensure that this enum values index the same as Dart enum PlayMode
 *
 * @author summer
 */
enum class PlayMode {
    //单曲循环
    Single,
    //列表循环
    Sequence,
    //随机播放
    Shuffle;
}