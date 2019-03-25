class Music {

  Music({this.id, this.title, this.url, this.album, this.artist, this.mvId});
  int id;
  String title;
  String url;
  Album album;
  List<Artist> artist;
  int mvId; // 歌曲mv id 。当id=0 时 表示没有mv

  String get subTitle {
    var a1 = artist.map((a) => a.name).join('/');
    var a2 = album.name;
    return '$a1 - $a2';
  }

  @override
  bool operator == (Object obj) => 
    identical(this, obj) || obj is Music &&
      runtimeType ==obj.runtimeType &&
      id ==obj.id;
  
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  @override
  String toString() {
    // TODO: implement toString
    return 'Music {id: $id, title: $title, url: $url, album: $album, artist: $artist}';
  }

  static Music fromMap(Map map) {
    if (map ==null) {
      return null;
    }
    return Music(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      album: Album.fromMap(map['album']),
      mvId: map['mvid'] ?? 0,
      artist: (map['artist'] as List).cast<Map>().map(Artist.formMap).toList()
    );
  }

  Map toMap() {
    return{
      'id':id,
      'title':title,
      'url':url,
      'subTitle':subTitle,
      'mvId':mvId,
      'album':album.toMap(),
      'artist':artist.map((a) => a.toMap()).toList()
    };
  }

}

class Album {

  Album({this.coverImageUrl, this.name, this.id});
  
  String coverImageUrl;
  String name;
  int id;

  @override
  bool operator == (Object obj) => 
    identical(this, obj) || obj is Album &&
        runtimeType ==obj.runtimeType &&
        name == obj.name &&
        id ==obj.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  @override
  String toString() {
    // TODO: implement toString
    return 'Album{name :$name,id :$id}';
  }

  static Album fromMap(Map map) {
    return Album(
      id: map['id'],
      name: map['name'],
      coverImageUrl: map['coverImageUrl']
    );
  }

  Map toMap() {
    return {'id':id, 'name':name, 'coverImageUrl':coverImageUrl};
  }
}

class Artist {
  Artist({this.id, this.name, this.imageUrl});
  String name;
  int id;
  String imageUrl;

  @override
  String toString() {
    // TODO: implement toString
    return 'Artist {name: $name, id: $id, imageUrl: $imageUrl}';
  }

  static Artist formMap(Map map) {
    return Artist(
      id :map['id'],
      name :map['name']
      );
  }

  Map toMap() {
    return {'id':id, 'name':name};
  }
}
