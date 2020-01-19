import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_book/go/index.dart';
import 'package:flutter_book/util/sp_util.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  SpUtil.getInstance();
  runApp(IndexGo());
}