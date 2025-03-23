import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/user_logs.dart';
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
import 'package:taqreeb/core/utils/color.dart';

class CategoryView_Photographer extends StatefulWidget {
  const CategoryView_Photographer({super.key});

  @override
  State<CategoryView_Photographer> createState() =>
      _CategoryView_PhotographerState();
}

class _CategoryView_PhotographerState extends State<CategoryView_Photographer> {
  String token = '';
  Map<String, dynamic> listing = {};
  late int? listingId;
  bool isLoading = true;
  DateTime? entryTime;

  bool isToggled = true;
  List<String> headings = [
    'portfolio Link',
  ];
  List<String> search = ['portfolioLink'];
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
  bool type = false;
  bool ischange = false;
  final List<String> _imageUrls = [];
  DateTime? selectedDate = DateTime.now();
  Map<String, dynamic> events = {};
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
    entryTime = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    setState(() {
      listingId = args['id'];
      type = args['isBusiness'];
    });
    if (!ischange) {
      ApiCall.fetchAPI(
        'Photographer/viewpage/$listingId',
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
                  searchValues: search);
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

      Logs.logUserActivity("category_view_duration", {
        "category": "Photographer",
        "listing_id": listingId ?? 0,
        "time_spent_seconds": timeSpent
      });
    }
    super.dispose();
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UI_Management.headerHeight),
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
                                  padding: EdgeInsets.only(
                                      top: Screen.height(context) * 0.03),
                                  child: Center(
                                      child: ColoredButton(
                                    text: 'Book Photographer',
                                    onPressed: () async {
                                      await Logs.logUserActivity(
                                          "book_photographer",
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
              key: headerKey,
            ),
          ),
          ChatIcon(),
        ],
      ),
    );
  }
}
