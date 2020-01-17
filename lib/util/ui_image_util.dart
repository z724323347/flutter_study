import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show rootBundle;

class UiImageUtil {
  Future<ui.Image> rootBundleImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  Future<ui.Image> loadImage(var path, bool isUrl) async {
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
      // stream = Image.network(path,fit: BoxFit.fill,).image.resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle).resolve(ImageConfiguration.empty);
      // stream = Image.asset(path).image.resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(new ImageStreamListener(listener));
    }

    stream.addListener(new ImageStreamListener(listener));
    return completer.future;
  }
}
