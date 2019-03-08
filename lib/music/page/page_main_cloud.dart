import 'package:flutter/material.dart';

import '../widget/view_item_navigator.dart';
import '../widget/view_section_playlist.dart';
import '../widget/view_section_newsong.dart';
import '../part/part_music_list_provider.dart';
import '../part/part.dart';
import 'package:flutter_book/public.dart';

class MainCloudPage extends StatefulWidget {

  MainCloudPage();

  _MainCloudPageState createState() => _MainCloudPageState();
}

class _MainCloudPageState extends State<MainCloudPage> 
    with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
       child: ListView(
         children: <Widget>[
           NavigationLine(),
           Header('推荐歌单', (){}),
           SectionPlaylist(),
           Header("最新音乐", () {}),
           SectionNewSong(),
         ],
       ),
       
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

///common header for section
class Header extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 8)),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.w800),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Header(this.text, this.onTap);
}


class NavigationLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ItemNavigator(Icons.radio, "私人FM", () {
            // notImplemented(context);
          }),
          ItemNavigator(Icons.today, "每日推荐", () {
            // Navigator.pushNamed(context, ROUTE_DAILY);
          }),
          ItemNavigator(Icons.surround_sound, "歌单", () {
            // Navigator.pushNamed(context, ROUTE_DAILY);
            Toast.showCenter('ItemNavigator(Icons.today, 歌单)');
          }),
          ItemNavigator(Icons.show_chart, "排行榜", () {
            // Navigator.pushNamed(context, ROUTE_LEADERBOARD);
          }),
        ],
      ),
    );
  }
}