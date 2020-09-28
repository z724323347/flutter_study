import 'dart:convert';
import 'dart:io';

import 'package:flutter_book/public.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class JPushUtil {
  final JPush jpush = new JPush();

  /// push init
  Future<void> initJPush() async {
    jpush.setup(
        appKey: 'a3600525db613641003d139a',
        channel: 'developer-default',
        production: true);
    jpush.getRegistrationID().then((v) {
      print('jpush id : $v');

      ///保存RegistrationID
      if (v != null) {
        // jPushRegistrId.set(v);
        ToastUtil.showCenter('jpush id : $v');
      }
    });
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    if (Platform.isIOS) {
      jpush.setBadge(0);
    }
    try {
      jpush.addEventHandler(
        onOpenNotification: (Map<String, dynamic> message) {
          print('onOpenNotification --- $message');
          return _openHandler(message);
        },
        onReceiveMessage: (Map<String, dynamic> message) {
          print('onReceiveMessage --- $message');
          return null;
        },
        onReceiveNotification: (Map<String, dynamic> message) {
          print('onReceiveNotification --- $message');
          return null;
        },
      );
    } on Exception {}
    // if (!mounted) return;
  }

  /// 处理推送点击消息
  _openHandler(Map message) async {
    Map extras;
    // if (userStore.userInfo != null) {
    //   return;
    // }
    if (Platform.isIOS) {
      extras = message['extras']['url'];
    } else if (Platform.isAndroid) {
      extras = json.decode(message['extras']['cn.jpush.android.EXTRA']);
    }
    print('_openHandler. extras ---->>>  $extras');
    if (extras != null) {
      // AppRouter.pushByName('/' + url);
    }
  }

  /// 发本地推送
  Future<String> sendLocalNotification(LocalNotification notification) async {
    String r = await jpush.sendLocalNotification(notification);
    return r;
  }

  /// 检测通知授权状态是否打开
  Future<bool> isNotificationEnabled() async {
    return jpush.isNotificationEnabled();
  }

  /// 打开推送系统设置
  openSettings() {
    jpush.openSettingsForNotification();
  }

  /// stop Push
  stop() {
    jpush.stopPush();
  }

  /// resume Push
  resume() {
    jpush.resumePush();
  }

  
}
