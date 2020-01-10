import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_book/widget/dragcard/drag_card.dart';
import 'package:flutter_book/widget/toast/toast.dart';
import 'package:transparent_image/transparent_image.dart';

class DragCradTestPage extends StatefulWidget {
  @override
  _DragCradTestPageState createState() => _DragCradTestPageState();
}

class _DragCradTestPageState extends State<DragCradTestPage> {
  List<CardEntity> _cardList;

  List<ToolBarEntity> _toolbarList;

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('mock/daily_cards_data.json');
  }

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  void _loadJson() {
    _loadAsset().then((_json) {
      JsonDecoder jsonDecoder = new JsonDecoder();
      Map root = jsonDecoder.convert(_json);
      Map data = root['data'];
      List cards = data['cards'];
      if (cards == null) {
        return;
      }
      List<CardEntity> cardEntities = List();
      for (Map item in cards) {
        Map originalPost = item["originalPost"];
        if (originalPost != null) {
          String content = originalPost["content"];
          String picUrl;
          List pictures = originalPost["pictures"];
          if (pictures != null && pictures.length > 0) {
            Map pic = pictures[0];
            if (pic != null) {
              picUrl = pic["middlePicUrl"];
            }
          }
          if (content != null && picUrl != null) {
            cardEntities.add(CardEntity(picUrl, content));
          }
        }
      }

      List toolbarList = data["toolbarItems"];
      if (toolbarList == null) {
        return;
      }
      List<ToolBarEntity> toolbarEntities = List();
      for (Map item in toolbarList) {
        String url = item["url"];
        String picUrl = item["picUrl"];
        String title = item["title"];
        if (title != null && picUrl != null) {
          toolbarEntities.add(ToolBarEntity(picUrl, title, url));
        }
      }
      // List<CardEntity> temp;
      // temp.add(CardEntity('www', 'text'));
      setState(() {
        _cardList = cardEntities;
        _toolbarList = toolbarEntities;
        // _cardList = temp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DragCradTestPage'),
        centerTitle: true,
      ),
      body: Container(
        // height: 300,
        padding: EdgeInsets.only(bottom: 10),
        color: Colors.grey,
        child: PullDragWidget(
          dragHeight: 0.1,
          parallaxRatio: 0.4,
          thresholdRatio: 0.3,
          // header: _createHeader(),
          child: _createContent(),
        ),
      ),
    );
  }

  _onHeaderItemClick(ToolBarEntity item) {
    AnimToast.toast(item.title);
  }

  Widget _createHeader() {
    Widget header;

    if (_toolbarList == null || _toolbarList.length == 0) {
      header = Text("Loading...");
    } else {
      header = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _toolbarList.map<Widget>((item) {
            return Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _onHeaderItemClick(item);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipOval(
                          child: FadeInImage.memoryNetwork(
                              image: item.picUrl,
                              placeholder: kTransparentImage,
                              width: 62,
                              height: 62),
                        ),
                        Container(
                          height: 6,
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff333333),
                          ),
                        )
                      ],
                    )));
          }).toList());
    }

    return Container(
        padding: EdgeInsets.only(left: 10, right: 10), child: header);
  }

  Widget _createContent() {
    if (_cardList == null || _cardList.length == 0) {
      return Container(
        child: Text(
          "Loading...",
        ),
        alignment: Alignment.center,
      );
    } else {
      return CardStackWidget(
        cardList: _cardList,
        offset: 8,
        cardCount: 2,
      );
    }
  }
}
