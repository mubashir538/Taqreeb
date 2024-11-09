import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
