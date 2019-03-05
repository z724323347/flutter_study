import 'package:flutter/material.dart';

class OpacityTitle extends StatefulWidget {
  final ValueNotifier<double> appBarOpacity;
  final String name;
  final String defaultName;
  final List<Widget> actions;

  OpacityTitle(
      {@required this.name,
      @required this.appBarOpacity,
      @required this.defaultName,
      this.actions}) 
      : assert(defaultName !=null);

  _OpacityTitleState createState() => _OpacityTitleState();
}

class _OpacityTitleState extends State<OpacityTitle> {

  double appBarOpacityValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.appBarOpacity?.addListener(onAppBarOpacity);
  }

  void onAppBarOpacity() {
    setState(() {
     appBarOpacityValue =widget.appBarOpacity.value; 
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.appBarOpacity?.removeListener(onAppBarOpacity);
  }
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(appBarOpacityValue < 0.5
          ? widget.defaultName
          : (widget.name ?? widget.defaultName)),
      toolbarOpacity: 1,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(appBarOpacityValue),    
      actions: widget.actions,
    );
  }
}