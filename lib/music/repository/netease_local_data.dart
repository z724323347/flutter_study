
import 'package:flutter/foundation.dart';
import 'database.dart';
import 'package:sembast/sembast.dart';

import '../part/part.dart';


NeteaseLocalData neteaseLocalData = NeteaseLocalData._();

class NeteaseLocalData {
  ///netData 类型必须是可以放入 [store] 中的类型
  static Stream<T> withData<T>(String key, Future<T> netData,
      {void onNetError(dynamic e)}) async* {
    final data = neteaseLocalData[key];
    if (data != null) {
      final cached = await data;
      if (cached != null) {
        assert(cached is T, "local espect be $T, but is $cached");
        yield cached;
      }
    }
    try {
      final net = await netData;
      neteaseLocalData[key] = net;
      yield net;
    } catch (e) {
      if (onNetError != null) onNetError("$e");
      debugPrint(e);
    }
  }

  NeteaseLocalData._();

  Store _store;

  Future<Store> get store async {
    if (_store != null) {
      return _store;
    }
    final db = await getApplicationDatabase();
    _store = db.getStore("netease");
    return _store;
  }

  Future operator [](key) async {
    return _get(key);
  }

  void operator []=(key, value) {
    _put(value, key);
  }

  Future _get(dynamic key) async {
    return (await store).get(key);
  }

  Future _put(dynamic value, [dynamic key]) async {
    return (await store).put(value, key);
  }

  Future<List<PlaylistDetail>> getUserPlaylist(int userId) async {
    final data = await _get("user_playlist_$userId");
    if (data == null) {
      return null;
    }
    final result = (data as List)
        .cast<Map>()
        .map((m) => PlaylistDetail.fromMap(m))
        .toList();
    return result;
  }

  void updateUserPlaylist(int userId, List<PlaylistDetail> list) {
    _put(list.map((p) => p.toMap()).toList(), "user_playlist_$userId");
  }

  Future<PlaylistDetail> getPlaylistDetail(int playlistId) async {
    final data = await _get("playlist_detail_$playlistId");
    return PlaylistDetail.fromMap(data);
  }

  Future updatePlaylistDetail(PlaylistDetail playlistDetail) {
    assert(playlistDetail.loaded);
    return _put(playlistDetail.toMap(), 'playlist_detail_${playlistDetail.id}');
  }
}
