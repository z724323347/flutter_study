import 'package:flutter/material.dart';
import 'package:flutter_book/generated/l10n.dart';
import 'package:flutter_book/global/global.dart';
class I18nUtils {
  static BuildContext context = GlobalNavigator.navigatorKey.currentState.overlay.context;
  static S of() => S.of(context);
}