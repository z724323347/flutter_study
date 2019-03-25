import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_book/public.dart';
import 'login_scene.dart';


class MeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var user =UserManager.currentUser;

    return GestureDetector(
      onTap: (){
        // Toast.show('个人信息');
        if (UserManager.instance.isLogin) {
          //已经登录， 点击查看个人信息
          print('已经登录， 点击查看个人信息');
          Toast.showCenter('已登录');
        }else {
          //未登录， 点击进入登陆页面
          print('未登录， 点击进入登陆页面');
          AppNavigator.pushLogin(context);
        }
      },
      child: Container(
        color: EColor.white,
        padding: EdgeInsets.fromLTRB(20, 30, 15, 15),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 40,
              backgroundImage: user?.avatarUrl != null ? CachedNetworkImageProvider(user.avatarUrl) :AssetImage('img/placeholder_avatar.png'),
            ),
            SizedBox(width: 25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user != null ? user.nickname : '登录',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  buildItems(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItems() {
    var user =UserManager.currentUser;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildItem(user != null ? user.wealth.toStringAsFixed(1) : '0.0', '余额'),
        buildItem(user != null ? user.coupon.toString() : '0', '书卷'),
        buildItem(user != null ? user.monthlyTicket.toString() : '0','月票'),
        Container(),
      ],
    );
  }

  Widget buildItem(String title, String subtitle) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style:TextStyle(fontSize:12, color:EColor.gray)
          )
        ],
      ),
    );
  }

}
