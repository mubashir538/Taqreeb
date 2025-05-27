import 'package:flutter/material.dart';

class AppColors {
  final BuildContext context;
  AppColors(this.context) {
    // Initialize all colors based on current theme
    _initializeColors();
  }

  late Color red;
  late Color white;
  late Color whiteDarker;
  late Color dark;
  late Color darkLighter;
  late Color lightDark;
  late Color yellow;
  late Color green;
  late Color redonWhite;
  late Color yellowonDark;

  void _initializeColors() {
    red = Theme.of(context).colorScheme.primary;
    white = Theme.of(context).colorScheme.onBackground;
    whiteDarker = Theme.of(context).colorScheme.onSurface;
    dark = Theme.of(context).scaffoldBackgroundColor;
    darkLighter = Theme.of(context).primaryColor;
    lightDark = Theme.of(context).colorScheme.surface;
    yellow = Theme.of(context).colorScheme.secondary;
    green = Color(0xff7ae582);
    redonWhite = Color(0xffedf2f4);
    yellowonDark = Theme.of(context).colorScheme.secondary;
  }
}
