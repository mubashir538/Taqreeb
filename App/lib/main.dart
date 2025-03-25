import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/basic_info_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/cnic_upload_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/description_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/submission_success.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/profile_upload.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info_edit.dart';
import 'package:taqreeb/Screens/Account%20Management/account_info_edit_business.dart';
import 'package:taqreeb/Screens/Account%20Management/login.dart';
import 'package:taqreeb/Screens/Event%20Management/Checklist/checklist.dart';
import 'package:taqreeb/Screens/Event%20Management/Events/create_event.dart';
import 'package:taqreeb/Screens/Event%20Management/Events/view_event.dart';
import 'package:taqreeb/Screens/Event%20Management/Functions/create_function.dart';
import 'package:taqreeb/Screens/Event%20Management/Functions/view_function.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/create_guestlist.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/create_guestlist_family.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/create_guestlist_person.dart';
import 'package:taqreeb/Screens/Event%20Management/Guest%20List/view_guestlist.dart';
import 'package:taqreeb/Screens/Globals/settings.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_car_renter.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_caterer.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_decorator.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_graphic_designer.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_parlor.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_photographer.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_photography_place.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_salon.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_venue.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/listing_video_editor.dart';
import 'package:taqreeb/Screens/Listings/review_screen.dart';
import 'package:taqreeb/Screens/Listings/user_wishlist.dart';
import 'package:taqreeb/Screens/Main%20Screens/Business/dashboard.dart';
import 'package:taqreeb/Screens/Main%20Screens/main_screen.dart';
import 'package:taqreeb/Screens/Payments/debit_card_details.dart';
import 'package:taqreeb/Screens/Payments/order_summary.dart';
import 'package:taqreeb/Screens/Search/listing_search.dart';
import 'package:taqreeb/Screens/chat/Groups/chat_box_group.dart';
import 'package:taqreeb/Screens/chat/Groups/create_group.dart';
import 'package:taqreeb/Screens/chat/chat_box.dart';
import 'package:taqreeb/Screens/chat/search_new_user.dart';
import 'package:taqreeb/core/providers/BusinessSignupProvider.dart';
import 'package:taqreeb/core/providers/ForgotPasswordVerifyCodeViewModel.dart';
import 'package:taqreeb/core/providers/ThemeProvider.dart';
import 'package:taqreeb/core/providers/businessInfoViewModel.dart';
import 'package:taqreeb/core/providers/forgotPasswordProvider.dart';
import 'package:taqreeb/core/services/firebase_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Screens/Globals/splash_screen.dart';
import 'package:taqreeb/core/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and notifications
  await FirebaseService.initialize();

  // Remove splash screen after initialization
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusinessSignupProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider(create: (_) => BusinessInfoEditViewModel()),
        ChangeNotifierProvider(
            create: (_) => ForgotPasswordVerifyCodeViewModel()),
        ChangeNotifierProvider(create: (_) => BusinessAccountInfoViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isHome = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    MyColors.getTheme();

    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if the user is logged in
    if (await MyStorage.exists(MyTokens.accessToken)) {
      setState(() {
        isHome = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: _buildRoutes(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => SplashScreen(),
      '/HomePage': (context) => MainScreen(index: 0),
      '/Login': (context) => Login(),
      '/BusinessSignup_BasicInfo': (context) => BusinessSignup_BasicInfo(),
      '/BusinessSignup_CNICUpload': (context) => BusinessSignup_CNICUpload(),
      '/BusinessSignup_Description': (context) => BusinessSignupDescription(),
      '/SubmissionSucessful': (context) => SubmissionSucessful(),
      '/ProfilePictureUpload': (context) => ProfilePictureUpload(),
      '/AccountInfoEdit': (context) => AccountInfoEdit(),
      '/BusinessInfoEdit': (context) => BusinessInfoEdit(),
      '/CreateEvent': (context) => CreateEvent(),
      '/CreateFunction': (context) => CreateFunction(),
      '/CreateGuestList': (context) => CreateGuestList(),
      '/CreateGuestList_AddFamily': (context) => CreateGuestList_AddFamily(),
      '/CreateGuestList_AddPerson': (context) => CreateGuestList_AddPerson(),
      '/CreateGuestList_List': (context) => CreateGuestList_List(),
      '/CreateChecklistItems': (context) => CreateChecklistItems(),
      '/EventDetails': (context) => EventDetails(),
      '/FunctionDetail': (context) => FunctionDetail(),
      '/CategoryView_Venue': (context) => CategoryView_Venue(),
      '/CategoryView_Salon': (context) => CategoryView_Saloon(),
      '/CategoryView_Parlour': (context) => CategoryView_Parlour(),
      '/CategoryView_VideoEditor': (context) => CategoryView_VideoEditor(),
      '/CategoryView_Decorator': (context) => CategoryView_Decorator(),
      '/CategoryView_PhotographyPlace': (context) =>
          CategoryView_PhotographyPlace(),
      '/CategoryView_Photographer': (context) => CategoryView_Photographer(),
      '/CategoryView_GraphicDesigner': (context) =>
          CategoryView_GraphicDesigner(),
      '/CategoryView_CarRenter': (context) => CategoryView_CarRenter(),
      '/CategoryView_Caterers': (context) => CategoryView_Caterers(),
      '/Dashboard': (context) => Dashboard(),
      '/Settings': (context) => Settings(),
      '/OrderSummary': (context) => OrderSummaryScreen(),
      '/PaymentDetails': (context) => SecurePaymentScreen(),
      '/ReviewPage': (context) => ReviewScreen(),
      '/Wishlist': (context) => WishlistViewPage(),
      '/SearchService': (context) => SearchService(),
      '/ChatBox': (context) => ChatBox(),
      '/GroupChatBox': (context) => GroupChatScreen(),
      '/CreateGroup': (context) => CreateGroupScreen(),
      '/NewUserSearch': (context) => NewUserSearch(),
    };
  }
}
