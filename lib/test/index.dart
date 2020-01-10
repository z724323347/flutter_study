import 'package:flutter/material.dart';
import 'package:flutter_book/app/app_navigator.dart';
import 'package:flutter_book/test/drag_crad_page.dart';
import 'package:flutter_book/test/flip_card_page.dart';
import 'package:flutter_book/test/fluwx_util.dart';
import 'package:flutter_book/test/wechat_page.dart';
import 'package:flutter_book/util/locale/i18n_utils.dart';
import 'package:flutter_book/widget/toast/toast.dart';

class TestIndexPage extends StatefulWidget {
  @override
  _TestIndexPageState createState() => _TestIndexPageState();
}

class _TestIndexPageState extends State<TestIndexPage> {

  @override
  void initState() {
    super.initState();
    _initFluwx();
  }
   _initFluwx() async {
    FluwxUtil.setupFluwx(appid: 'wx309c4316e1cab160',universalLink: 'https://zxcomplex.com/');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AnimToast.toast(I18nUtils.of().message +'\n' + I18nUtils.of().appUpdateFoundNewVersion('1.0.0'),time: 1500, position: ToastPosition.center);
            },
            child: Text('AnimToast   ' + I18nUtils.of().about + I18nUtils.of().appUpdateFoundNewVersion('1.0.0')),
          ),

           OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, FlipCardTestPage());
            },
            child: Text( '/flip_card'),
          ),
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, DragCradTestPage());
            },
            child: Text( '/DragCradTestPage'),
          ),
          
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AppNavigator.push(context, WechatPage());
            },
            child: Text('WeChat'),
          ),
        ],
      ),
    );
  }
}
