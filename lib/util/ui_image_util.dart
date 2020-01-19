import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 获取 ui.Image   utils 
class UiImageUtil {
  Future<ui.Image> rootBundleImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
  /// 废弃 fun @deprecated
  @deprecated
  Future<ui.Image> loadImage(var path, bool isUrl) async {
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
      // stream = Image.network(path,fit: BoxFit.fill,).image.resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle)
          .resolve(ImageConfiguration.empty);
      // stream = Image.asset(path).image.resolve(ImageConfiguration.empty);
      ByteData data = await rootBundle.load(path);
      stream = Image.memory(data.buffer.asUint8List()).image .resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(
          new ImageStreamListener(listener, onError: _loadFailed));
    }

    stream.addListener(new ImageStreamListener(listener, onError: _loadFailed));
    return completer.future;
  }

  _loadFailed(dynamic exception, StackTrace stackTrace) {
    print(" _loadFailed  \n $exception");
  }

  /// get ui.Image by Asset
  Future<ui.Image> loadImageAsset(String asset) async {
    ImageStream stream;
    stream = Image.asset(asset).image.resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(
          new ImageStreamListener(listener, onError: _loadFailed));
    }

    stream.addListener(new ImageStreamListener(listener, onError: _loadFailed));
    return completer.future;
  }
  /// get ui.Image by NetWork
  Future<ui.Image> loadImageNetWork(String url) async {
    ImageStream stream;
    stream = Image.network(url).image.resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(
          new ImageStreamListener(listener, onError: _loadFailed));
    }

    stream.addListener(new ImageStreamListener(listener, onError: _loadFailed));
    return completer.future;
  }
  /// get ui.Image by Memory
  Future<ui.Image> loadImageMemory(Uint8List bytes) async {
    ImageStream stream;
    // ByteData data = await rootBundle.load(path);
    // stream = Image.memory(data.buffer.asUint8List()).image .resolve(ImageConfiguration.empty);
    stream = Image.memory(bytes).image.resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(
          new ImageStreamListener(listener, onError: _loadFailed));
    }

    stream.addListener(new ImageStreamListener(listener, onError: _loadFailed));
    return completer.future;
  }
  /// get ui.Image by File
  Future<ui.Image> loadImageFile (File file) async {
    ImageStream stream;
    stream = Image.file(file).image .resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = Completer<ui.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(
          new ImageStreamListener(listener, onError: _loadFailed));
    }

    stream.addListener(new ImageStreamListener(listener, onError: _loadFailed));
    return completer.future;
  }
}
