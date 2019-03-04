import 'package:flutter/material.dart';

import '../part/part.dart';
import '../repository/netease.dart';
import '../part/part_music_list_provider.dart';

class SectionNewSong extends StatelessWidget {

  Music mapJsonToMusic(Map json) {
    Map<String,Object> song =json['song'];
    return mapJsonToMusic(song);
  }

  SectionNewSong() ;

  @override
  Widget build(BuildContext context) {
    return Loader(
      loadTask: () => neteaseRepository.personalizedNewSong(),
      resultVerify: neteaseRepository.responseVerify,
      builder: (context, result){
        List<Music> songs = (result['result'] as List)
                .cast<Map>()
                .map(mapJsonToMusic)
                .toList();
        final songTitleProvider =
              SongTitleProvider('playlist_main_newsong',songs); 
        List<Widget> widgets = [];
        if (songTitleProvider !=null) {
          for (var i = 0; i < songTitleProvider.musics.length; i++) {
            widgets.add(songTitleProvider.buildWidget(i,context));
          }
        }   
        return Column(
          children: widgets,
        );
      },
    );
  }
}

