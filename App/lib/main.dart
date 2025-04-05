import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Screens/AI/event_detail_ai.dart';
import 'package:taqreeb/Screens/AI/event_packages_ai.dart';
import 'package:taqreeb/Screens/AI/function_detail_ai.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/basic_info_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/cnic_upload_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/description_business.dart';
import 'package:taqreeb/Screens/Account%20Management/Business%20Signup/submission_success.dart';
import 'package:taqreeb/Screens/Account%20Management/Forgot%20Password/input_credentials_forgot.dart';
import 'package:taqreeb/Screens/Account%20Management/Forgot%20Password/new_password_forgot.dart';
import 'package:taqreeb/Screens/Account%20Management/Forgot%20Password/verification_forgot.dart';
import 'package:taqreeb/Screens/Account%20Management/Freelancer%20Signup/basic_info_freelancer.dart';
import 'package:taqreeb/Screens/Account%20Management/Freelancer%20Signup/description_freelancer.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/basic_info.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/more_info_signup.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/profile_upload.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/send_otp_contact.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/send_otp_email.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/verify_otp_contact.dart';
import 'package:taqreeb/Screens/Account%20Management/User%20Signup/verify_otp_email.dart';
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
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_add_addons.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_add_image.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_add_package.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_addons.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_basic.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_details.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_package.dart';
import 'package:taqreeb/Screens/Listings/Add%20Listing/add_listing_video_upload.dart';
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
import 'package:taqreeb/core/providers/ThemeProvider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/app_initializer.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Screens/Globals/splash_screen.dart';
import 'package:taqreeb/core/utils/themes.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve splash screen with required widgetsBinding parameter
  FlutterNativeSplash.preserve(
    widgetsBinding: widgetsBinding,
  );

  // Initialize in background
  final initialization = AppInitializer.init();

  runApp(
    MultiProvider(
      providers: AppInitializer.getProviders(),
      child: FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          // Remove splash when done
          if (snapshot.connectionState == ConnectionState.done) {
            FlutterNativeSplash.remove();
            return MainApp();
          }
          // Show empty container while loading
          return const SizedBox.shrink();
        },
      ),
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
    return PopScope(
      onPopInvokedWithResult: (didpop, Object? result) async {
        await MyApi.cacheManager.emptyCache();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.darkTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: themeProvider.themeMode,
        initialRoute: '/',
        routes: _buildRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/': (context) => SplashScreen(),
      '/AIPackage_EventDetail': (context) => AiPackageEventDetail(),
      '/AIPackage_FunctionDetail': (context) => AIPackage_FunctionDetail(),
      '/AccountInfo': (context) => MainScreen(index: 3),
      '/AccountInfoEdit': (context) => AccountInfoEdit(),
      '/Add360video': (context) => Add360Video(),
      '/AddCategory_Add_Addons': (context) => AddCategoryAddAddons(),
      '/AddCategory_AddImage': (context) => AddImage(),
      '/AddCategory_Addons': (context) => AddCategoryAddons(),
      '/AddCategory_AddPackage': (context) => AddCategoryAddPackage(),
      '/AddCategory_List': (context) => AddCategoryListing(),
      '/AddCategory_MoreDetails': (context) => AddCategoryMoreDetails(),
      '/AddCategory_Packages': (context) => AddCategoryPackages(),
      '/BasicSignup': (context) => BasicSignup(),
      '/BusinessAccountInfo': (context) => MainScreen(index: 3),
      '/BusinessInfoEdit': (context) => BusinessInfoEdit(),
      '/BusinessSignup_BasicInfo': (context) => BusinessSignup_BasicInfo(),
      '/BusinessSignup_CNICUpload': (context) => BusinessSignup_CNICUpload(),
      '/BusinessSignup_Description': (context) => BusinessSignupDescription(),
      '/CategoryView_CarRenter': (context) => CategoryView_CarRenter(),
      '/CategoryView_Caterers': (context) => CategoryView_Caterers(),
      '/CategoryView_Decorator': (context) => CategoryView_Decorator(),
      '/CategoryView_GraphicDesigner': (context) =>
          CategoryView_GraphicDesigner(),
      '/CategoryView_Parlour': (context) => CategoryViewParlour(),
      '/CategoryView_Photographer': (context) => CategoryView_Photographer(),
      '/CategoryView_PhotographyPlace': (context) =>
          CategoryView_PhotographyPlace(),
      '/CategoryView_Salon': (context) => CategoryView_Saloon(),
      '/CategoryView_Venue': (context) => CategoryView_Venue(),
      '/CategoryView_VideoEditor': (context) => CategoryViewVideoEditor(),
      '/ChatBox': (context) => ChatBox(),
      '/ChatsScreen': (context) => MainScreen(index: 1),
      '/CreateAIPackage': (context) => MainScreen(index: 1),
      '/CreateChecklistItems': (context) => CreateChecklistItems(),
      '/CreateEvent': (context) => CreateEvent(),
      '/CreateFunction': (context) => CreateFunction(),
      '/CreateGroup': (context) => CreateGroupScreen(),
      '/CreateGuestList': (context) => CreateGuestList(),
      '/CreateGuestList_AddFamily': (context) => CreateGuestList_AddFamily(),
      '/CreateGuestList_AddPerson': (context) => CreateGuestList_AddPerson(),
      '/CreateGuestList_List': (context) => CreateGuestList_List(),
      '/Dashboard': (context) => Dashboard(),
      '/EditEvent': (context) => CreateEvent(),
      '/EditFunction': (context) => CreateFunction(),
      '/EventDetails': (context) => EventDetails(),
      '/ForgotPassword_EmailorPhoneInput': (context) =>
          ForgotPassword_EmailorPhoneInput(),
      '/ForgotPassword_NewPassword': (context) => ForgotPassword_NewPassword(),
      '/ForgotPassword_VerifyCode': (context) => ForgotPasswordVerifyCode(),
      '/FreelancerSignup_BasicInfo': (context) => FreelancerSignup_BasicInfo(),
      '/FreelancerSignup_Description': (context) =>
          FreelancerSignupDescription(),
      '/FunctionDetail': (context) => FunctionDetail(),
      '/GroupChatBox': (context) => GroupChatScreen(),
      '/HomePage': (context) => MainScreen(index: 0),
      '/Login': (context) => Login(),
      '/OrderSummary': (context) => OrderSummaryScreen(),
      '/PaymentDetails': (context) => SecurePaymentScreen(),
      '/ProfilePictureUpload': (context) => ProfilePictureUpload(),
      '/ReviewPage': (context) => ReviewScreen(),
      '/SearchService': (context) => SearchService(),
      '/Settings': (context) => Settings(),
      '/Signup_ContactOTPSend': (context) => SignupContactOtpSend(),
      '/Signup_ContactOTPVerify': (context) => SignupContactOtpVerify(),
      '/Signup_EmailOTPSend': (context) => SignupEmailOtpSend(),
      '/Signup_EmailOTPVerify': (context) => SignupEmailOtpVerify(),
      '/Signup_MoreInfo': (context) => SignupMoreInfo(),
      '/SubmissionSucessful': (context) => SubmissionSucessful(),
      '/ViewAIPackage': (context) => ViewAIPackage(),
      '/Wishlist': (context) => WishlistViewPage(),
      '/YourEvents': (context) => MainScreen(index: 2),
      '/YourListings': (context) => MainScreen(index: 2),
      '/search_new_user': (context) => NewUserSearch(),
    };
  }
}
