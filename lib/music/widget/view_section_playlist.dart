import 'package:flutter/material.dart';

import '../part/loader.dart';
import '../repository/netease.dart';
import '../page/page_playlist_detail.dart';

import 'package:flutter_book/public.dart';

class SectionPlaylist extends StatelessWidget {

   @override
  Widget build(BuildContext context) {
    return Loader<Map>(
      loadTask: () => neteaseRepository.personalizedPlaylist(limit: 6),
      // resultVerify: neteaseRepository.responseVerify,
      builder: (context, result) {
        List<Map> list = (result["result"] as List).cast();
        return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 10 / 14,
          children: list.map<Widget>((p) {
            return _buildPlaylistItem(context, p);
          }).toList(),
        );
      },
    );
  }

  Widget _buildPlaylistItem(BuildContext context, Map playlist) {
    GestureLongPressCallback onLongPress;

    String copyWrite = playlist["copywriter"];
    if (copyWrite != null && copyWrite.isNotEmpty) {
      onLongPress = () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  playlist["copywriter"],
                  style: Theme.of(context).textTheme.body2,
                ),
              );
            });
      };
    }

    return InkWell(
      onTap: () {
        ToastUtil.showCenter('InkWell');
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          print('id = {$playlist}');
          return PlaylistDetailPage(
            playlist['id'],
          );
        }));

      },
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: AspectRatio(
                aspectRatio: 1,
                child: FadeInImage(
                  placeholder: AssetImage("img/playlist_playlist.9.png"),
                  image: NeteaseImage(playlist["picUrl"]),
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 2)),
            SingleChildScrollView(
              child: Text(
                playlist["name"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}