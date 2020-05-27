import 'package:flutter/material.dart';
import 'package:flutter_book/widget/lyric/lyric.dart';
import 'package:flutter_book/widget/lyric/lyric_entry.dart';

class LyricPage extends StatefulWidget {
  @override
  _LyricPageState createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> {
  List<LyricEntry> lyricList = [];
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    var jsonStr =
        await DefaultAssetBundle.of(context).loadString('mock/lyric.txt');
    var list = jsonStr.split(RegExp('\n'));
    list.forEach((f) {
      if (f.isNotEmpty) {
        var r = f.split(RegExp(' '));
        if (r.length >= 2) {
          lyricList.add(LyricEntry(r[0], r[1]));
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'img/bookshelf_bg.png',
              fit: BoxFit.cover,
            ),
            // child: Image.network(
            //   'https://upload-images.jianshu.io/upload_images/3948891-af9f7beb7e186464.png?imageMogr2/auto-orient/strip|imageView2/2/w/1126/format/webp',
            //   fit: BoxFit.cover,
            // ),
          ),
          Positioned.fill(
              child: Lyric(
            lyricList,
            diameterRatio: 20,
            selectedTextStyle: TextStyle(color: Colors.white, fontSize: 18),
            unSelectedTextStyle: TextStyle(
              color: Colors.black.withOpacity(.6),
            ),
            itemExtent: 45,
          ))
        ],
      ),
    );
  }
}
