import 'dart:async';
import 'package:flutter/material.dart';
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
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryView_Decorator extends StatefulWidget {
  const CategoryView_Decorator({super.key});

  @override
  State<CategoryView_Decorator> createState() => _CategoryView_DecoratorState();
}

class _CategoryView_DecoratorState extends State<CategoryView_Decorator> {
  String token = '';
  Map<String, dynamic> listing = {};
  late int? listingId;
  bool isLoading = true;
  DateTime? entryTime; //added

  bool isToggled = true;
  List<String> headings = [
    'Decor Type',
    'Catering',
    'Staff',
  ];
  List<String> values = [];
  List<String> addonsheadings = [];
  List<String> addonsvalues = [];
  List<String> stars = [
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Stars',
  ];
  List<String> starsvalue = [];

  final List<String> _imageUrls = [];
  DateTime? selectedDate = DateTime.now();
  Map<String, dynamic> events = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    entryTime = DateTime.now(); // added-Store entry time when user opens page
  }

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

  Timer? timer;
  void fetchData() async {
    ischange = true;
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final listing = await MyApi.getRequest(
      endpoint: 'decorator/detail/${this.listingId}',
      headers: {'Authorization': 'Bearer $token'},
    );

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.listing = listing ?? {};
          if (listing == null || listing['status'] == 'error') {
            MyScaffold(text: 'Something Went Wrong!').show(context);
            return;
          } else {
            isLoading = false;
            for (var i = 0; i < listing['pictures'].length; i++) {
              this._imageUrls.add(listing['pictures'][i]['picturePath']);
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
            this.values.add(listing['View']['decorType']);
            this.values.add(listing['View']['catering']);
            this.values.add(listing['View']['staff']);
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
        "category": "Decorator",
        "listing_id": listingId ?? 0,
        "time_spent_seconds": timeSpent
      });
    }
    timer?.cancel();
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
  //
//  MyApi.postRequest(
//           endpoint: 'error/application',
//           body: {'error': 'Error: $e'});
//     print("Category view duration logged successfully");
//   //   } else {
  //
  //   print("Failed to log category view duration: ${response.body}");
  //   }
  // }
  void showHierarchicalOptions(
      BuildContext context, double maxThing, double width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.Dark,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(maxThing * 0.02),
          decoration: BoxDecoration(
            color: MyColors.Dark,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(maxThing * 0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: maxThing * 0.02),
                child: Text(
                  "Choose for a Function",
                  style: GoogleFonts.montserrat(
                    fontSize: maxThing * 0.025,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: events['Event']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final event = events['Event'][index];
                    return Container(
                      margin: EdgeInsets.only(bottom: maxThing * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: MyColors.red,
                        ),
                        color: MyColors.DarkLighter,
                      ),
                      child: ExpansionTile(
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: MyColors.red,
                        collapsedBackgroundColor: MyColors.DarkLighter,
                        title: Text(
                          event['name'],
                          style: GoogleFonts.montserrat(
                            fontSize: maxThing * 0.015,
                            fontWeight: FontWeight.w400,
                            color: MyColors.white,
                          ),
                        ),
                        children: [
                          ...event['functions'].map<Widget>((function) {
                            return ListTile(
                              title: Text(
                                function['name'],
                                style: GoogleFonts.montserrat(
                                  fontSize: maxThing * 0.015,
                                  color: MyColors.whiteDarker,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onTap: () async {
                                final response = await MyApi.postRequest(
                                    headers: {'Authorization': 'Bearer $token'},
                                    endpoint: 'add/Bookcart/',
                                    body: {
                                      'fid': function['id'].toString(),
                                      'uid': await MyStorage.getToken(
                                              MyTokens.userId) ??
                                          "",
                                      'lid': listingId.toString(),
                                      'type': 'Decorator',
                                      'slot': selectedDate.toString(),
                                    });

                                if (response['status'] == 'success') {
                                  Navigator.pop(context);
                                } else {
                                  MyScaffold(text: 'Something Went Wrong!')
                                      .show(context);
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                                    text: 'Book Decorator',
                                    onPressed: () async {
                                      await logUserActivity("book_decorator",
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
