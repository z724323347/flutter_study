import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';

class NovelDetailToolbar extends StatelessWidget {

  final Novel novel;
  NovelDetailToolbar(this.novel);

  read() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
      color: Colors.white,
      height: 50 + Screen.bottomSafeHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: (){
                ToastUtil.showCenter('添加操作，未处理');
              },
              child: Container(
                height: 40,
                child: Center(
                  child: Text(
                    '添加',
                    style:TextStyle(fontSize: 16,color: EColor.primary)
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                AppNavigator.pushReader(context, novel.firstArticleId);
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: EColor.primary,
                  borderRadius: BorderRadius.circular(5)
                  ),
                child: Center(
                  child: Text(
                    '开始阅读',
                    style:TextStyle(fontSize:16, color:Colors.white),
                  ),
                ),  
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                ToastUtil.showCenter('点击了下载， 未处理下载事件');
              },
              child: Center(
                child: Text(
                  '下载',
                  style:TextStyle(fontSize:16, color:EColor.primary)
                ),
              ),
            ),
            
          )
        ],
      ),
    );
  }
}