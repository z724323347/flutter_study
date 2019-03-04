import 'package:flutter/material.dart';

class BoxWithBottomPlayerController extends StatelessWidget {
  
  final Widget child;

  BoxWithBottomPlayerController(this.child);

  @override
  Widget build(BuildContext context) {
    
    //hide bottom player controller when view inserts
    //bottom too height (such as typing with soft keyboard)
    bool hide = MediaQuery.of(context).viewInsets.bottom /
            MediaQuery.of(context).size.height >
        0.4;
    return Column(
      children: <Widget>[
        Expanded(child: child),
        hide ? Container() : BottomControllerBar(),
      ],
    );
  }
}

class BottomControllerBar extends StatelessWidget {
  final Widget child;

  BottomControllerBar({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('data'),
    );
  }
}