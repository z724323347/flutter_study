import 'package:flutter/material.dart';
import 'package:flutter_book/public.dart';
import 'package:flutter_book/test/fluwx_util.dart';
import 'package:flutter_book/test/shart_image_page.dart';
import 'package:flutter_book/widget/toast/toast.dart';

import 'package:fluwx/fluwx.dart' as fluwx;

class WechatPage extends StatefulWidget {
  @override
  _WechatPageState createState() => _WechatPageState();
}

class _WechatPageState extends State<WechatPage> {
  @override
  void initState() {
    super.initState();
    // _initFluwx();
  }

  _initFluwx() async {
    // await fluwx.registerWxApi(
    //     appId: 'wxd930ea5d5a258f4f',
    //     doOnAndroid: true,
    //     doOnIOS: true,
    //     universalLink: '');
    FluwxUtil.setupFluwx(appid: 'wx309c4316e1cab160',universalLink: 'https://zxcomplex.com/');
    // var result = await fluwx.isWeChatInstalled();
    // print("is installed $result");
    // setState(() {
    //   installWeChat = result;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WeChat'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: OutlineButton(
                  onPressed: () {
                    if (!FluwxUtil.installWeChat) return;
                    fluwx.openWeChatApp();
                  },
                  child: FluwxUtil.installWeChat
                      ? Text('Open WeChat App')
                      : Text('No install WeChat'),
                )),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text('----------------------------------------------'),
            ),
            OutlineButton(
              onPressed: () {
                if (!FluwxUtil.installWeChat) {
                  AnimToast.toast('No install WeChat');
                }else{
                  AppNavigator.push(context, ShareImagePage());
                }
                
              },
              child:Text('shareImage'),
            )
          ],
        ),
      ),
    );
  }
}
