import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import '../part/part.dart';
import 'package:flutter_book/model/music.dart';

typedef MusicDeletionCallback = Future<bool> Function(List<Music> selected);

class PlaylistSelectionPage extends StatefulWidget {
  final List<Music> list;
  final MusicDeletionCallback onDelete;

  PlaylistSelectionPage(@required this.list, this.onDelete);

  _PlaylistSelectionPageState createState() => _PlaylistSelectionPageState();
}

class _PlaylistSelectionPageState extends State<PlaylistSelectionPage> {

  bool allSelected =false;
  GlobalKey<ScaffoldState> scaffoldKey =GlobalKey();
  final List<Music> selectedList = [];
  final ScrollController controller =ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: BackButton(),
        title: Text('已选择${selectedList.length}首'),
      ),
    );
  }
}
