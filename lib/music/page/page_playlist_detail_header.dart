import 'package:flutter/material.dart';

// import 'package:flutter_book/public.dart';


class DetailHeader extends StatelessWidget {
  final Widget content;
  final GestureTapCallback onCommentTap;
  final GestureTapCallback onShareTap;
  final GestureTapCallback onDownloadTap;
  final GestureTapCallback onSelectionTap;
  final int commentCount;
  final int shareCount;

  DetailHeader(
    {Key key,
    @required this.content,
    this.onCommentTap,
    this.onShareTap,
    this.onDownloadTap,
    this.onSelectionTap,
    int commentCount = 0,
    int shareCount = 0}) 
    :this.commentCount =commentCount ?? 0,
     this.shareCount =shareCount ?? 0,
     super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color =Theme.of(context).primaryColorDark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            color,color.withOpacity(0.8),color.withOpacity(0.5)
          ],
          begin: Alignment.topLeft)
      ),
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kTextTabBarHeight
          ),
          child: Column(
            children: <Widget>[
              content,
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    HeaderAction(
                      Icons.comment,
                      commentCount > 0 ? commentCount.toString(): '评论',
                      onCommentTap
                    ),
                    HeaderAction(
                      Icons.share,
                      shareCount > 0 ? shareCount.toString(): '分享',
                      onShareTap
                    ),
                    HeaderAction(Icons.file_download,'下载',onDownloadTap),
                    HeaderAction(Icons.check_box,'选择',onSelectionTap)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderAction extends StatelessWidget {
  final IconData icon;
  final String action;
  final GestureTapCallback onTap;

  HeaderAction(this.icon, this.action, this.onTap);

  @override
  Widget build(BuildContext context) {

    var textTheme =Theme.of(context).primaryTextTheme;
    return InkResponse(
      onTap: onTap,
      splashColor: textTheme.body1.color,
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: textTheme.body1.color,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 2),
          ),
          Text(
            action,
            style:textTheme.caption
          )
        ],
      ),
    );

  }
}