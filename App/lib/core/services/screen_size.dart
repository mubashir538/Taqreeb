import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';

class Screen {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double max(BuildContext context) {
    return MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }
}
