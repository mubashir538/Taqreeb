import 'package:flutter/material.dart';
import 'package:taqreeb/Components/AI%20Package.dart';
import 'package:taqreeb/Screens/AccountInfo1.dart';
import 'package:taqreeb/Screens/AccountInfo2.dart';
import 'package:taqreeb/Screens/Business%20Profile%20Info.dart';
import 'package:taqreeb/Screens/Business%20Signup3.dart';
import 'package:taqreeb/Screens/Business%20Signup4.dart';
import 'package:taqreeb/Screens/BusinessSignup1.dart';
import 'package:taqreeb/Screens/Bussiness%20Signup2.dart';
import 'package:taqreeb/Screens/ChatBox.dart';
import 'package:taqreeb/Screens/Login%20Screen.dart';
import 'package:taqreeb/Screens/OTP%20Screen.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AI%20Function%20Details.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AI%20Package%20Details.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AI%20suggested%20packages.dart';
import 'package:taqreeb/Screens/Create%20AI%20Package/aipackage.dart';
import 'package:taqreeb/Screens/bakery%20and%20sweets.dart';
import 'package:taqreeb/Screens/homepage.dart';
import 'package:taqreeb/Screens/screens%20to%20be%20made/your%20listings.dart';
import 'package:taqreeb/Screens/signup.dart';
import 'package:taqreeb/Screens/signup2.dart';
import 'package:taqreeb/Screens/signup3.dart';
import 'package:taqreeb/Screens/signup4.dart';
import 'package:taqreeb/Screens/signup5.dart';
import 'package:taqreeb/Screens/signup6.dart';
import 'package:taqreeb/Screens/splash%20screen.dart';
import 'package:taqreeb/Screens/yourevent.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BusinessSignup2(),
      // routes: {
      //   // '/': (context) => SignUpScreen(),
      //   '/signup': (context) => SignUpScreen(),
      //   '/login': (context) => LoginScreen(),
      //   '/home': (context) => HomeScreen(),
      //   '/accountinfo': (context) => AccountInfo1(),
      //   '/chats': (context) => ChatBox(),
      //   '/homeScreen': (context) => HomeScreen(),
      //   'createevent': (context) => EventsScreen(),
      //   // 'createaipackage': (context) => CreateAI(),
      //   'viewsuggestedPackages': (context) => AISuggestedPackages(),
      //   'viewAIPackageDetails': (context) => AIPackageDetails(),
      //   'viewAIPackageFunctions': (context) => AIFunctionDetails(),
      //   'AccountInfo1': (context) => AccountInfo1(),
      //   'AccountInfo2': (context) => AccountInfo2(),
      //   // 'Create AI Package' : (context) => AIPackage,
      //   'yourlistings': (context) => YourListings(),
      //   '/BakersandSweets': (context) => BakeryAndSweets(),
      //   '/BusinessProfile' : (context) => BusinessProfileInfo(),
      //   '/BusinessSignup1' : (context) => BusinessSignup1(),
      //   '/BusinessSignup2' : (context) => BusinessSignup2(),
      //   '/BusinessSignup3' : (context) => BusinessSignup3(),
      //   '/signup1': (context) => OTPScreen(),
      //   '/signup2': (context) => OTPScreen2(),
      //   '/signup3': (context) => OTPScreen3(),
      //   '/signup4': (context) => OTPScreen4(),
      //   '/signup5': (context) => OTPScreen5(),
      //   '/signup6': (context) => OTPScreen6(),
      // },

      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
