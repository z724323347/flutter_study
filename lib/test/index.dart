import 'package:flutter/material.dart';
import 'package:flutter_book/widget/toast/toast.dart';

class TestIndexPage extends StatefulWidget {
  @override
  _TestIndexPageState createState() => _TestIndexPageState();
}

class _TestIndexPageState extends State<TestIndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              AnimToast.toast('message',time: 1500, position: ToastPosition.center);
            },
            child: Text('AnimToast'),
          )
        ],
      ),
    );
  }
}
