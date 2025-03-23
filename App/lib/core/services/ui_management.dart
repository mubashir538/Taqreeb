import 'package:flutter/material.dart';

class UI_Management {
  static double headerHeight = 0.0;

  static void getHeaderHeight(
      {required Function(RenderBox renderbox) callback,
      required GlobalKey headerKey}) {
    if (headerKey.currentContext != null && headerKey.currentContext!.mounted) {
      final RenderObject? renderBox =
          headerKey.currentContext?.findRenderObject();
      if (renderBox is RenderBox) {
        callback(renderBox);
      }
    }
  }
}
