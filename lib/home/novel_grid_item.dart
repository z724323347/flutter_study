import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';

class NovelGridItem extends StatelessWidget {

  final Novel novel;
  NovelGridItem(this.novel);

  @override
  Widget build(BuildContext context) {

    var width = (Screen.width - 15 * 2 -15) / 2;
    return GestureDetector(
      onTap: (){
        print('NovelGridItem');
        AppNavigator.pushNovelDetail(context, novel);
      },
      child: Container(
        width: width,
        child: Row(
          children: <Widget>[
            NovelCoverImage(
              novel.imgUrl,
              width: 50.0,
              height: 66.0,
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    novel.name,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14,height: 0.9,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    novel.recommendCountStr(),
                    style:TextStyle(fontSize:12, color:EColor.gray)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}