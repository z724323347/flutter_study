import 'package:flutter/material.dart';

class ItemNavigator extends StatelessWidget {
  final IconData icon;

  final String text;

  final GestureTapCallback onTap;

  ItemNavigator(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                elevation: 5,
                child: ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Text(text),
            ],
          ),
        )
      );
  }
}