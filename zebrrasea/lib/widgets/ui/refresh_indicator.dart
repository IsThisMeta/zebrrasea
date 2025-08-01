import 'package:flutter/material.dart';

class ZebrraRefreshIndicator extends RefreshIndicator {
  ZebrraRefreshIndicator({
    GlobalKey<RefreshIndicatorState>? key,
    required BuildContext context,
    required Future<void> Function() onRefresh,
    required Widget child,
  }) : super(
          key: key,
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).colorScheme.secondary,
          onRefresh: onRefresh,
          child: child,
        );
}
