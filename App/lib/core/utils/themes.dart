import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xffFFD5DC), // darkLighter
    scaffoldBackgroundColor: Color(0xffffffff), // dark
    colorScheme: ColorScheme.light(
      primary: Color(0xffF13F5A), // red
      secondary: Color(0xffFFC107), // yellow
      background: Color(0xffedf2f4),
      surface: Color(0xffFFF5F6), // lightDark
      onBackground: Color(0xff121212), // white
      onSurface: Color(0xff242526), // whiteDarker
    ),
    textTheme: TextTheme(
      displayMedium:
          GoogleFonts.roboto(color: Color(0xff18191A)), // dark in light mode
      displaySmall: GoogleFonts.roboto(
          color: Color(0xff242526)), // whiteDarker in light mode
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xff1e1e1e), // darkLighter
    scaffoldBackgroundColor: Color(0xff121212), // dark
    colorScheme: ColorScheme.dark(
      primary: Color(0xffF13F5A), // red
      secondary: Color(0xffFFC107), // yellow
      background: Color(0xff121212), // dark
      surface: Color(0xff2d2d2d), // darkLighter
      onBackground: Color(0xffedf2f4), // white
      onSurface: Color(0xffd9d9d9), // whiteDarker
    ),
    textTheme: TextTheme(
      displayMedium: GoogleFonts.roboto(color: Color(0xffedf2f4)), // white
      displaySmall: GoogleFonts.roboto(color: Color(0xffd9d9d9)), // whiteDarker
    ),
  );
}
