import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  final Connectivity _connectivity = Connectivity();
  bool _isCheckingConnection = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

// 2. Update your connection status update method
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result = results.first; // or handle all results as needed
    if (result == ConnectivityResult.none && mounted) {
      _navigateToNoInternet();
    }
  }

// 3. Update your initialization
  @override
  void initState() {
    super.initState();
    _initializeApp();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
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
      // Simple request to check server availability
      await MyApi.getRequest(
        endpoint:
            'health-check/', // Create a simple endpoint that just returns 200 OK
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
        'userId': userId,
      });

      if (success) {
        timer.cancel();
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            isLoggedIn ? '/HomePage' : '/Login',
          );
        }
      } else if (mounted) {
        _navigateToNoInternet();
      }
    });
  }

  void _navigateToNoInternet() {
    if (mounted && _isCheckingConnection) {
      _isCheckingConnection = false;
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
            endpoint: 'home/listings/?page=1&page_size=10',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            endpoint: 'Homepage/DemoImages/',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            endpoint: 'home/categories/',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
            endpoint: 'accountInfo/$userId/',
            headers: header,
            refresh: true,
            timeout: Duration(seconds: 10),
          ),
          MyApi.getRequest(
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
              MyImages.Logo,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            SizedBox(height: 20),
            _isCheckingConnection
                ? CircularProgressIndicator(color: MyColors.white)
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
