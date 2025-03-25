import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load theme and check if the user is logged in
    MyColors.getTheme();
    await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);

    // Check if the user has an access token
    final bool isLoggedIn = await MyStorage.exists(MyTokens.accessToken);

    // Navigate to the appropriate screen after a delay
    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn) {
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
      body: Center(
        child: Image.asset(
          MyImages.Logo,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
