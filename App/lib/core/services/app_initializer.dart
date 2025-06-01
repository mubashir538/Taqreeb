import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:taqreeb/Screens/Account%20Management/Freelancer%20Signup/description_freelancer.dart';
import 'package:taqreeb/Screens/Main%20Screens/Business/user_listings.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/business_signup_provider.dart';
import 'package:taqreeb/core/providers/forgot_password_verify_code_view_model.dart';
import 'package:taqreeb/core/providers/theme_provider.dart';
import 'package:taqreeb/core/providers/business_edit_info_view_model.dart';
import 'package:taqreeb/core/providers/business_info_view_model.dart';
import 'package:taqreeb/core/providers/forgot_password_provider.dart';
import 'package:taqreeb/core/services/firebase_service.dart';
import 'package:taqreeb/firebase_options.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseService.setup();

    FlutterNativeSplash.remove();
  }

  static List<SingleChildWidget> getProviders() {
    return [
      ChangeNotifierProvider(create: (_) => BusinessData(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => YourListingsController()..fetchData(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => BusinessSignupProvider(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => ForgotPasswordProvider(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => FreelancerSignupDescriptionViewModel()),
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
      ChangeNotifierProvider(
          create: (_) => ForgotPasswordVerifyCodeViewModel(), lazy: true),
      ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadTheme(), lazy: true),
    ];
  }
}
