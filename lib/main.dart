import 'package:flutter/material.dart';
import 'package:taqreeb/Components/mainScreen.dart';
import 'package:taqreeb/Screens/CategoryView_BakerySweet.dart';
import 'package:taqreeb/Screens/CategoryView_Caterers.dart';
import 'package:taqreeb/Screens/CategoryView_Decorator.dart';
import 'package:taqreeb/Screens/CategoryView_GraphicDesigner.dart';
import 'package:taqreeb/Screens/CategoryView_Parlour.dart';
import 'package:taqreeb/Screens/CategoryView_Photographer.dart';
import 'package:taqreeb/Screens/CategoryView_PhotographyPlace.dart';
import 'package:taqreeb/Screens/CategoryView_Saloon.dart';
import 'package:taqreeb/Screens/CategoryView_VideoEditor.dart';
import 'package:taqreeb/Screens/Dashboard.dart';
import 'package:taqreeb/Screens/AccountInfoEdit.dart';
import 'package:taqreeb/Screens/BusinessAccountInfo.dart';
import 'package:taqreeb/Screens/BusinessSignupScreens/BusinessSignup_BasicInfo.dart';
import 'package:taqreeb/Screens/BusinessSignupScreens/BusinessSignup_CNICUpload.dart';
import 'package:taqreeb/Screens/BusinessSignupScreens/BusinessSignup_Description.dart';
import 'package:taqreeb/Screens/BusinessSignupScreens/SubmissionSucessful.dart';
import 'package:taqreeb/Screens/Cart.dart';
import 'package:taqreeb/Screens/CategoryViewPages/CategoryView_Venue.dart';
import 'package:taqreeb/Screens/BakerySweet_Products.dart';
import 'package:taqreeb/Screens/CategoryView_CarRenter.dart';
import 'package:taqreeb/Screens/ChatBox.dart';
import 'package:taqreeb/Screens/Create%20AI%20Package/CreateAIPackage.dart';
import 'package:taqreeb/Screens/Create%20guest%20list/CreateGuestList.dart';
import 'package:taqreeb/Screens/Create%20guest%20list/CreateGuestList_AddFamily.dart';
import 'package:taqreeb/Screens/Create%20guest%20list/CreateGuestList_List.dart';
import 'package:taqreeb/Screens/Create%20guest%20list/CreateGuestList_AddPerson.dart';
import 'package:taqreeb/Screens/CreateChecklistItems.dart';
import 'package:taqreeb/Screens/CreateEvent.dart';
import 'package:taqreeb/Screens/CreateFunction.dart';
import 'package:taqreeb/Screens/EventDetails.dart';
import 'package:taqreeb/Screens/ForgotPassword_EmailorPhoneInput.dart';
import 'package:taqreeb/Screens/ForgotPassword_NewPassword.dart';
import 'package:taqreeb/Screens/ForgotPassword_VerifyCode.dart';
import 'package:taqreeb/Screens/Freelancer%20Signup/FreelancerSignup_Description.dart';
import 'package:taqreeb/Screens/Freelancer%20Signup/FreelancerSignup_BasicInfo.dart';
import 'package:taqreeb/Screens/FunctionDetail.dart';
import 'package:taqreeb/Screens/Login.dart';
import 'package:taqreeb/Screens/SearchService.dart';
import 'package:taqreeb/Screens/SignupScreens/ProfilePictureUpload.dart';
import 'package:taqreeb/Screens/SignupScreens/Signup_ContactOTPVerify.dart';
import 'package:taqreeb/Screens/SignupScreens/Signup_ContactOTPSend.dart';
import 'package:taqreeb/Screens/SignupScreens/Signup_EmailOTPVerify.dart';
import 'package:taqreeb/Screens/SignupScreens/Signup_EmailOTPSend.dart';
import 'package:taqreeb/Screens/SignupScreens/Signup_MoreInfo.dart';
import 'package:taqreeb/Screens/SignupScreens/basicSignup.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AIPackage_EventDetail.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/AIPackage_FunctionDetail.dart';
import 'package:taqreeb/Screens/View%20AI%20Packages/ViewAIPackage.dart';
import 'package:taqreeb/Screens/screens%20to%20be%20made/InvitationCardEdit.dart';
import 'package:taqreeb/Screens/screens%20to%20be%20made/YourListings.dart';
import 'package:taqreeb/Screens/splash%20screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/basicSignup': (context) => BasicSignup(),
        '/Signup_ContactOTPSend': (context) => Signup_ContactOTPSend(),
        '/Signup_ContactOTPVerify': (context) => SignupContactOTPVerify(),
        '/Signup_EmailOTPSend': (context) => Signup_EmailOTPSend(),
        '/Signup_EmailOTPVerify': (context) => SignupEmailOTPVerify(),
        '/Signup_MoreInfo': (context) => Signup_MoreInfo(),
        '/ProfilePictureUpload': (context) => ProfilePictureUpload(),
        '/BusinessSignup_BasicInfo': (context) => BusinessSignup_BasicInfo(),
        '/BusinessSignup_CNICUpload': (context) => BusinessSignup_CNICUpload(),
        '/BusinessSignup_Description': (context) =>
            BusinessSignup_Description(),
        '/SubmissionSucessful': (context) => SubmissionSucessful(),
        '/HomePage': (context) => MainScreen(index: 0),
        '/Login': (context) => Login(),
        '/CreateChecklistItems': (context) => CreateChecklistItems(),
        // '/HelpCenter': (context) => ,
        '/FreelancerSignup_BasicInfo': (context) =>
            FreelancerSignup_BasicInfo(),
        '/FreelancerSignup_Description': (context) =>
            FreelancerSignup_Description(),
        '/ForgotPassword_EmailorPhoneInput': (context) =>
            ForgotPassword_EmailorPhoneInput(),
        '/ForgotPassword_VerifyCode': (context) => ForgotPassword_VerifyCode(),
        '/ForgotPassword_NewPassword': (context) =>
            ForgotPassword_NewPassword(),
        '/CreateAIPackage': (context) => CreateAIPackage(),
        '/ViewAIPackage': (context) => ViewAIPackage(),
        '/AIPackage_EventDetail': (context) => AIPackage_EventDetail(),
        '/AIPackage_FunctionDetail': (context) => AIPackage_FunctionDetail(),
        '/ChatsScreen': (context) => MainScreen(index: 1),
        '/ChatBox': (context) => ChatBox(),
        '/SearchService': (context) => SearchService(),
        '/YourListings': (context) => YourListings(),
        '/AccountInfo': (context) => MainScreen(index: 3),
        '/AccountInfoEdit': (context) => AccountInfoEdit(),
        '/BusinessAccountInfo': (context) => BusinessAccountInfo(),
        '/CreateGuestList': (context) => CreateGuestList(),
        '/CreateGuestList_AddFamily': (context) => CreateGuestList_AddFamily(),
        '/CreateGuestList_AddPerson': (context) => CreateGuestList_AddPerson(),
        '/CreateGuestList_List': (context) => CreateGuestList_List(),
        '/CreateFunction': (context) => CreateFunction(),
        '/EventDetails': (context) => EventDetails(),
        '/CategoryView_Venue': (context) => CategoryView_Venue(),
        '/CategoryView_Saloon': (context) => CategoryView_Saloon(),
        '/CategoryView_Parlour': (context) => CategoryView_Parlour(),
        '/CategoryView_VideoEditor': (context) => CategoryView_VideoEditor(),
        '/CategoryView_Decorator': (context) => CategoryView_Decorator(),
        '/CategoryView_PhotographyPlace': (context) =>
            CategoryView_PhotographyPlace(),
        '/CategoryView_Photographer': (context) => CategoryView_Photographer(),
        '/CategoryView_BakerySweet': (context) => CategoryView_BakerySweet(),
        '/CategoryView_GraphicDesigner': (context) =>
            CategoryView_GraphicDesigner(),
        '/CategoryView_CarRenter': (context) => CategoryView_CarRenter(),
        '/FunctionDetail': (context) => FunctionDetail(),
        '/BakerySweet_Products': (context) => BakerySweet_Products(),
        '/Cart': (context) => Cart(),
        '/InvitationCardEdit': (context) => InvitationCardEdit(),
        '/CreateEvent': (context) => CreateEvent(),
        '/YourEvents': (context) => MainScreen(index: 2),
        '/Dashboard': (context) => Dashboard(),
        '/CategoryView_Caterers': (context) => CategoryView_Caterers(),
        // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
        //   // '/': (context) => ,
      },
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
