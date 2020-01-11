import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_book/widget/toast/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWebJs extends StatefulWidget {
  String remoteUrl = "https://www.jianshu.com";
  String localUrl = "html/login.html";
  String title = "";
  @override
  _TestWebJsState createState() => _TestWebJsState();
}

class _TestWebJsState extends State<TestWebJs> {
  WebViewController _webViewController;

  /// 加载本地 HTML 文件
  Future<String> _loadHtmlFile() async {
    return await rootBundle.loadString(widget.localUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _loadHtmlFile(),
        builder: (ctx, snapshot) {
          return WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: Uri.dataFromString(snapshot.data,
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                .toString(),
            javascriptChannels: [_toastJsChannel(context)].toSet(),
            onWebViewCreated: (WebViewController controller) {
              print("webview page: webview created...");
              _webViewController = controller;
              _webViewController.loadUrl(new Uri.dataFromString(snapshot.data,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString());
            },
            onPageFinished: (url) {
              print("webview page: load finished...url=$url");
              _getTitle();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          /// 调用 JS 的方法
          _webViewController.evaluateJavascript(
              "flutterCallJsMethod('Flutter -->  JS : message from Flutter!')");
        },
      ),
    );
  }

  // 创建 JavascriptChannel
  JavascriptChannel _toastJsChannel(BuildContext context) => JavascriptChannel(
      name: 'show_flutter_toast',
      onMessageReceived: (JavascriptMessage message) {
        print("get message from JS, message is: ${message.message}");
        AnimToast.toast(message.message);
      });

  /// 获取当前加载页面的 title
  _getTitle() async {
    String title = await _webViewController.getTitle();
    setState(() {
      widget.title = title;
    });
    print("title---$title");
  }
}
