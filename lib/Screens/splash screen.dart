import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    MyColors.getTheme();
    Timer(Duration(seconds: 3), () async {
      await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);
      if (await MyStorage.exists(MyTokens.accessToken)) {
        Navigator.pushReplacementNamed(context, '/HomePage');
      } else {
        Navigator.pushReplacementNamed(context, '/Login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image.asset(
              MyImages.Logo,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          ),
        ),
      ),
    );
  }
}
