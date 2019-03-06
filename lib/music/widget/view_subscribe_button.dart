import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_book/music/part/part_utils.dart';

class SubscribeButton extends StatefulWidget {
  final bool subscribed;

  final int subscribedCount;

  final Future<bool> Function(bool curentState) doSubscribeChanged;

  const SubscribeButton(
        this.subscribed, this.subscribedCount, this.doSubscribeChanged,
        {Key key}) 
        : super(key: key);

  _SubscribeButtonState createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<SubscribeButton> {

  bool subscribed =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscribed =widget.subscribed;
  }

  @override
  Widget build(BuildContext context) {
    if (!subscribed) {
      return Container(
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.5),
              Theme.of(context).primaryColor
            ]
          )
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final result =await widget.doSubscribeChanged(subscribed);
              setState(() {
               subscribed =result; 
              });
            },
            child: Row(
              children: <Widget>[
                SizedBox(width: 16),
                Icon(Icons.add,
                    color: Theme.of(context).primaryIconTheme.color),
                SizedBox(width: 4),
                Text(
                  '收藏(${getFormattedNumber(widget.subscribedCount)})',
                  style: Theme.of(context).primaryTextTheme.body1,
                ) ,
                SizedBox(width: 16),
              ],
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        child: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              SizedBox(width: 16),
              Icon(Icons.folder_special,
                size: 20, color: Theme.of(context).disabledColor),
              SizedBox(width: 4),
              Text(
                getFormattedNumber(widget.subscribedCount),
                style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
        onTap: () async {
          final result =await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('确定删除该歌单 ?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pop(context,true),
                    child: Text('不再收藏'),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }
}