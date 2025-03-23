import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_slot.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryView_Venue extends StatefulWidget {
  const CategoryView_Venue({super.key});

  @override
  State<CategoryView_Venue> createState() => _CategoryView_VenueState();
}

class _CategoryView_VenueState extends State<CategoryView_Venue> {
  String token = '';
  Map<String, dynamic> listing = {};
  late int? listingId;
  bool isLoading = true;
  DateTime? entryTime; //added

  List<String> headings = ['Venue Type', 'Catering', 'Staff', 'Guests'];
  List<String> values = [];
  List<String> addonsheadings = [];
  List<String> addonsvalues = [];
  DateTime? selectedDate = DateTime.now();
  Map<String, dynamic> events = {};
  List<String> starsvalue = [];

  final List<String> _imageUrls = [];
  bool type = false;
  bool ischange = false;
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
      fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    entryTime = DateTime.now(); // added-Store entry time when user opens page
  }

  Timer? timer;
  void fetchData() async {
    ischange = true;
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final listing = await MyApi.getRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint: 'venueviewpage/${this.listingId}');

    final events = await MyApi.getRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint:
            'YourEvents/functions/${await MyStorage.getToken(MyTokens.userId)}');
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.listing = listing ?? {};
          this.events = events ?? {};
          if (listing == null ||
              listing['status'] == 'error' ||
              events == null ||
              events['status'] == 'error') {
            MyScaffold(text: 'Something Went Wrong!').show(context);
            return;
          } else {
            isLoading = false;
            ischange = true;
            for (var i = 0; i < listing['pictures'].length; i++) {
              if (listing['pictures'][i]['picturePath'] != " ") {
                this._imageUrls.add(listing['pictures'][i]['picturePath']);
              } else {
                this._imageUrls.add(
                    "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300");
              }
            }
            for (var i = 0; i < listing['Addons'].length; i++) {
              this.addonsheadings.add(listing['Addons'][i]['name']);
              if (listing['Addons'][i]['isPer']) {
                this.addonsvalues.add(
                    '${listing['Addons'][i]['price'].toString()}/${listing['Addons'][i]['perType'].toString()}');
              } else {
                this.addonsvalues.add(listing['Addons'][i]['price'].toString());
              }
            }
            this.values.add(listing['VenueView']['venueType']);
            this.values.add(listing['VenueView']['catering']);
            this.values.add(listing['VenueView']['staff']);
            this.values.add(
                '${listing['VenueView']['guestminAllowed'].toString()}-${listing['VenueView']['guestmaxAllowed'].toString()}');
            this.starsvalue.add('(${listing['reveiewData']['5'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['4'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['3'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['2'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['1'].toString()})');

            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    if (entryTime != null) {
      DateTime exitTime = DateTime.now();
      int timeSpent = exitTime.difference(entryTime!).inSeconds;

      logUserActivity("category_view_duration", {
        "category": "Venue",
        "listing_id": listingId ?? 0,
        "time_spent_seconds": timeSpent
      });
    }
    timer?.cancel();
    super.dispose();
  }

  // added-Function to log time spent
  //Future<void> logTimeSpent(int listingId, int timeSpent) async {
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
  //
  //  print("Category view duration logged successfully");
  //   } else {
  //
  // print("Failed to log category view duration: ${response.body}");
  //   }
  //}

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
        await MyStorage.getToken(MyTokens.userId); // Get actual user ID

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
        "user_id": int.parse(userId), // Convert user ID to integer
        "action": action,
        "metadata": metadata,
      },
    );

    if (!(response != null && response['status'] == 'success')) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Failed to log activity: ${response['message']}'});
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
                                CategorySlots(
                                  listing: listing,
                                  onDateSelected: (date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: Screen.height(context) * 0.05,
                                  child: Center(
                                      child: MyDivider(
                                    width: Screen.width(context) * 0.85,
                                  )),
                                ),
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
                                  padding:
                                      EdgeInsets.only(top: Screen.height(context) * 0.03),
                                  child: Center(
                                      child: ColoredButton(
                                    text: 'Book Venue',
                                    onPressed: () async {
                                      await logUserActivity("book_venue",
                                          {"listing_id": listingId ?? 0});
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
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
            ),
          ),
          ChatIcon(),
        ],
      ),
    );
  }
}
