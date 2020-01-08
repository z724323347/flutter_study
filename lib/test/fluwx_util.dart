import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';

enum ShareType { SHAER_SESSION, SHAER_TIMELINE, SHAER_FAVORITE }

class FluwxUtil {
  static WeChatShareResponse response;
  static bool installWeChat;

  static WeChatScene getWeChatScene(ShareType type) {
    WeChatScene scene;
    if (type == ShareType.SHAER_SESSION) {
      scene = WeChatScene.SESSION;
    } else if (type == ShareType.SHAER_TIMELINE) {
      scene = WeChatScene.TIMELINE;
    } else if (type == ShareType.SHAER_FAVORITE) {
      scene = WeChatScene.FAVORITE;
    }
    print(scene);
    return scene;
  }

  static setupFluwx({String appid, String universalLink}) async {
    await fluwx.registerWxApi(
        appId: appid != null? appid : 'wxd930ea5d5a258f4f',
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: universalLink != null? universalLink : 'weixin');
    var result = await fluwx.isWeChatInstalled();
    installWeChat = result;
    print("is installed $result");
  }

  static Future<bool> checkInstall() async {
    bool r = await fluwx.isWeChatInstalled();
    installWeChat = r;
    return r;
  }

  static StreamSubscription<WeChatShareResponse> listen() {
    return fluwx.responseFromShare.listen((WeChatShareResponse v) {
      response = v;
    }, onError: (err) {});
  }

  static auth({String scope, String state}) {
    fluwx.sendWeChatAuth(
            scope: scope == null ? 'snsapi_userinfo' : scope,
            state: state == null ? 'wechat_sdk_demo_test' : state)
        .then((v) {
      print('_auth --- $v');
    });
  }

  static shareImage(String imagepath, String thumbnail,
      {String description, ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareImageModel(
            image: imagepath,
            thumbnail: thumbnail,
            transaction: imagepath,
            scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
            description: description != null ? description : "这是一张图"))
        .then((v) {
      print('_shareImage -- $v');
    });
  }

  static shareText(String text, {String transaction, ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareTextModel(
      text: text,
      transaction: transaction != null
          ? transaction
          : 'text  ${DateTime.now().millisecondsSinceEpoch}',
      scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
    ))
        .then((v) {
      print('_shareText -- $v');
    });
  }

  static pay(String payUrl) async {
    var http = HttpClient();
    http.badCertificateCallback = (cert, String host, int port) {
      return true;
    };
    var request = await http.getUrl(Uri.parse(payUrl));
    var response = await request.close();
    var data = await Utf8Decoder().bind(response).join();
    Map<String, dynamic> result = json.decode(data);
    print(result['appid']);
    print(result["timestamp"]);

    fluwx.payWithWeChat(
      appId: result['appid'].toString(),
      partnerId: result['partnerid'].toString(),
      prepayId: result['prepayid'].toString(),
      packageValue: result['package'].toString(),
      nonceStr: result['noncestr'].toString(),
      timeStamp: result['timestamp'],
      sign: result['sign'].toString(),
    )
        .then((_data) {
      print("_play -- $_data");
    });
  }
}
