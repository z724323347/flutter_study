import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_book/public.dart';

class NovelCoverImage extends StatelessWidget {

  final String imgUrl;
  final double width;
  final double height;
  NovelCoverImage(this.imgUrl, {this.width, this.height});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(
        // image: CachedNetworkImageProvider(imgUrl),
        '${imgUrl}',
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
      decoration: BoxDecoration(border: Border.all(color: EColor.paper)),
    );
  }
}