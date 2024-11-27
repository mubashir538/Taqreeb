
import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/changed%20Names/Create%20function.dart';
import 'package:taqreeb/Screens/changed%20Names/Event%20Details.dart';
import 'package:taqreeb/Screens/changed%20Names/createevent.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EventDetailsScreen(),
      // routes: {
      //   '/': (context) => ,
      //   '/basicSignup': (context) => ,
      //   '/Signup_ContactOTPSend': (context) => ,
      //   '/Signup_ContactOTPVerify': (context) => ,
      //   '/Signup_EmailOTPSend': (context) => ,
      //   '/Signup_EmailOTPVerify': (context) => ,
      //   '/Signup_MoreInfo': (context) => ,
      //   '/ProfilePictureUpload': (context) => ,
      //   '/BusinessSignup_BasicInfo': (context) => ,
      //   '/BusinessSignup_CNICUpload': (context) => ,
      //   '/BusinessSignup_Description': (context) => ,
      //   '/SubmissionSucessful': (context) => ,
      //   '/HomePage': (context) => ,
      //   '/Login': (context) => ,
      //   '/CreateChecklistItems': (context) => ,
      //   '/HelpCenter': (context) => ,
      //   '/FreelancerSignup_BasicInfo': (context) => ,
      //   '/FreelancerSignup_Description': (context) => ,
      //   '/ForgotPassword_EmailorPhoneInput': (context) => ,
      //   '/ForgotPassword_VerifyCode': (context) => ,
      //   '/ForgotPassword_NewPassword': (context) => ,
      //   '/CreateAIPackage': (context) => ,
      //   '/ViewAIPackage': (context) => ,
      //   '/AIPackage_EventDetail': (context) => ,
      //   '/AIPackage_FunctionDetail': (context) => ,
      //   '/ChatsScreen': (context) => ,
      //   '/ChatBox': (context) => ,
      //   '/SearchService': (context) => ,
      //   '/YourListings': (context) => ,
      //   '/AccountInfo': (context) => ,
      //   '/AccountInfoEdit': (context) => ,
      //   '/BusinessAccountInfo': (context) => ,
      //   '/CreateGuestList': (context) => ,
      //   '/CreateGuestList_AddFamily': (context) => ,
      //   '/CreateGuestList_AddPerson': (context) => ,
      //   '/CreateGuestList_List': (context) => ,
      //   '/CreateFunction': (context) => ,
      //   '/EventDetails': (context) => ,
      //   '/CategoryView_Venue': (context) => ,
      //   '/CategoryView_Saloon': (context) => ,
      //   '/CategoryView_Parlour': (context) => ,
      //   '/CategoryView_VideoEditor': (context) => ,
      //   '/CategoryView_Decorator': (context) => ,
      //   '/CategoryView_PhotographyPlace': (context) => ,
      //   '/CategoryView_Photographer': (context) => ,
      //   '/CategoryView_BakerySweet': (context) => ,
      //   '/CategoryView_GraphicDesigner': (context) => ,
      //   '/CategoryView_CarRenter': (context) => ,
      //   '/FunctionDetail': (context) => ,
      //   '/BakerySweet_Products': (context) => ,
      //   '/Cart': (context) => ,
      //   '/InvitationCardEdit': (context) => ,
      //   '/CreateEvent': (context) => ,
      //   '/YourEvents': (context) => ,
      //   '/Dashboard': (context) => ,
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
      //   // '/': (context) => ,
      //   // '/': (context) => ,

      // },

      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
