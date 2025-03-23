import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:taqreeb/Screens/Globals/splash_screen.dart';
import 'package:taqreeb/Screens/Main%20Screens/Business/dashboard.dart';
import 'package:taqreeb/Screens/Main%20Screens/main_screen.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_video_upload.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_add_addons.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_add_image.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_add_package.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_addons.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_details.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_package.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_basic.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info_edit_business.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_caterer.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_decorator.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_graphic_designer.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_parlor.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_photographer.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_photography_place.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_salon.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_video_editor.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info_edit.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/basic_info_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/cnic_upload_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/description_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/submission_success.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_venue.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_car_renter.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/create_guestlist.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/create_guestlist_family.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/view_guestlist.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/create_guestlist_person.dart';
import 'package:taqreeb/Screens/Event%20Management/Checklist/checklist.dart';
import 'package:taqreeb/Screens/Event%20Management/Events/create_event.dart';
import 'package:taqreeb/Screens/Event%20Management/Functions/create_function.dart';
import 'package:taqreeb/Screens/Event%20Management/Events/view_event.dart';
import 'package:taqreeb/Screens/Account%20Management/Forgot%20Password/input_credentials_forgot.dart';
import 'package:taqreeb/Screens/Account%20Management/Forgot%20Password/new_password_forgot.dart';
import 'package:taqreeb/Screens/Account%20Management/Forgot%20Password/verification_forgot.dart';
import 'package:taqreeb/Screens/Account%20Management/Freelancer%20Signup/description_freelancer.dart';
import 'package:taqreeb/Screens/Account%20Management/Freelancer%20Signup/basic_info_freelancer.dart';
import 'package:taqreeb/Screens/Event%20Management/Functions/view_function.dart';
import 'package:taqreeb/Screens/Account%20Management/login.dart';
import 'package:taqreeb/Screens/Payments/order_summary.dart';
import 'package:taqreeb/Screens/Search/listing_search.dart';
import 'package:taqreeb/Screens/Globals/settings.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/profile_upload.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/verify_otp_contact.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/send_otp_contact.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/verify_otp_email.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/send_otp_email.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/more_info_signup.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/basic_info.dart';
import 'package:taqreeb/Screens/AI/event_detail_ai.dart';
import 'package:taqreeb/Screens/AI/function_detail_ai.dart';
import 'package:taqreeb/Screens/AI/event_packages_ai.dart';
import 'package:taqreeb/Screens/chat/Groups/chat_box_group.dart';
import 'package:taqreeb/Screens/chat/Groups/create_group.dart';
import 'package:taqreeb/Screens/chat/chat_box.dart';
import 'package:taqreeb/Screens/chat/search_new_user.dart';
import 'package:taqreeb/Screens/Payments/debit_card_details.dart';
import 'package:taqreeb/Screens/Listings/review_screen.dart';
import 'package:taqreeb/Screens/Listings/user_wishlist.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message: ${message.notification?.title}");
}

FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

void initializeLocalNotifications() {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);
  localNotifications.initialize(initSettings);
}

void showNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.high,
    priority: Priority.high,
  );

  NotificationDetails details = NotificationDetails(android: androidDetails);
  await localNotifications.show(
      0, message.notification?.title, message.notification?.body, details);
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  requestPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message received: ${message.notification?.title}");
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(message);
  });
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  bool ishome = false;

  void initialize() async {
    MyColors.getTheme();

    Timer(Duration(seconds: 3), () async {
      await MyStorage.saveToken(MyTokens.dark, MyTokens.theme);
      if (await MyStorage.exists(MyTokens.accessToken)) {
        ishome = true;
      }
    });
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/wishlist': (context) => WishlistViewPage(),
        '/orderSummary': (context) => OrderSummaryScreen(),
        '/Add360video': (context) => Add360video(),
        '/paymentdetails': (context) => SecurePaymentScreen(),
        '/settings': (context) => Settings(),
        '/reviewPage': (context) => ReviewScreen(),
        '/AddCategory_Add_Addons': (context) => AddcategoryAddaddons(),
        '/AddCategory_AddImage': (context) => AddImage(),
        '/AddCategory_Addons': (context) => AddcategoryAddons(),
        '/AddCategory_AddPackage': (context) => AddcategoryAddpackage(),
        '/AddCategory_List': (context) => AddcategoryList(),
        '/AddCategory_MoreDetails': (context) => AddcategoryMoredetails(),
        '/AddCategory_Packages': (context) => AddcategoryPackages(),
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
        '/FreelancerSignup_BasicInfo': (context) =>
            FreelancerSignup_BasicInfo(),
        '/FreelancerSignup_Description': (context) =>
            FreelancerSignup_Description(),
        '/CreateGroup': (context) => CreateGroupScreen(),
        '/ForgotPassword_EmailorPhoneInput': (context) =>
            ForgotPassword_EmailorPhoneInput(),
        '/ForgotPassword_VerifyCode': (context) => ForgotPassword_VerifyCode(),
        '/ForgotPassword_NewPassword': (context) =>
            ForgotPassword_NewPassword(),
        // '/CreateAIPackage': (context) => CreateAIPackage(),
        '/ViewAIPackage': (context) => ViewAIPackage(),
        '/AIPackage_EventDetail': (context) => AIPackage_EventDetail(),
        '/AIPackage_FunctionDetail': (context) => AIPackage_FunctionDetail(),
        '/ChatsScreen': (context) => MainScreen(index: 1),
        '/GroupChatBox': (context) => GroupChatScreen(),
        '/ChatBox': (context) => ChatBox(),
        '/SearchService': (context) => SearchService(),
        '/YourListings': (context) => MainScreen(index: 2),
        '/AccountInfo': (context) => MainScreen(index: 3),
        '/AccountInfoEdit': (context) => AccountInfoEdit(),
        '/BusinessInfoEdit': (context) => BusinessInfoEdit(),
        '/BusinessAccountInfo': (context) => MainScreen(index: 3),
        '/CreateGuestList': (context) => CreateGuestList(),
        '/CreateGuestList_AddFamily': (context) => CreateGuestList_AddFamily(),
        '/CreateGuestList_AddPerson': (context) => CreateGuestList_AddPerson(),
        '/CreateGuestList_List': (context) => CreateGuestList_List(),
        '/CreateFunction': (context) => CreateFunction(),
        '/EventDetails': (context) => EventDetails(),
        '/CategoryView_Venue': (context) => CategoryView_Venue(),
        '/CategoryView_Salon': (context) => CategoryView_Saloon(),
        '/CategoryView_Parlour': (context) => CategoryView_Parlour(),
        '/CategoryView_VideoEditor': (context) => CategoryView_VideoEditor(),
        '/CategoryView_Decorator': (context) => CategoryView_Decorator(),
        '/CategoryView_PhotographyPlace': (context) =>
            CategoryView_PhotographyPlace(),
        '/CategoryView_Photographer': (context) => CategoryView_Photographer(),
        // '/CategoryView_BakerySweet': (context) => CategoryView_BakerySweet(),
        '/CategoryView_GraphicDesigner': (context) =>
            CategoryView_GraphicDesigner(),
        '/CategoryView_CarRenter': (context) => CategoryView_CarRenter(),
        '/FunctionDetail': (context) => FunctionDetail(),
        // '/BakerySweet_Products': (context) => BakerySweet_Products(),
        // '/Cart': (context) => Cart(),
        // '/InvitationCardEdit': (context) => InvitationCardEdit(),
        '/CreateEvent': (context) => CreateEvent(),
        '/YourEvents': (context) => MainScreen(index: 2),
        '/Dashboard': (context) => Dashboard(),
        '/EditEvent': (context) => CreateEvent(),
        '/EditFunction': (context) => CreateFunction(),
        '/CategoryView_Caterers': (context) => CategoryView_Caterers(),
        '/search_new_user': (context) => NewUserSearch(),
      },
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
