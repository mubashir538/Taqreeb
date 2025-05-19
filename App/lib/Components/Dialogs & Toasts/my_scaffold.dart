import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';
import '../../core/services/screen_size.dart';

class MyScaffold {
  final String text;
  const MyScaffold({required this.text});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text,
          style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.015,
              color: MyColors.white,
              fontWeight: FontWeight.w500)),
      backgroundColor: MyColors.red.withAlpha(200),
    ));
  }
}

class Mycolors {}
