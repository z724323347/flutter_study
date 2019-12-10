import 'package:flutter/material.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_book/public.dart';
import '../page/page_playlist_detail_header.dart';
import '../repository/netease_image.dart';
import '../part/part.dart';

import 'package:flutter_book/public.dart';


class PlaylistDetailHeader extends StatelessWidget {
  final PlaylistDetail playlist;

  PlaylistDetailHeader(this.playlist) : assert(playlist != null);

  List<Music> get musicList => playlist.musicList;

  @override
  Widget build(BuildContext context) {

    Map<String, Object> creator =playlist.creator;

    return DetailHeader(
      commentCount: playlist.commentCount,
      shareCount: playlist.shareCount,
      onCommentTap: (){
        ToastUtil.showCenter('commet');
      },
      onSelectionTap: () async {
        if (musicList == null) {
          showSimpleNotification(Text('未添加,稍后再试'));
        }else {
          ToastUtil.showCenter('进入选择页面');
        }
      },
      onDownloadTap: musicList?.isEmpty ==true
            ? null
            :(){
              ToastUtil.showCenter('downloading');
      },
      onShareTap: () => ToastUtil.show('分享'),

      content: Container(
        height: 150,
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            SizedBox(width: 24),
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: playlist.heroTag,
                    child: Image(
                      fit: BoxFit.cover,
                      image: NeteaseImage(playlist.coverUrl)
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black54,
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent,
                        ]
                      )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.headset,
                          color: Theme.of(context).primaryIconTheme.color,
                          size: 12),
                        Text(
                          getFormattedNumber(playlist.playCount),
                          style: Theme.of(context).primaryTextTheme.body1.copyWith(fontSize: 11)
                        )  
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    playlist.name,
                    style:Theme.of(context).primaryTextTheme.title.copyWith(fontSize: 20),
                    maxLines:2,
                    overflow:TextOverflow.ellipsis
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => {ToastUtil.showCenter('功能未完成')},
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: ClipOval(
                              child: Image(
                                image: NeteaseImage(creator['avatarUrl']),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Text(
                            creator['nickname'],
                            style:Theme.of(context).primaryTextTheme.body1,
                          ),
                          Icon(
                            Icons.chevron_right,
                            color:Theme.of(context).primaryIconTheme.color
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }


}