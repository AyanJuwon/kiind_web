import 'dart:developer';

import 'package:flutter/material.dart';

extension ThemeUtils on BuildContext {
  ThemeData get theme => Theme.of(this);

  Color get pryColor => theme.primaryColor;
  Color get scaffoldBg => theme.scaffoldBackgroundColor;
  Brightness get brightness => theme.brightness;
}

extension Dimension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get width => size.width;
  double get height => size.height;

  double get topPadding => mediaQuery.padding.top;

  double w(double value) => (value / 100) * width;
  double h(double value) => (value / 100) * height;
}

extension Navigation on BuildContext {
  Map get args =>
      Map.from((ModalRoute.of(this)?.settings.arguments ?? {}) as Map);

  String? get route => ModalRoute.of(this)?.settings.name;

  Future<T?> to<T extends Object?>(
    String routeName, {
    Object? args,
    bool persistArgs = false,
  }) {
    log('route: $routeName');
    return Navigator.of(this).pushNamed(
      routeName,
      arguments: args ?? (persistArgs ? this.args : null),
    );
  }

  back<T extends Object?>({int times = 1, T? result}) {
    for (var i = 0; i < times; i++) {
      if (i == times - 1) {
        return Navigator.of(this).pop([result]);
      } else {
        Navigator.of(this).pop();
      }
    }
  }

  backUntil(bool Function(Route<dynamic>) predicate) {
    return Navigator.of(this).popUntil((route) => false);
  }

  Future<T?> off<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? res,
    Object? args,
    int popCount = 1,
    bool persistArgs = false,
  }) {
    if (popCount > 1) back(times: popCount - 1);
    return Navigator.of(this).pushReplacementNamed(
      routeName,
      result: res,
      arguments: args ?? (persistArgs ? this.args : null),
    );
  }

  Future<T?> offAll<T extends Object?>(
    String newRouteName, {
    bool Function(Route<dynamic>)? predicate,
    Object? args,
    bool persistArgs = false,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      newRouteName,
      predicate ?? (_) => false,
      arguments: args ?? (persistArgs ? this.args : null),
    );
  }
}

extension Decorations on BuildContext {
  BoxDecoration get cardDecoration => BoxDecoration(
        color: Theme.of(this).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      );
}
