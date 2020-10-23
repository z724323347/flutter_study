import 'package:flutter/material.dart';

class PopupMenu extends StatefulWidget {
  @override
  State createState() => _PopupMenuState();
}

class _PopupMenuState extends State {
  Color bgColor = Colors.white;
  GlobalKey anchorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Column(children: [
        SizedBox(height: 50),
        GestureDetector(
          child: Container(
            // height: 200,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            child: Text(
              '最近一直在codeing，～～～',
              style: TextStyle(
                  backgroundColor: bgColor, height: 1.5, fontSize: 15),
              key: anchorKey,
            ),
          ),
          onLongPressStart: (detail) {
            bgColor = Colors.grey;
            setState(() {});
            _showMenu(context, detail);
          },
        )
      ]),
    );
  }

  PopupMenuButton _popMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => _getPopupMenu(context),
      onSelected: (value) {
        print('‘onSelected’');
        _selectValueChange(value);
      },
      onCanceled: () {
        print('‘onCanceled’');
        bgColor = Colors.white;
        setState(() {});
      },
    );
  }

  _selectValueChange(String value) {
    setState(() {});
  }

  _showMenu(BuildContext context, LongPressStartDetails detail) {
    RenderBox renderBox = anchorKey.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
    final RelativeRect position = RelativeRect.fromLTRB(
        detail.globalPosition.dx, //取点击位置坐弹出x坐标
        offset.dy, //取text高度做弹出y坐标（这样弹出就不会遮挡文本）
        detail.globalPosition.dx,
        offset.dy);
    var pop = _popMenu();
    showMenu(
      context: context,
      items: pop.itemBuilder(context),
      position: position, //弹出框位置
    ).then((newValue) {
      if (!mounted) return null;
      if (newValue == null) {
        if (pop.onCanceled != null) pop.onCanceled();
        return null;
      }
      if (pop.onSelected != null) pop.onSelected(newValue);
    });
  }

  _getPopupMenu(BuildContext context) {
    return <PopupMenuEntry>[
      PopupMenuItem(
        value: '‘复制’',
        child: Text('‘复制’'),
      ),
      PopupMenuItem(
        value: '‘收藏’',
        child: Text('‘收藏’'),
      ),
    ];
  }
}
