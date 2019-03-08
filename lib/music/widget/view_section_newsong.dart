import 'package:flutter/material.dart';

import '../part/part.dart';
import '../repository/netease.dart';
import '../part/part_music_list_provider.dart';


// class SectionNewSong extends StatelessWidget {
//   Music _mapJsonToMusic(Map json) {
//     Map<String, Object> song = json["song"];
//     return mapJsonToMusic(song);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Loader<Map>(
//       loadTask: () => neteaseRepository.personalizedNewSong(),
//       resultVerify: neteaseRepository.responseVerify,
//       builder: (context, result) {
//         List<Music> songs = (result["result"] as List)
//             .cast<Map>()
//             .map(_mapJsonToMusic)
//             .toList();
//          print('songs : $songs');   
//         final songTitleProvider =
//             SongTitleProvider("playlist_main_newsong", songs);
//         List<Widget> widgets = [];
//         if (songTitleProvider != null) {
//           for (int i = 1; i <= songTitleProvider.musics.length; i++) {
//             widgets.add(songTitleProvider.buildWidget(i, context));
//           }
//           print('length :  {$songTitleProvider.musics.length}'  );
//         }
//         return Column(
//           children: widgets,
//         );
//       },
//     );
//   }
// }

class SectionNewSong extends StatelessWidget {
  Music _mapJsonToMusic(Map json) {
    Map<String, Object> song = json["song"];
    return mapJsonToMusic(song);
  }

  @override
  Widget build(BuildContext context) {
    return Loader<Map>(
      loadTask: () => neteaseRepository.personalizedNewSong(),
      // resultVerify: neteaseRepository.responseVerify,
      builder: (context, result) {
        List<Music> songs = (result["result"] as List)
            .cast<Map>()
            .map(_mapJsonToMusic)
            .toList();
        final songTileProvider =
            SongTitleProvider("playlist_main_newsong", songs);
        List<Widget> widgets = [];
        if (songTileProvider != null) {
          for (int i = 1; i <= songTileProvider.musics.length; i++) {
            widgets.add(songTileProvider.buildWidget(i, context));
          }
        }
        return Column(
          children: widgets,
        );
      },
    );
  }
}