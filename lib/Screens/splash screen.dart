import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
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
    Timer(Duration(seconds: 3), () async {
      if (await MyStorage.exists('accessToken')) {
        Navigator.pushNamed(context, '/HomePage');
      } else {
        Navigator.pushNamed(context, '/basicSignup');
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
