import 'package:flutter/material.dart';

import 'package:flutter_book/public.dart';

class BookshelfCloudView extends AnimatedWidget {

  final double width;

  BookshelfCloudView({Animation<double> animation, this.width}) :super(listenable:animation);

  @override
  Widget build(BuildContext context) {

    var width =Screen.width;
    final Animation<double> animation =listenable;

    // TODO: implement build
    return Container(
      width: width,
      height: width * 2,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          Positioned(
            bottom: -30,
            child: Image.asset(
              'img/bookshelf_cloud_0.png',
              fit:BoxFit.cover,
              width:width
            ),
          ),
          Positioned(
            bottom: animation.value * -5,
            child: Opacity(
              opacity: animation.value,
              child: Image.asset(
                'img/bookshelf_cloud_1.png',
                fit:BoxFit.cover,
                width:width
              ),
            ),
          ),
          Positioned(
            bottom: (1 - animation.value) * -10,
            child: Opacity(
              opacity: animation.value,
              child: Image.asset(
                'img/bookshelf_cloud_2.png',
                fit:BoxFit.cover,
                width:width,
              ),
            ),
          ),
          Positioned(
            bottom: (animation.value - 0.5).abs() * -15,
            child: Opacity(
              opacity: (1 - animation.value),
              child: Image.asset(
                'img/bookshelf_cloud_3.png',
                fit:BoxFit.cover,
                width:width
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}