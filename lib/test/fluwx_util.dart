import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';

///[ShareType.SESSION]会话
///[ShareType.TIMELINE]朋友圈
///[ShareType.FAVORITE]收藏
enum ShareType { 
  SHAER_SESSION,
  SHAER_TIMELINE,
  SHAER_FAVORITE }

///[LuanchMiniProgramType.RELEASE]正式版
///[LuanchMiniProgramType.TEST]测试版
///[LuanchMiniProgramType.PREVIEW]预览版
enum LuanchMiniProgramType { 
  RELEASE, 
  TEST, 
  PREVIEW }

class FluwxUtil {
  static WeChatShareResponse shareResponse;
  static WeChatAuthResponse authResponse;
  static WeChatPaymentResponse payResponse;
  static WeChatLaunchMiniProgramResponse launchResponse;
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

  static WXMiniProgramType getLuanchMiniProgramType(LuanchMiniProgramType type) {
    WXMiniProgramType programType;
    if (type == LuanchMiniProgramType.RELEASE) {
      programType = WXMiniProgramType.RELEASE;
    } else if (type == LuanchMiniProgramType.TEST) {
      programType = WXMiniProgramType.TEST;
    } else if (type == LuanchMiniProgramType.PREVIEW) {
      programType = WXMiniProgramType.PREVIEW;
    }
    print(programType);
    return programType;
  }

  static setupFluwx({String appid, String universalLink}) async {
    await fluwx.registerWxApi(
        appId: appid != null? appid : 'wx309c4316e1cab160', // wxd930ea5d5a258f4f
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

  static StreamSubscription<WeChatShareResponse> sharelisten() {
    return fluwx.responseFromShare.listen((WeChatShareResponse v) {
      shareResponse = v;
    }, onError: (err) {});
  }

  static StreamSubscription<WeChatAuthResponse> authlisten() {
    return fluwx.responseFromAuth.listen((WeChatAuthResponse v) {
      authResponse = v;
    }, onError: (err) {});
  }

  static StreamSubscription<WeChatPaymentResponse> paylisten() {
    return fluwx.responseFromPayment.listen((WeChatPaymentResponse v) {
      payResponse = v;
    }, onError: (err) {});
  }

  static StreamSubscription<WeChatLaunchMiniProgramResponse> launchlisten() {
    return fluwx.responseFromLaunchMiniProgram.listen((WeChatLaunchMiniProgramResponse v) {
      launchResponse = v;
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
      {String description,String transaction, ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareImageModel(
            image: imagepath,
            thumbnail: thumbnail,
            transaction: transaction != null
                ? transaction
                : 'image  ${DateTime.now().millisecondsSinceEpoch}',
            scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
            description: description != null ? description : "这是一张 Image"))
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
    )).then((v) {
      print('_shareText -- $v');
    });
  }

  static shareVideo(String videoUrl, String videoLowBandUrl,String title,
         {String thumbnail, String transaction, String description, ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareVideoModel(
      videoUrl: videoUrl,
      videoLowBandUrl: videoLowBandUrl != null ? videoLowBandUrl : "",
      transaction: transaction != null
          ? transaction
          : 'video  ${DateTime.now().millisecondsSinceEpoch}',
      thumbnail: thumbnail != null ? thumbnail : "thumbnail",
      description: description != null ? description : "这是一段 Video",
      title: title != null ? title : "",    
      scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
    )).then((v) {
      print('_shareVideo -- $v');
    });
  }

  static shareMusic(String musicUrl, String musicLowBandUrl,String title,
         {String thumbnail, String transaction, String description, ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareMusicModel(
      musicUrl: musicUrl,
      musicLowBandUrl: musicLowBandUrl != null ? musicLowBandUrl : "",
      transaction: transaction != null
          ? transaction
          : 'music  ${DateTime.now().millisecondsSinceEpoch}',
      thumbnail: thumbnail != null ? thumbnail : "thumbnail",
      description: description != null ? description : "这是一首 Music",
      title: title != null ? title : "",    
      scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
    )).then((v) {
      print('_shareMusic -- $v');
    });
  }

  static shareWebPage(String webUrl,String title,
         {String thumbnail, String transaction, String description,  ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareWebPageModel(
      webPage: webUrl,
      title: title != null ? title : "",    
      transaction: transaction != null
          ? transaction
          : 'webPage  ${DateTime.now().millisecondsSinceEpoch}',
      thumbnail: thumbnail != null ? thumbnail : "thumbnail",
      description: description != null ? description : "这是一个 WebPage",
      scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
    )).then((v) {
      print('_shareWebPage -- $v');
    });
  }

  static shareMiniProgram(String webPageUrl,String title,
         {String thumbnail, String userName ,String path , String transaction, String description, ShareType type}) {
    fluwx.shareToWeChat(fluwx.WeChatShareMiniProgramModel(
      webPageUrl: webPageUrl,
      userName: userName != null ? userName : "",
      title: title != null ? title : "",   
      path: path != null ? path : "", 
      transaction: transaction != null
          ? transaction
          : 'MiniProgram  ${DateTime.now().millisecondsSinceEpoch}',
      thumbnail: thumbnail != null ? thumbnail : "thumbnail",
      hdImagePath: thumbnail != null ? thumbnail : "thumbnail",
      description: description != null ? description : "这是一个 MiniProgram",
      scene: type == null ? WeChatScene.SESSION : getWeChatScene(type),
    )).then((v) {
      print('_shareMiniProgram -- $v');
    });
  }

  static launchMiniProgram(String userName,{String path, LuanchMiniProgramType programType}) {
    fluwx.launchWeChatMiniProgram(
      username: userName,
      path: path != null ? path : "",
      miniProgramType: programType == null ? WXMiniProgramType.RELEASE : getLuanchMiniProgramType(programType),
    ).then((v){
      print('_launchMiniProgram -- $v');
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
    ).then((_data) {
      print("_play -- $_data");
    });
  }


  /// 暂不需 实现该方法
  static autoDeduct() {
    fluwx.autoDeDuctWeChat(
        appId: '',
        mchId: "",
        planId:  "",
        contractCode:  "",
        requestSerial:  "",
        contractDisplayAccount:  "",
        notifyUrl:  "",
        version:  "",
        sign:  "",
        timestamp:  "",
        returnApp: '3');
  }


  /// 暂不需 实现该方法
  static subscribeMsg() {
    fluwx.subscribeWeChatMsg(
        appId: '',
        scene: 0,
        templateId: '',
        reserved: '');
  }

  /// 暂不需 实现该方法
  static authByQRCode() {
    fluwx.authWeChatByQRCode(
        appId: '',
        scope: '',
        nonceStr: '',
        timeStamp: '',
        signature: '');
  }
}
