import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TestWebPluginThirdPartJs extends StatefulWidget {
  String remoteUrl = "https://www.jianshu.com";
  String localUrl = "html/login.html";
  String title = "";
  @override
  _TestWebPluginThirdPartJsState createState() =>
      _TestWebPluginThirdPartJsState();
}

class _TestWebPluginThirdPartJsState extends State<TestWebPluginThirdPartJs> {
  FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  void initState() {
    widget.title = "WebviewPlugin 与 JS 交互";
    flutterWebviewPlugin = new FlutterWebviewPlugin();
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((state) {
      print('state:_' + state.type.toString());
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {});
      } else if (state.type == WebViewState.startLoad) {
        setState(() {});
      }
    });
  }

  /// 加载本地 HTML 文件
  Future<String> _loadHtmlFile() async {
    return await rootBundle.loadString(widget.localUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadHtmlFile(),
      builder: (ctx, snapshot) => WebviewScaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontSize: 14)),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              color: Colors.blue,
              width: 50,
              child: InkWell(
                child: Icon(Icons.add),
                onTap: () {
                  /// Flutter 调用 JS 的方法
                  flutterWebviewPlugin.evalJavascript(
                      "flutterCallJsMethod('Flutter -->  JS : message from Flutter!(flutter_webview_plugin)')");
                },
              ),
            )
          ],
        ),
        url: new Uri.dataFromString(snapshot.data,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString(),
        withJavascript: true,
      ),
    );
  }
}
