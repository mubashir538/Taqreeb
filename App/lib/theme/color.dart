import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';

class MyColors {
  static Color red = Color(0xffef233c);
  static Color white = Color(0xffedf2f4);
  static Color whiteDarker = Color(0xffd9d9d9);
  static Color Dark = Color(0xff18191A);
  static Color DarkLighter = Color(0xff242526);
  static Color Yellow = Color(0xffffbe0b);
  static Color green = Color(0xff7ae582);
  static Color redonWhite = Color(0xffedf2f4);
  static Color yellowonDark = Color(0xffffbe0b);

  static void switchTheme() async {
    final theme = await MyStorage.getToken(MyTokens.theme) ?? "";
    if (theme == "Light") {
      await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);
      MyColors.white = Color(0xffedf2f4);
      MyColors.whiteDarker = Color(0xffd9d9d9);
      MyColors.Dark = Color(0xff18191A);
      MyColors.DarkLighter = Color(0xff242526);
      MyColors.yellowonDark = Color(0xffffbe0b);
    } else {
      await MyStorage.saveToken(MyTokens.Light, MyTokens.theme);
      MyColors.Dark = Color(0xffE0E1DD);
      MyColors.yellowonDark = Color(0xffef233c);
      MyColors.DarkLighter = Color(0xffffffff);
      MyColors.white = Color(0xff18191A);
      MyColors.whiteDarker = Color(0xff242526);
    }
  }

  static void getTheme() async {
    final theme = await MyStorage.getToken(MyTokens.theme) ?? "";
    if (theme == MyTokens.Light) {
      MyColors.Dark = Color(0xffE0E1DD);
      MyColors.yellowonDark = Color(0xffef233c);
      MyColors.DarkLighter = Color(0xffffffff);
      MyColors.white = Color(0xff18191A);
      MyColors.whiteDarker = Color(0xff242526);
    } else {
      MyColors.white = Color(0xffedf2f4);
      MyColors.whiteDarker = Color(0xffd9d9d9);
      MyColors.Dark = Color(0xff18191A);
      MyColors.DarkLighter = Color(0xff242526);
      MyColors.yellowonDark = Color(0xffffbe0b);
    }
  }
}
