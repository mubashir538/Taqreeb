import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class MyColors {
  static Color red = Color(0xffef233c);
  static Color white = Color(0xffedf2f4);
  static Color whiteDarker = Color(0xffd9d9d9);
  static Color dark = Color(0xff18191A);
  static Color darkLighter = Color(0xff242526);
  static Color yellow = Color(0xffffbe0b);
  static Color green = Color(0xff7ae582);
  static Color redonWhite = Color(0xffedf2f4);
  static Color yellowonDark = Color(0xffffbe0b);

  static void switchTheme() async {
    final theme = await MyStorage.getToken(MyTokens.theme) ?? "";
    if (theme == "Light") {
      await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);
      MyColors.white = Color(0xffedf2f4);
      MyColors.whiteDarker = Color(0xffd9d9d9);
      MyColors.dark = Color(0xff18191A);
      MyColors.darkLighter = Color(0xff242526);
      MyColors.yellowonDark = Color(0xffffbe0b);
    } else {
      await MyStorage.saveToken(MyTokens.light, MyTokens.theme);
      MyColors.dark = Color(0xffE0E1DD);
      MyColors.yellowonDark = Color(0xffef233c);
      MyColors.darkLighter = Color(0xffffffff);
      MyColors.white = Color(0xff18191A);
      MyColors.whiteDarker = Color(0xff242526);
    }
  }

  static void getTheme() async {
    final theme = await MyStorage.getToken(MyTokens.theme) ?? "";
    if (theme == MyTokens.light) {
      MyColors.dark = Color(0xffE0E1DD);
      MyColors.yellowonDark = Color(0xffef233c);
      MyColors.darkLighter = Color(0xffffffff);
      MyColors.white = Color(0xff18191A);
      MyColors.whiteDarker = Color(0xff242526);
    } else {
      MyColors.white = Color(0xffedf2f4);
      MyColors.whiteDarker = Color(0xffd9d9d9);
      MyColors.dark = Color(0xff18191A);
      MyColors.darkLighter = Color(0xff242526);
      MyColors.yellowonDark = Color(0xffffbe0b);
    }
  }
}
