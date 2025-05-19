import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();
  bool _isCheckingConnection = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  double _progressValue = 0.0;
  late Timer _progressTimer;

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result = results.first;
    if (result == ConnectivityResult.none && mounted) {
      _navigateToNoInternet();
    }
  }

  @override
  void initState() {
    super.initState();
    _startProgressTimer();
    _initializeApp();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _startProgressTimer() {
    const totalDuration = Duration(seconds: 5);
    const interval = Duration(milliseconds: 50);
    final totalSteps = totalDuration.inMilliseconds ~/ interval.inMilliseconds;
    final increment = 1.0 / totalSteps;

    _progressTimer = Timer.periodic(interval, (timer) {
      if (mounted) {
        setState(() {
          _progressValue += increment;
          if (_progressValue >= 1.0) {
            _progressValue = 1.0;
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _progressTimer.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    MyColors.getTheme();
    await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);

    // First check internet connection
    final connectivityResults = await _connectivity.checkConnectivity();
    if (connectivityResults.first == ConnectivityResult.none) {
      _navigateToNoInternet();
      return;
    }

    // Then check server reachability
    try {
      await MyApi.getRequest(
        context: context,
        endpoint: 'health-check/',
        headers: {},
        timeout: Duration(seconds: 5),
      );
    } catch (e) {
      _navigateToNoInternet();
      return;
    }

    // Proceed with normal initialization if connection is good
    await _continueInitialization();
  }

  Future<void> _continueInitialization() async {
    final bool isLoggedIn = await MyStorage.exists(MyTokens.accessToken);
    final token = await MyStorage.getToken(MyTokens.accessToken);
    final header = {'Authorization': 'Bearer $token'};
    final String? userId = await MyStorage.getToken(MyTokens.userId);

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      bool success = await preApiCall({
        'header': header,
        'isLoggedIn': isLoggedIn,
        'userId': userId
      });

      if (success) {
        timer.cancel();
        if (mounted) {
          // Wait until progress reaches 100% before navigating
          if (_progressValue >= 1.0) {
            Navigator.pushReplacementNamed(
              context,
              isLoggedIn ? '/HomePage' : '/Login',
            );
          } else {
            // If APIs finish before progress completes, wait for progress
            _progressTimer =
                Timer.periodic(const Duration(milliseconds: 100), (t) {
              if (_progressValue >= 1.0 && mounted) {
                t.cancel();
                Navigator.pushReplacementNamed(
                  context,
                  isLoggedIn ? '/HomePage' : '/Login',
                );
              }
            });
          }
        }
      } else if (mounted) {
        _navigateToNoInternet();
      }
    });
  }

  void _navigateToNoInternet() {
    if (mounted && _isCheckingConnection) {
      _isCheckingConnection = false;
      _progressTimer.cancel();
      Navigator.pushReplacementNamed(context, '/NoInternet');
    }
  }

  Future<bool> preApiCall(Map<String, dynamic> data) async {
    try {
      final Map<String, String> header =
          Map<String, String>.from(data['header']);
      final bool isLoggedIn = data['isLoggedIn'];
      final String? userId = data['userId'];

      if (isLoggedIn) {
        MyApi.cacheManager.emptyCache();
        await Future.wait([
          MyApi.getRequest(
            context: context,
            endpoint: 'home/listings/?page=1&page_size=10',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            context: context,
            endpoint: 'Homepage/DemoImages/',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            context: context,
            endpoint: 'home/categories/',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            context: context,
            endpoint: 'accountInfo/$userId/',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            context: context,
            endpoint: 'YourEvents/$userId',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
        ]);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              MyImages.logo,
              width: Screen.width(context) * 0.9,
            ),
            SizedBox(height: Screen.height(context) * 0.05),
            Container(
              decoration: BoxDecoration(
                color: MyColors.whiteDarker,
                borderRadius: BorderRadius.circular(20),
              ),
              width: Screen.width(context) * 0.5,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // same radius as container
                child: LinearProgressIndicator(
                  value: _progressValue,
                  backgroundColor: MyColors.whiteDarker,
                  valueColor: AlwaysStoppedAnimation<Color>(MyColors.red),
                  minHeight: Screen.height(context) * 0.02,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
