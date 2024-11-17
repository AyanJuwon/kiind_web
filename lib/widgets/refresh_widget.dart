import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'; // Add this import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> keyRefresh;
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    Key? key,
    required this.keyRefresh,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Use a standard RefreshIndicator for web
      return buildAndroidList();
    } else {
      // Use platform-specific checks for mobile
      return Platform.isAndroid ? buildAndroidList() : buildIOSList();
    }
  }

  Widget buildAndroidList() => RefreshIndicator(
        key: widget.keyRefresh,
        onRefresh: widget.onRefresh,
        child: widget.child,
      );

  Widget buildIOSList() => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: widget.onRefresh),
          SliverToBoxAdapter(child: widget.child),
        ],
      );
}
