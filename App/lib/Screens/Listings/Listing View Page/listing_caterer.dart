import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_addon.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_chat.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_description.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_details.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_heading.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_image_slider.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_packages.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_pricing.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_review.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryView_Caterers extends StatefulWidget {
  const CategoryView_Caterers({super.key});

  @override
  State<CategoryView_Caterers> createState() => _CategoryView_CaterersState();
}

class _CategoryView_CaterersState extends State<CategoryView_Caterers> {
  String token = '';
  Map<String, dynamic> listing = {};
  late int? listingId;
  bool isLoading = true;
  DateTime? entryTime;

  bool isToggled = true;
  List<String> headings = [
    'Service Type',
    'Catering Options',
    'Staff',
    'Expertise'
  ];
  List<String> values = [];
  List<String> addonsheadings = [];
  List<String> addonsvalues = [];
  List<String> starsvalue = [];

  final List<String> _imageUrls = [];
  DateTime? selectedDate = DateTime.now();
  Map<String, dynamic> events = {};
  bool type = false;
  bool ischange = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    entryTime = DateTime.now(); // added-Store entry time when user opens page
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (!ischange) {
      setState(() {
        listingId = args['id'];
        type = args['isBusiness'];
        ischange = true; // Prevents multiple API calls
      });
      ApiCall.fetchAPI(
        'Caterer/viewpage/$listingId',
        onSuccess: (token, listing) {
          if (mounted) {
            setState(() {
              this.token = token;
              this.listing = listing;
              ApiCall.updateListingDetails(
                listing: listing,
                updateState: (isLoading, ischange) {
                  setState(() {
                    this.isLoading = isLoading;
                    this.ischange = ischange;
                  });
                },
                imageUrls: _imageUrls,
                addonsheadings: addonsheadings,
                addonsvalues: addonsvalues,
                values: values,
                starsvalue: starsvalue,
              );
            });
          }
        },
        onError: () {
          if (mounted) {
            MyScaffold(text: 'Something Went Wrong!').show(context);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    if (entryTime != null) {
      DateTime exitTime = DateTime.now();
      int timeSpent = exitTime.difference(entryTime!).inSeconds;
      logUserActivity("category_view_duration", {
        "category": "Caterers",
        "listing_id": listingId ?? 0,
        "time_spent_seconds": timeSpent
      });
    }
    super.dispose();
  }

  // added-Function to log time spent
  // Future<void> logTimeSpent(int listingId, int timeSpent) async {
  //   final response = await http.post(
  //     Uri.parse(
  //         'http://yourserver.com/api/log-activity/'), // Replace with actual Django API URL
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "user_id": 1, // Replace with actual user ID
  //       "action": "category_view_duration",
  //       "metadata": {
  //         "category": "Venue",
  //         "listing_id": listingId,
  //         "time_spent_seconds": timeSpent
  //       }
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //      //print("Category view duration logged successfully");
  //   } else {
  //
  //   print("Failed to log category view duration: ${response.body}");
  //   }
  // }
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  Future<void> logUserActivity(
      String action, Map<String, dynamic> metadata) async {
    String? userId =
        await MyStorage.getToken(MyTokens.userId); // Get user ID dynamically

    if (userId == null) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'User ID not found. Skipping activity log'});
      return;
    }

    final response = await MyApi.postRequest(
      endpoint: 'log-user-activity/',
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      body: {
        "user_id": int.parse(userId), // Ensure user ID is an integer
        "action": action,
        "metadata": metadata,
      },
    );

    if (!(response != null && response['status'] == 'success')) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Failed to log activity: ${response?['message']}'});
    }
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: _headerHeight),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
                      ))
                    : Column(
                        children: [
                          ImageSliderCategory(
                            imageUrls: _imageUrls,
                          ),
                          Container(
                            width: Screen.width(context),
                            color: MyColors.Dark,
                            padding: EdgeInsets.symmetric(
                              horizontal: Screen.width(context) * 0.04,
                              vertical: Screen.height(context) * 0.01,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UpperHeadings(
                                    listing: listing,
                                    listingId: listingId,
                                    selectedDate: selectedDate,
                                    events: events),
                                SizedBox(
                                  height: Screen.height(context) * 0.05,
                                  child: Center(
                                      child: MyDivider(
                                    width: Screen.width(context) * 0.85,
                                  )),
                                ),
                                PricingSection(listing: listing),
                                DescriptionCategory(listing: listing),
                                CategoryDetails(
                                    listing: listing,
                                    headings: headings,
                                    values: values),
                                CategoryAddons(
                                  listing: listing,
                                ),
                                CategoryPackages(listing: listing),
                                CategoryReview(
                                    listing: listing, starsvalue: starsvalue),
                                SizedBox(
                                  height: Screen.height(context) * 0.05,
                                  child: Center(
                                      child: MyDivider(
                                    width: Screen.width(context) * 0.85,
                                  )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Screen.height(context) * 0.03),
                                  child: Center(
                                      child: ColoredButton(
                                    text: 'Book Caterer',
                                    onPressed: () async {
                                      await logUserActivity("book_caterer",
                                          {"listing_id": listingId ?? 0});

                                      MyScaffold(text: 'Booking action logged!')
                                          .show(context);
                                      Navigator.pushNamed(
                                          context, '/orderSummary',
                                          arguments: {
                                            'Name': listing['Listing']['name'],
                                            'type': listing['Listing']['type'],
                                            'price': listing['Listing']
                                                ['basicPrice'],
                                          });
                                    },
                                  )),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
          ChatIcon(),
          Positioned(
              top: 0,
              child: Header(
                key: _headerKey,
              )),
        ],
      ),
    );
  }
}
