import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_book/public.dart';

import 'novel_detail_header.dart';
import 'novel_summary_view.dart';
import 'novel_detail_toolbar.dart';
import 'novel_detail_recommend_view.dart';
import 'novel_detail_cell.dart';
import 'novel_comment_cell.dart';

class NovelDetailScene extends StatefulWidget {

  final String novelId;
  NovelDetailScene(this.novelId);

  _NovelDetailSceneState createState() => _NovelDetailSceneState();
}

class _NovelDetailSceneState extends State<NovelDetailScene> with RouteAware{

  Novel novel;
  List<Novel> recommendNovels = [];
  List<NovelComment> comments = [];
  ScrollController scrollController =ScrollController();
  double navAlpha = 0;
  bool isSummaryUnfold =false;
  int commentCount = 0;
  int commentMemberCount = 0;

  bool isVisible =true;

  void initState() { 
    super.initState();
    fetchData();

    scrollController.addListener((){
      var offset =scrollController.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 1;
          });
        }
      } else if (offset < 50) {
        setState(() {
          navAlpha = 1- (50 - offset) / 50 ; 
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1; 
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    // TODO: implement didPop
    // 间隔执行，再设置状态栏样式，否则设置无效
    Timer(Duration(milliseconds:500), (){
      updateStatusBar();
    });
  }

  @override
  void didPopNext() {
    // TODO: implement didPopNext
    isVisible =true;
    updateStatusBar();
    super.didPopNext();
  }

  @override
  void didPop() {
    // TODO: implement didPop
    isVisible =false;
    super.didPop();
  }

  @override
  void didPushNext() {
    // TODO: implement didPushNext
    isVisible =false;
    super.didPushNext();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    routeObserver.unsubscribe(this);
    scrollController.dispose();
    super.dispose();
  }

  changSummaryMaxLines() {
    setState(() {
     isSummaryUnfold = !isSummaryUnfold; 
    });
  }

  back() {
    Navigator.pop(context);
  }

  fetchData() async {
    try {
      var novelId =this.widget.novelId;

      var novelResponse =await Request.post(action: 'novel_detail',params: {'id':novelId});

      var commentsResponse =await Request.post(action: 'novel_comment',params: {'id': novelId});
      List<NovelComment> comments = [];
      commentsResponse.forEach((data){
        comments.add(NovelComment.fromJson(data));
      });

      var recommendResponse =await Request.post(action: 'novel_recommend',params: {'id':novelId});
      List<Novel> recommendNovels = [];
      recommendResponse.forEach((data){
        recommendNovels.add(Novel.fromJson(data));
      });

      setState(() {
       this.novel =Novel.fromJson(novelResponse);
       this.comments = comments;
       this.recommendNovels =recommendNovels; 
      });

    } catch (e) {
      ToastUtil.showCenter(e.toString());
    }
  }

  updateStatusBar() {
    if (navAlpha == 1) {
      Screen.updateStatusBarStyle(SystemUiOverlayStyle.dark);
    } else {
      Screen.updateStatusBarStyle(SystemUiOverlayStyle.light);
    }
  }


  Widget buildNavigationBar() {
    return Stack(
      children: <Widget>[
        Container(
          width: 44,
          margin: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
          child: GestureDetector(
            onTap: back,
            child: Image.asset('img/pub_back_white.png'),
          ),
        ),
        Opacity(
          opacity: navAlpha,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            height: Screen.navigationBarHeight,
            color: EColor.white,
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  child: GestureDetector(
                    onTap: back,
                    child: Image.asset('img/pub_back_gray.png'),
                  ),
                ),
                Expanded(
                  child: Text(
                    novel.name,
                    style:TextStyle(fontSize:17, fontWeight:FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(width: 44),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildComment() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: <Widget>[
                Image.asset('img/home_tip.png'),
                SizedBox(width: 13),
                Text('本书评价',style:TextStyle(fontSize:16)),
                Expanded(child: Container()),
                Image.asset('img/detail_write_comment.png'),
                Text('  写书评',style:TextStyle(fontSize:14, color:EColor.primary)),
                SizedBox(width: 15),
              ],
            ),
          ),
          Divider(height: 1),
          Column(
            children: comments.map((comment) => NovelCommentCell(comment)).toList(),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Text(
                '查看全部书评(${novel.commentCount}条)',
                style: TextStyle(fontSize: 14, color: EColor.gray)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTags() {
    var colors = [Color(0xFFF9A19F),Color(0xFF59DDB9),Color(0xFF7EB3E7)];
    var i =0;
    var tagWidgets = novel.tags.map((tag){
      var color = colors[i % 3];
      var tagWidget =Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(99, color.red, color.green, color.blue),width: 0.5),
          borderRadius: BorderRadius.circular(3),
        ),
        padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
        child: Text(tag, style:TextStyle(fontSize:14, color:colors[i % 3])),
      );
      i++ ;
      return tagWidget;
    }).toList();

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      color: EColor.white,
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: tagWidgets,
      ),
    );

  }


  @override
  Widget build(BuildContext context) {

    if (isVisible) {
      updateStatusBar();
    }

    if (this.novel == null) {
      return Scaffold(appBar: AppBar(elevation: 1));
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 0),
                  children: <Widget>[
                    NovelDetailHeader(novel),
                    NovelSummaryView(novel.introduction, isSummaryUnfold, changSummaryMaxLines()),
                    //content
                    NovelDteailCell(
                      iconName: 'img/detail_latest.png',
                      title: '最新',
                      subtitle: novel.lastChapter.name,
                      attachedWidget: Text(
                        novel.status,
                        style:TextStyle(fontSize:14, color:EColor.gray),
                      ),
                    ),
                    NovelDteailCell(
                      iconName: 'img/detail_chapter.png',
                      title: '目录',
                      subtitle: '共${novel.chapterCount}章',
                    ),

                    buildTags(),
                    SizedBox(height: 20),
                    buildComment(),
                    SizedBox(height: 20),
                    NoverDetailRecommendView(recommendNovels),

                  ],
                ),
              ),
              NovelDetailToolbar(novel),
            ],
          ),
          buildNavigationBar(),
        ],
      ),
    );
  }
}