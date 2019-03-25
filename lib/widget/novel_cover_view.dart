import 'package:flutter/material.dart';

import 'package:flutter_book/model/novel.dart';
import 'novel_cover_image.dart';
import 'package:flutter_book/app/app_navigator.dart';

class NovelCoverView extends StatelessWidget {

  final Novel novel;
  NovelCoverView(this.novel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('GestureDetector');
      },
      child: Container(
        width: 90.0,
        margin: EdgeInsets.symmetric(horizontal: 7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NovelCoverImage(
              novel.imgUrl,
              width: 90.0,
              height: 120.0,
            ),
            SizedBox(height: 10.0),
            Text(novel.name, style:TextStyle(fontSize: 12, fontWeight:FontWeight.bold),maxLines: 2,)
          ],
        ),
      ),
    );
  }
}
