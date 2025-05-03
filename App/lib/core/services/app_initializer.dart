import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:taqreeb/Screens/Main%20Screens/Business/user_listings.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/BusinessSignupProvider.dart';
import 'package:taqreeb/core/providers/ForgotPasswordVerifyCodeViewModel.dart';
import 'package:taqreeb/core/providers/ThemeProvider.dart';
import 'package:taqreeb/core/providers/businessEditInfoViewModel.dart';
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
      // Add BusinessData provider first since other providers depend on it
      ChangeNotifierProvider(create: (_) => BusinessData(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => YourListingsController()..fetchData(), lazy: true),

      // Existing providers
      ChangeNotifierProvider(
          create: (_) => BusinessSignupProvider(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => ForgotPasswordProvider(), lazy: true),

      // Modified BusinessInfoEditViewModel provider
      ChangeNotifierProxyProvider<BusinessData, BusinessAccountInfoViewModel>(
        create: (context) => BusinessAccountInfoViewModel(
          context.read<BusinessData>(),
        ),
        update: (context, businessData, previous) =>
            previous!..businessData = businessData,
        lazy: true,
      ),

      ChangeNotifierProxyProvider<BusinessData, BusinessInfoEditViewModel>(
        create: (context) => BusinessInfoEditViewModel(
          context.read<BusinessData>(),
        ),
        update: (context, businessData, previous) {
          return previous ?? BusinessInfoEditViewModel(businessData);
        },
        lazy: true,
      ),
      // Other existing providers
      ChangeNotifierProvider(
          create: (_) => ForgotPasswordVerifyCodeViewModel(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadTheme(), lazy: true),
    ];
  }
}
