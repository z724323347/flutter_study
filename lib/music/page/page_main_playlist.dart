import 'package:flutter/material.dart';
import 'package:flutter_book/test/index.dart';

class MainPlaylistPage extends StatefulWidget {
  final Widget child;

  MainPlaylistPage({Key key, this.child}) : super(key: key);

  _MainPlaylistPageState createState() => _MainPlaylistPageState();
}

class _MainPlaylistPageState extends State<MainPlaylistPage> 
    with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
       child: TestIndexPage(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}