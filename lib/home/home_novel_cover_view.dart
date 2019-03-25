import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';

class HomeNovelCoverView extends StatelessWidget {

  final Novel novel;
  HomeNovelCoverView(this.novel);

  @override
  Widget build(BuildContext context) {
    var width = (Screen.width -15 * 2 - 15 * 3) / 4 ;

    return GestureDetector(
      onTap: (){
        AppNavigator.pushNovelDetail(context, novel);
      },
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NovelCoverImage(
              novel.imgUrl,
              width: width,
              height: width / 0.75,
            ),
            SizedBox(height: 5.0),
            Text(
              novel.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            SizedBox(height: 3.0),
            Text(
              novel.name,
              style:TextStyle(fontSize:12, color:EColor.gray),
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}