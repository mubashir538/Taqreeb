import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class MyScaffold {
  final String text;
  const MyScaffold({required this.text});

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
      BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double max = width > height ? width : height;

    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text,
          style: GoogleFonts.montserrat(
              fontSize: 14,
              color: MyColors.white,
              fontWeight: FontWeight.w500)),
      backgroundColor: MyColors.red.withAlpha(50),
    ));
  }
}

class Mycolors {}
