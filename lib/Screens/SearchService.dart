import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/locationtextbox.dart';
import 'package:taqreeb/Components/rangeSlider.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Screens/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/For%20Fyp2/Create%20AI%20Package/Components/checkbox%20question.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class SearchService extends StatefulWidget {
  const SearchService({super.key});

  @override
  State<SearchService> createState() => _SearchServiceState();
}

class _SearchServiceState extends State<SearchService> {
  List<Map<String, dynamic>> searchResults = [];
  final TextEditingController searchController = TextEditingController();
  final List<String> appliedFilters = [];
  final List<String> FiltertoApply = [];

  RangeSliderController rangeSliderController = RangeSliderController(
    minValue: 10000,
    maxValue: 5000000,
  );
  final CheckBoxController ratingController =
      CheckBoxController(selections: []);

  final CheckBoxController categoryController =
      CheckBoxController(selections: []);
  TextEditingController locationcontroller = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String token = '';
  Map<String, dynamic> categories = {};
  Map<String, dynamic> listings = {};
  bool isLoading = true;
  Map<String, dynamic> templistings = {};
  Map<String, dynamic> args = {};
  ScrollController _scrollController = ScrollController();
  bool ischange = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (!ischange) {
      if (args != null) {
        this.args = args as Map<String, dynamic>;
      }
      fetchData();
    }
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final fetchedCategories = await MyApi.getRequest(
      endpoint: 'home/categories/',
      headers: {'Authorization': 'Bearer $token'},
    );

    final fetchedListings = await MyApi.getRequest(
        endpoint: 'home/listings/',
        headers: {'Authorization': 'Bearer $token'});

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.categories = fetchedCategories ?? {};
          this.listings = fetchedListings ?? {};
          this.templistings = Map.from(fetchedListings);
          if (this.listings == {} ||
              this.listings['status'] == 'error' ||
              this.categories == {} ||
              this.categories['status'] == 'error') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Something Went Wrong!',
                  style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: MyColors.white,
                      fontWeight: FontWeight.w400)),
              backgroundColor: MyColors.red,
            ));
          } else {
            if (this.args.isNotEmpty) {
              appliedFilters.add('Category');
              categoryController.selections.add(this.args['category']);
              searchwithFilters();
            }

            isLoading = false;
          }
        });
        timer.cancel();
      }
    });
    ischange = true;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  String searchListingPicture(int listingid, Map<String, dynamic> listing) {
    for (int i = 0; i < listing['pictures'].length; i++) {
      if (listing['pictures'][i][0]['listingId'] == listingid) {
        return listing['pictures'][i][0]['picturePath'];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: _headerHeight),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(MyColors.white),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: maximumDimension * 0.05,
                              ),
                              child: SizedBox(
                                width: screenWidth * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SearchBox(
                                      onclick: () {},
                                      hint: 'Start typing to search',
                                      controller: searchController,
                                      width: screenWidth * 0.75,
                                      onChanged: (value) {
                                        setState(() {
                                          searchwithFilters();
                                          templistings['HomeListing'] =
                                              templistings['HomeListing']
                                                  .where((element) =>
                                                      element['name']
                                                          .toString()
                                                          .toLowerCase()
                                                          .contains(value
                                                              .toLowerCase()))
                                                  .toList();
                                        });
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _showFilterPopup(context),
                                      icon: Icon(
                                        Icons.tune,
                                        size: maximumDimension * 0.03,
                                        color: MyColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (appliedFilters.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(
                                    top: maximumDimension * 0.02),
                                width: screenWidth * 0.9,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: appliedFilters.map((filter) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: MyColors.whiteDarker,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              filter,
                                              style: GoogleFonts.montserrat(
                                                color: MyColors.Dark,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  appliedFilters.remove(filter);
                                                  searchwithFilters();
                                                });
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: MyColors.Dark,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: screenWidth * 0.9,
                              child: ListView.builder(
                                itemBuilder: (context, index) => Productcard(
                                  listingType: templistings['HomeListing']
                                          [index]['type']
                                      .toString(),
                                  listingid: templistings['HomeListing'][index]
                                          ['id']
                                      .toString(),
                                  imageUrl: searchListingPicture(
                                              templistings['HomeListing'][index]
                                                  ['id'],
                                              templistings) ==
                                          ""
                                      ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                                      : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${searchListingPicture(templistings['HomeListing'][index]['id'], templistings)}',
                                  venueName: templistings['HomeListing'][index]
                                      ['name'],
                                  location: templistings['HomeListing'][index]
                                      ['location'],
                                  type: templistings['HomeListing'][index]
                                          ['type']
                                      .toString(),
                                ),
                                itemCount: templistings['HomeListing'].length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              child: Header(
                key: _headerKey,
              )),
        ],
      ),
    );
  }

  void searchwithFilters() {
    templistings['HomeListing'] = List.from(listings['HomeListing']);
    setState(() {
      for (String i in appliedFilters) {
        if (i == "Price") {
          templistings['HomeListing'] = templistings['HomeListing']
              .where((element) =>
                  element['basicPrice'] >= rangeSliderController.minValue &&
                  element['basicPrice'] <= rangeSliderController.maxValue)
              .toList();
        } else {
          rangeSliderController.minValue = 10000;
          rangeSliderController.maxValue = 5000000;
        }
        if (i == "Ratings") {
          templistings['HomeListing'] = templistings['HomeListing']
              .where((element) =>
                  ratingController.selections.contains(element['rating']))
              .toList();
        }
        if (i == "Category") {
          templistings['HomeListing'] = templistings['HomeListing']
              .where((element) =>
                  categoryController.selections.contains(element['type']))
              .toList();
        }
        if (i == "Location") {
          templistings['HomeListing'] = templistings['HomeListing']
              .where((element) => element['location']
                  .toLowerCase()
                  .contains(locationcontroller.text.toLowerCase()))
              .toList();
        }
        // if (i == "Date") {
        //   templistings['HomeListing'] = templistings['HomeListing']
        //       .where((element) => element['date'].toLowerCase().contains(dateController.text.toLowerCase()))
        //       .toList();
        // }
      }
    });
  }

  void _showFilterPopup(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LayoutBuilder(builder: (builder, constraints) {
          double keyboard = MediaQuery.of(context).viewInsets.bottom;
          bool isKeyboardVisible = keyboard > 0;
          if (isKeyboardVisible && _scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
          return Container(
            padding: EdgeInsets.all(maximumDimension * 0.02),
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: maximumDimension * 0.8,
            ),
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(maximumDimension * 0.05),
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Filter Options",
                    style: GoogleFonts.montserrat(
                      fontSize: maximumDimension * 0.03,
                      fontWeight: FontWeight.bold,
                      color: MyColors.red,
                    ),
                  ),
                  Text('Pricing',
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.02,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      )),
                  RangeSliderWidget(
                    start: 10000,
                    end: 5000000,
                    divisions: 500,
                    controller: rangeSliderController,
                    onChanged: (min, max) {
                      if (!FiltertoApply.contains("Price")) {
                        FiltertoApply.add("Price");
                      }
                    },
                  ),
                  Text('Ratings',
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.02,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      )),
                  CheckBoxQuestion(
                      question: '',
                      options: [
                        '5 Stars',
                        '4 Stars',
                        '3 Stars',
                        '2 Stars',
                        '1 Stars',
                      ],
                      controller: ratingController,
                      onChanged: (selections) {
                        if (!FiltertoApply.contains("Ratings")) {
                          FiltertoApply.add("Ratings");
                        }
                      }),
                  Text('Category',
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.02,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      )),
                  CheckBoxQuestion(
                      question: '',
                      options: isLoading
                          ? []
                          : categories['categories']
                              .map((value) {
                                return value['name'].toString();
                              })
                              .cast<String>()
                              .toList(),
                      controller: categoryController,
                      onChanged: (selections) {
                        if (!FiltertoApply.contains("Category")) {
                          FiltertoApply.add("Category");
                        }
                      }),
                  Text('Location',
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.02,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      )),
                  LocationInputWidget(
                    locationController: locationcontroller,
                    onLocationChanged: (location) {
                      if (!FiltertoApply.contains("Location")) {
                        FiltertoApply.add("Location");
                      }
                    },
                  ),
                  Text('Date',
                      style: GoogleFonts.montserrat(
                        fontSize: maximumDimension * 0.02,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      )),
                  DateQuestion(question: "", valuecontroller: dateController),
                  ColoredButton(
                    text: 'Apply Filters',
                    onPressed: () {
                      setState(() {
                        if (dateController.text.isNotEmpty) {
                          appliedFilters.add("Date");
                        }
                        for (String i in FiltertoApply) {
                          appliedFilters.add(i);
                        }
                      });
                      Navigator.pop(context);
                      searchwithFilters();
                    },
                  ),
                  SizedBox(height: keyboard),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
