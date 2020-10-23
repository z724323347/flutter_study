import 'package:flutter/material.dart';
import 'package:flutter_book/app/app_navigator.dart';
import 'package:flutter_book/public.dart';
import 'package:flutter_book/test/drag_crad_page.dart';
import 'package:flutter_book/test/flip_card_page.dart';
import 'package:flutter_book/test/fluwx_util.dart';
import 'package:flutter_book/test/test_chart.dart';
import 'package:flutter_book/test/watch_clock_page.dart';
import 'package:flutter_book/test/web_view/web_plugin_test.dart';
import 'package:flutter_book/test/web_view/web_view_test.dart';
import 'package:flutter_book/test/wechat_page.dart';
import 'package:flutter_book/util/locale/i18n_utils.dart';
import 'package:flutter_book/util/push_util.dart';
import 'package:flutter_book/util/sp_util.dart';
import 'package:flutter_book/widget/toast/toast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import 'keyboard/keyboard_main.dart';
import 'lyric_page.dart';
import 'test_hooks.dart';
// import 'dart:html' as html;

class TestIndexPage extends StatefulWidget {
  @override
  _TestIndexPageState createState() => _TestIndexPageState();
}

class _TestIndexPageState extends State<TestIndexPage> {
  int notificationId = 111;
  @override
  void initState() {
    super.initState();
    initSP();
    _initFluwx();
  }

  _initFluwx() async {
    FluwxUtil.setupFluwx(
        appid: 'wx309c4316e1cab160', universalLink: 'https://zxcomplex.com/');
  }

  initSP() {
    print(SpUtil.getKeys());

    SpUtil.putString("go", 'goooooooo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, HooksExample());
            },
            child: Text('HooksExample'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              // AnimToast.toast(I18nUtils.of().message +'\n' + I18nUtils.of().appUpdateFoundNewVersion('1.0.0'),time: 1500, position: ToastPosition.center);
              print(SpUtil.getKeys());
              String s = SpUtil.getString('go');
              AnimToast.toast('AnimToast---' + s);
            },
            child: Text('AnimToast   '),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, FlipCardTestPage());
            },
            child: Text('/flip_card'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, DragCradTestPage());
            },
            child: Text('/DragCradTestPage'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, TestWebJs());
            },
            child: Text('TestWebJs'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, TestWebPluginThirdPartJs());
            },
            child: Text('TestWebPluginThirdPartJs'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, TestChartPage());
            },
            child: Text('TestChartPage'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, WatchClockPage());
            },
            child: Text('WatchClockPage'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, LyricPage());
            },
            child: Text('LyricPage'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, WechatPage());
            },
            child: Text('WeChat'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, KeyboardTestPage());
            },
            child: Text('KeyboardTest'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              // AppNavigator.push(context, WechatPage());
              //  html.window.history.pushState(null, 'h', '/');
              // JPushUtil().openSettings();
              // JPushUtil().isNotificationEnabled().then((value) {
              //   ToastUtil.showCenter('isNotificationEnabled  : ${value}');
              //   if (!value) {
              //     JPushUtil().openSettings();
              //   }
              // });
              JPushUtil().jpush.setAlias('1507bfd3f7744cef66b');
            },
            child: Text('JPushUtil().openSettings'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              // 三秒后出发本地推送
              var fireDate = DateTime.now().add(Duration(milliseconds: 500));
              notificationId = notificationId + 1;
              JPushUtil().sendLocalNotification(
                LocalNotification(
                    id: notificationId,
                    title: 'title',
                    buildId: 2,
                    content: '${fireDate.toString()}',
                    fireTime: fireDate,
                    subtitle: 'subtitle',
                    badge: 5,
                    extra: {"key": "${fireDate}"}),
              );
              JPushUtil().jpush.setBadge(4);
            },
            child: Text('JPushUtil().sendLocalNotification'),
          ),
        ],
      ),
    );
  }
}
