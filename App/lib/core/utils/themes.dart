import 'package:flutter/material.dart';
import 'package:taqreeb/core/utils/color.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: MyColors.red,
    scaffoldBackgroundColor: MyColors.white,
    colorScheme: ColorScheme.light(
      primary: MyColors.red,
      secondary: MyColors.yellow,
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(color: MyColors.dark),
      displaySmall: TextStyle(color: MyColors.darkLighter),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: MyColors.darkLighter,
    scaffoldBackgroundColor: MyColors.dark,
    colorScheme: ColorScheme.dark(
      primary: MyColors.red,
      secondary: MyColors.yellow,
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(color: MyColors.white),
      displaySmall: TextStyle(color: MyColors.whiteDarker),
    ),
  );
}
