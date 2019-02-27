import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

import 'package:flutter_book/public.dart';

class WebScene extends StatefulWidget {

  final String url;
  final String title;

  WebScene({@required this.url,this.title});

  _WebSceneState createState() => _WebSceneState();
}

class _WebSceneState extends State<WebScene> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: this.widget.url,
      appBar: AppBar(
        title: Text(this.widget.title ?? 'EBook'),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Share.share(this.widget.url);
            },
            child: Image.asset('img/icon_menu_share.png'),
          ),
        ],
      ),
    );
  }
}

