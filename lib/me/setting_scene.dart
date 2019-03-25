import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';

class SettingScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Widget> children = [];

    if (UserManager.instance.isLogin) {
      children.add(GestureDetector(
        onTap: (){
          AppNavigator.pop(context);
          UserManager.instance.logout();
        },
        child: Container(
          height: 50,
          color: Colors.white,
          child: Center(
            child: Text(
              '退出登录',
              style:TextStyle(fontSize: 16, color: EColor.red)),
          ),
        ),
      ));
    } else {
      children.add(Container(
        height: 50,
        color: Colors.white,
        child: Center(
          child: Text('你还未登录'),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(title: Text('设置'), elevation: 1),
      body: Container(
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}