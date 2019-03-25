import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';
import 'me_header.dart';
import 'me_cell.dart';
import 'setting_scene.dart';

class MeScene extends StatefulWidget {
  _MeSceneState createState() => _MeSceneState();
}

class _MeSceneState extends State<MeScene> {

  Widget buildCells(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          MeCell(
            title: '钱包',
            iconName: 'img/me_wallet.png',
            onPressed: (){
              Toast.showCenter('钱包');
            },
          ),

          MeCell(
            title: '设置',
            iconName: 'img/me_setting.png',
            onPressed: () {
              AppNavigator.push(context, SettingScene());
            },
          ),

          MeCell(
            title: 'Github',
            iconName: 'img/me_feedback.png',
            onPressed: (){
              AppNavigator.pushWeb(context, 'https://github.com/z724323347/flutter_study', 'Github');
            },
          ),

          MeCell(
            title: '关于',
            iconName: 'img/me_buy.png',
            onPressed: (){
              Toast.show('about ');
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: Container(color: EColor.white),
        preferredSize: Size(Screen.width, 0),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            MeHeader(),
            SizedBox(height: 10),
            buildCells(context)
          ],
        ),
      ),
    );
  }
}