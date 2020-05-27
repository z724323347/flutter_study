import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_book/public.dart';

import 'article_provider.dart';
import 'reader_utils.dart';
import 'reader_page_agent.dart';
import 'reader_config.dart';
import 'battery_view.dart';
import 'read_menu.dart';


class ReaderScene extends StatefulWidget {
  
  final int articleId;

  ReaderScene({this.articleId});

  _ReaderSceneState createState() => _ReaderSceneState();
}

class _ReaderSceneState extends State<ReaderScene> with RouteAware{

  int articleId;
  int pageIndex = 0;
  bool isMenuVisiable =false;
  Article article;
  PageController pageController =PageController(keepPage: false);
  bool isLoading =false;
  double topSafeHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    articleId =this.widget.articleId;
    setup();
    pageController.addListener((){
      var offset =pageController.offset;
      var contentWidth =Screen.width;

      if (offset < 0 && !isLoading && article.preArticleId > 0 ) {
        previousPage();
      }
      if (offset / contentWidth > article.pageCount -1 && !isLoading && article.preArticleId > 0) {
        nextPage();
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
  void didPop() {
    // TODO: implement didPop
    super.didPop();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  void setup() async {
     SystemChrome.setEnabledSystemUIOverlays([]);
    //  不延迟 ，android 获取topSafeHeight 是错的
    // await Future.delayed(const Duration(milliseconds: 100),(){});
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    topSafeHeight =Screen.topSafeHeight;
    var _article = await fetchArticle(widget.articleId);

    setState(() {
     article = _article; 
     print('article  --$article');
    });
  }

  Future<Article> fetchArticle(int articleId) async {
    var article = await ArticleProvider.fetchArticle(articleId);
    var contentHeight =Screen.height - topSafeHeight - ReaderUtils.topOffset 
                        - Screen.bottomSafeHeight - ReaderUtils.bottomOffset -20;
    var contentWidth =Screen.width -15 - 10;
    article.pageOffsets = ReaderPageAgent.getPageOffsets(article.content, contentHeight, contentWidth, ReaderConfig.instance.fontSize);

    return article;
  }

  onTap(Offset position) async {
    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
      setState(() {
       isMenuVisiable =true; 
      });
    }else if (xRate >= 0.66) {
      nextPage();
    }else {
      previousPage();
    }
     
  }

  onPageChanged(int index) {
    setState(() {
     pageIndex =index; 
    });
  }

  previousPage() async {
    if (pageIndex == 0 && article.preArticleId == 0) {
      ToastUtil.showCenter('已经在第一页');
      return;
    }

    isLoading =true;
    if (pageIndex == 0) {
      //上一章节
      Article preArticle =await fetchArticle(article.preArticleId);
      pageIndex =preArticle.pageCount - 1;
      pageController.jumpToPage(pageIndex);
      setState((){
        isLoading =false;
        article =preArticle;
      });
    }else {
      //上一页
      pageController.previousPage(duration: Duration(milliseconds: 250),curve: Curves.easeOut);
    }
  }

  nextPage() async {
    if (pageIndex >=article.pageCount - 1 && article.nextArticleId == 0) {
      ToastUtil.showCenter('已经是最后一页了');
      return;
    }

    isLoading =true;
    if (pageIndex >=article.pageCount - 1) {
      //下一章
      Article nextArticle =await fetchArticle(article.nextArticleId);
      pageIndex = 0;
      pageController.jumpToPage(pageIndex);
      setState(() {
       isLoading =false;
       article =nextArticle; 
      });
    }else {
      //下一页
      pageController.nextPage(duration: Duration(milliseconds: 250),curve: Curves.easeOut);
    }
  }

  Widget buildPage(BuildContext context, int index) {
    var content =article.stringAtPageIndex(index);
    return GestureDetector(
      onTapUp: (TapUpDetails details){
        onTap(details.globalPosition);
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.fromLTRB(15, topSafeHeight + ReaderUtils.topOffset, 10, Screen.bottomSafeHeight),
        child: Text.rich(
          TextSpan(children:[
            TextSpan(text:content, style:TextStyle(fontSize:fixedFontSize(ReaderConfig.instance.fontSize)))
          ]),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  } 

  buildOverlayer() {
    var format =DateFormat('HH:mm');
    var time =format.format(DateTime.now());

    return Container(
      padding: EdgeInsets.fromLTRB(15, 10 + topSafeHeight, 15, 10 + Screen.bottomSafeHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(article.title??'', style:TextStyle(fontSize:fixedFontSize(14),color:EColor.gray)),
          Expanded(child: Container()),
          Row(
            children: <Widget>[
              // 电池电量
              BatteryView(),
              SizedBox(width: 10),
              Text(time, style: TextStyle(fontSize: fixedFontSize(11),color: EColor.gray)),
              Expanded(child: Container()),
              Text('第${pageIndex + 1}页',style: TextStyle(fontSize: fixedFontSize(11),color: EColor.gray)),
            ],
          )
        ],
      ),
    );
  }

  buildContent() {
    if (article == null) {
      return Container(
        color: Colors.yellow,
      );
    }

    return Container(
      child: PageView.builder(
        physics: BouncingScrollPhysics(),
        controller: pageController,
        itemCount: article.pageCount,
        itemBuilder: buildPage,
        onPageChanged: onPageChanged,
      ),
    );


  }

  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }

    return ReaderMenu(onTap: (){
      setState(() {
       SystemChrome.setEnabledSystemUIOverlays([]);
       this.isMenuVisiable =false; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (article == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
      );
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildOverlayer(),
          buildContent(),
          buildMenu(),
        ],
      ),
    );
  }
}