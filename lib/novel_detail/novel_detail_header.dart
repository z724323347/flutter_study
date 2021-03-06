import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;

import 'package:flutter_book/public.dart';

class NovelDetailHeader extends StatelessWidget {

  final Novel novel;
  NovelDetailHeader(this.novel);

  @override
  Widget build(BuildContext context) {
    
    var width =Screen.width;
    var height = 218.0 + Screen.topSafeHeight;

    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Image.network(
            // image: CachedNetworkImageProvider(novel.imgUrl),
            '${novel.imgUrl}',
            fit: BoxFit.fitWidth,
            width: width,
            height: height,
          ),
          Container(
            color: Color(0xbb000000),
            width: width,
            height: height,
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
            child: buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext content) {
    var width =Screen.width;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(15, 54 + Screen.topSafeHeight, 10, 0),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          NovelCoverImage(
            novel.imgUrl,
            width:100,
            height:133,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  novel.name,
                  style:TextStyle(fontSize:fixedFontSize(18), color:Colors.white, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 10),
                Text(
                  novel.author,
                  style: TextStyle(fontSize: fixedFontSize(14), color: EColor.white),
                ),
                SizedBox(height: 10),
                Text(
                  '${novel.wordCount}万字 ${novel.price}书豆/千字',
                  style: TextStyle(fontSize: fixedFontSize(14), color:EColor.white),
                ),
                SizedBox(height: 10),
                buildScore(),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('img/read_icon_vip.png'),
                    Expanded(
                      child: Text(
                        ' 续费包会员,万本小说免费阅读',
                        style:TextStyle(fontSize:fixedFontSize(14), color:Color(0xfffea900)),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildScore() {
    List<Widget> childern = [
      Text('评分:${novel.score}分 ', style: TextStyle(fontSize: fixedFontSize(14), color: Color(0xfff8e71c)))
      ];
    
    var star =novel.score;

    for (var i = 0; i < 5; i++) {
      if(star < i) {
        break;
      }
      var img;
      if (star <= i + 0.5) {
      }else {
        img =Image.asset('img/detail_star_half.png');
        img =Image.asset('img/detail_star.png');
      }
      childern.add(img);
      childern.add(SizedBox(width:5));
    }

    return Row(
      children: childern,
    );
  }
}