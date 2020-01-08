import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_book/test/fluwx_util.dart';

import 'package:fluwx/fluwx.dart' as fluwx;

class ShareImagePage extends StatefulWidget {
  @override
  _ShareImagePageState createState() => _ShareImagePageState();
}

class _ShareImagePageState extends State<ShareImagePage> {
  fluwx.WeChatScene scene = fluwx.WeChatScene.SESSION;

  String imagepath = 'assets://img/logo/logo.png';
  String thumbnail = "assets://img/logo/logo.png";

  String _response = "no data";

  String _text = "share text from fluwx";

  String _payUrl = "https://wxpay.wxutil.com/pub_v2/app/app_pay.php";

  String _payResult = "无";
  StreamSubscription strem;
  @override
  void initState() {
    super.initState();
    // fluwx.responseFromShare.listen((data) {
    //   print('data  --- ${data.toString()}');
    //   setState(() {
    //     _response = 'errCode : ' + data.errCode.toString();
    //   });
    // });
    FluwxUtil.checkInstall();
    strem  =FluwxUtil.listen();
    strem.onData((v){
      setState(() {
        FluwxUtil.response = v;
      });
        print('errCode FluwxUtil : ' + FluwxUtil.response.errCode.toString());
    });
    print('FluwxUtil install--- ${FluwxUtil.installWeChat}');
     
  }
  @override
  void dispose() {
    super.dispose();
    strem?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('share'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share, color: Colors.blue),
            onPressed: (){
              FluwxUtil.shareImage(imagepath, thumbnail, description: '');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: Text(_response),
          ),
          Container(
            child: OutlineButton(
              onPressed: _auth,
              child: Row(
                children: <Widget>[
                  Icon(Icons.share, color: Colors.blue),
                  Text('WeChat Auth'),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[Text("响应结果 : "), Text(_response)],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: OutlineButton(
              onPressed:(){
                FluwxUtil.shareImage(imagepath, thumbnail, description: '',type: ShareType.SHAER_TIMELINE);
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.share, color: Colors.blue),
                  Text('share image'),
                ],
              ),
            ),
          ),
          Container(
            child: OutlineButton(
              onPressed: (){
                FluwxUtil.shareText('imagepath');
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.share, color: Colors.blue),
                  Text('share text'),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller:
                          TextEditingController(text: "share text from fluwx"),
                      onChanged: (str) {
                        _text = str;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: OutlineButton(
              onPressed: () async {
                _pay();
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.share, color: Colors.blue),
                  Text('wechat pay'),
                  SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[Text("响应结果 : "), Text(_payResult)],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _auth() {
    fluwx
        .sendWeChatAuth(scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test')
        .then((v) {
      print('_auth --- $v');
    });
  }

  void _shareImage() {
    fluwx.shareToWeChat(fluwx.WeChatShareImageModel(
        image: imagepath,
        thumbnail: thumbnail,
        transaction: imagepath,
        scene: scene,
        description: "这是一张图"));
  }

  void _shareText() {
    fluwx
        .shareToWeChat(fluwx.WeChatShareTextModel(
            text: _text,
            transaction: 'text  ${DateTime.now().millisecondsSinceEpoch}',
            scene: scene))
        .then((_d) {
      print('_shareText -- $_d');
    });
  }

  void _pay() async {
    var http = HttpClient();
    http.badCertificateCallback = (cert, String host, int port) {
      return true;
    };
    var request = await http.getUrl(Uri.parse(_payUrl));
    var response = await request.close();
    var data = await Utf8Decoder().bind(response).join();
    Map<String, dynamic> result = json.decode(data);
    print(result['appid']);
    print(result["timestamp"]);

    fluwx
        .payWithWeChat(
      appId: result['appid'].toString(),
      partnerId: result['partnerid'].toString(),
      prepayId: result['prepayid'].toString(),
      packageValue: result['package'].toString(),
      nonceStr: result['noncestr'].toString(),
      timeStamp: result['timestamp'],
      sign: result['sign'].toString(),
    )
        .then((_data) {
      print("play---》$_data");
    });
  }
}
