import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info_edit_business.dart';
import 'package:taqreeb/core/providers/BusinessSignupProvider.dart';
import 'package:taqreeb/core/providers/ForgotPasswordVerifyCodeViewModel.dart';
import 'package:taqreeb/core/providers/ThemeProvider.dart';
import 'package:taqreeb/core/providers/businessInfoViewModel.dart';
import 'package:taqreeb/core/providers/forgotPasswordProvider.dart';
import 'package:taqreeb/core/services/firebase_service.dart';
class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase first
    await FirebaseService.initialize();
    
    // Then remove splash screen
    FlutterNativeSplash.remove();
  }

  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => BusinessSignupProvider(), lazy: true),
      ChangeNotifierProvider(create: (_) => ForgotPasswordProvider(), lazy: true),
      ChangeNotifierProvider(create: (_) => BusinessInfoEditViewModel(), lazy: true),
      ChangeNotifierProvider(create: (_) => ForgotPasswordVerifyCodeViewModel(), lazy: true),
      ChangeNotifierProvider(create: (_) => BusinessAccountInfoViewModel(), lazy: true),
      ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme(), lazy: true),
    ];
  }
}