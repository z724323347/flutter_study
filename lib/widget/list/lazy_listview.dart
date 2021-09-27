// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// import 'dart:math' as math;

// class LazyListView extends ListView {
//   LazyListView({
//     Key? key,
//     Axis scrollDirection = Axis.vertical,
//     bool reverse = false,
//     ScrollController? controller,
//     bool? primary,
//     ScrollPhysics? physics,
//     bool shrinkWrap = false,
//     EdgeInsetsGeometry? padding,
//     this.itemExtent,
//     bool addAutomaticKeepAlives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     double? cacheExtent,
//     List<Widget> children = const <Widget>[],
//     int? semanticChildCount,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//   })  : childrenDelegate = SliverChildListDelegate(
//           children,
//           addAutomaticKeepAlives: addAutomaticKeepAlives,
//           addRepaintBoundaries: addRepaintBoundaries,
//           addSemanticIndexes: addSemanticIndexes,
//         ),
//         super(
//           key: key,
//           scrollDirection: scrollDirection,
//           reverse: reverse,
//           controller: controller,
//           primary: primary,
//           physics: physics,
//           shrinkWrap: shrinkWrap,
//           padding: padding,
//           cacheExtent: cacheExtent,
//           semanticChildCount: semanticChildCount ?? children.length,
//           dragStartBehavior: dragStartBehavior,
//           keyboardDismissBehavior: keyboardDismissBehavior,
//           restorationId: restorationId,
//           clipBehavior: clipBehavior,
//         );

//   /// If non-null, forces the children to have the given extent in the scroll
//   /// direction.
//   ///
//   /// Specifying an [itemExtent] is more efficient than letting the children
//   /// determine their own extent because the scrolling machinery can make use of
//   /// the foreknowledge of the children's extent to save work, for example when
//   /// the scroll position changes drastically.
//   final double? itemExtent;

//   /// A delegate that provides the children for the [ListView].
//   ///
//   /// The [ListView.custom] constructor lets you specify this delegate
//   /// explicitly. The [ListView] and [ListView.builder] constructors create a
//   /// [childrenDelegate] that wraps the given [List] and [IndexedWidgetBuilder],
//   /// respectively.
//   final SliverChildDelegate childrenDelegate;

//   LazyListView.builder({
//     Key? key,
//     Axis scrollDirection = Axis.vertical,
//     bool reverse = false,
//     ScrollController? controller,
//     bool? primary,
//     ScrollPhysics? physics,
//     bool shrinkWrap = false,
//     EdgeInsetsGeometry? padding,
//     this.itemExtent,
//     required IndexedWidgetBuilder itemBuilder,
//     int? itemCount,
//     bool addAutomaticKeepAlives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     double? cacheExtent,
//     int? semanticChildCount,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//   })  : assert(itemCount == null || itemCount >= 0),
//         assert(semanticChildCount == null || semanticChildCount <= itemCount!),
//         childrenDelegate = SliverChildBuilderDelegate(
//           itemBuilder,
//           childCount: itemCount,
//           addAutomaticKeepAlives: addAutomaticKeepAlives,
//           addRepaintBoundaries: addRepaintBoundaries,
//           addSemanticIndexes: addSemanticIndexes,
//         ),
//         super(
//           key: key,
//           scrollDirection: scrollDirection,
//           reverse: reverse,
//           controller: controller,
//           primary: primary,
//           physics: physics,
//           shrinkWrap: shrinkWrap,
//           padding: padding,
//           cacheExtent: cacheExtent,
//           semanticChildCount: semanticChildCount ?? itemCount,
//           dragStartBehavior: dragStartBehavior,
//           keyboardDismissBehavior: keyboardDismissBehavior,
//           restorationId: restorationId,
//           clipBehavior: clipBehavior,
//         );

//   LazyListView.separated({
//     Key? key,
//     Axis scrollDirection = Axis.vertical,
//     bool reverse = false,
//     ScrollController? controller,
//     bool? primary,
//     ScrollPhysics? physics,
//     bool shrinkWrap = false,
//     EdgeInsetsGeometry? padding,
//     required IndexedWidgetBuilder itemBuilder,
//     required IndexedWidgetBuilder separatorBuilder,
//     required int itemCount,
//     bool addAutomaticKeepAlives = true,
//     bool addRepaintBoundaries = true,
//     bool addSemanticIndexes = true,
//     double? cacheExtent,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//   })  : assert(itemBuilder != null),
//         assert(separatorBuilder != null),
//         assert(itemCount != null && itemCount >= 0),
//         itemExtent = null,
//         childrenDelegate = SliverChildBuilderDelegate(
//           (BuildContext context, int index) {
//             final int itemIndex = index ~/ 2;
//             final Widget widget;
//             if (index.isEven) {
//               widget = itemBuilder(context, itemIndex);
//             } else {
//               widget = separatorBuilder(context, itemIndex);
//               assert(() {
//                 if (widget == null) {
//                   throw FlutterError('separatorBuilder cannot return null.');
//                 }
//                 return true;
//               }());
//             }
//             return widget;
//           },
//           childCount: _computeActualChildCount(itemCount),
//           addAutomaticKeepAlives: addAutomaticKeepAlives,
//           addRepaintBoundaries: addRepaintBoundaries,
//           addSemanticIndexes: addSemanticIndexes,
//           semanticIndexCallback: (Widget _, int index) {
//             return index.isEven ? index ~/ 2 : null;
//           },
//         ),
//         super(
//           key: key,
//           scrollDirection: scrollDirection,
//           reverse: reverse,
//           controller: controller,
//           primary: primary,
//           physics: physics,
//           shrinkWrap: shrinkWrap,
//           padding: padding,
//           cacheExtent: cacheExtent,
//           semanticChildCount: itemCount,
//           dragStartBehavior: dragStartBehavior,
//           keyboardDismissBehavior: keyboardDismissBehavior,
//           restorationId: restorationId,
//           clipBehavior: clipBehavior,
//         );

//   LazyListView.custom({
//     Key? key,
//     Axis scrollDirection = Axis.vertical,
//     bool reverse = false,
//     ScrollController? controller,
//     bool? primary,
//     ScrollPhysics? physics,
//     bool shrinkWrap = false,
//     EdgeInsetsGeometry? padding,
//     this.itemExtent,
//     required this.childrenDelegate,
//     double? cacheExtent,
//     int? semanticChildCount,
//     DragStartBehavior dragStartBehavior = DragStartBehavior.start,
//     ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
//         ScrollViewKeyboardDismissBehavior.manual,
//     String? restorationId,
//     Clip clipBehavior = Clip.hardEdge,
//   })  : assert(childrenDelegate != null),
//         super(
//           key: key,
//           scrollDirection: scrollDirection,
//           reverse: reverse,
//           controller: controller,
//           primary: primary,
//           physics: physics,
//           shrinkWrap: shrinkWrap,
//           padding: padding,
//           cacheExtent: cacheExtent,
//           semanticChildCount: semanticChildCount,
//           dragStartBehavior: dragStartBehavior,
//           keyboardDismissBehavior: keyboardDismissBehavior,
//           restorationId: restorationId,
//           clipBehavior: clipBehavior,
//         );

//   // Helper method to compute the actual child count for the separated constructor.
//   static int _computeActualChildCount(int itemCount) {
//     return math.max(0, itemCount * 2 - 1);
//   }
// }
