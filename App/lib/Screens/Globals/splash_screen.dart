import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_service.dart';
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
    MyColors.getTheme();
    await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);
    final bool isLoggedIn = await MyStorage.exists(MyTokens.accessToken);
    final header = {
      'Authorization':
          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
    };

    // MyApi.cacheManager.emptyCache();
    final String? userId = await MyStorage.getToken(MyTokens.userId);

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      bool success = await preApiCall({
        'header': header,
        'isLoggedIn': isLoggedIn,
        'userId': userId,
      }); // Call your async function
      if (success) {
        timer.cancel();
        if(mounted){

        Navigator.pushReplacementNamed(
          context,
          isLoggedIn ? '/HomePage' : '/Login',
        ); // Stop the timer if task succeeds
        }
      }
    });
  }

  Future<bool> preApiCall(Map<String, dynamic> data) async {
    final Map<String, String> header = Map<String, String>.from(data['header']);
    final bool isLoggedIn = data['isLoggedIn'];
    final String? userId = data['userId'];
    if (isLoggedIn) {
MyApi.cacheManager.emptyCache();  
  await Future.wait([
      MyApi.getRequest(
          endpoint: 'home/listings/', headers: header, refresh: true),
      MyApi.getRequest(
          endpoint: 'Homepage/DemoImages/', headers: header, refresh: true),
      MyApi.getRequest(
          endpoint: 'home/categories/', headers: header, refresh: true),
      if (isLoggedIn) ...[
        MyApi.getRequest(
          endpoint: 'accountInfo/$userId/',
          headers: header,
        ),
        MyApi.getRequest(
          endpoint: 'YourEvents/$userId',
          headers: header,
        ),
      ],
    ]).then((_) {
      return true; // Return success status
    }).catchError((_) {
      return false; // Return failure status
    });   
    }
    return true;
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