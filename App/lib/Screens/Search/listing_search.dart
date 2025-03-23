import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Inputs/c_input_location.dart';
import 'package:taqreeb/Components/Inputs/c_input_range_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/checkbox%20question.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

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
  DateTime? entryTime;

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

  Future<void> logUserActivity(
      String action, Map<String, dynamic> metadata) async {
    String? userId =
        await MyStorage.getToken(MyTokens.userId); // Fetch actual user ID

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

  Map<String, dynamic> additionalFilters = {}; // Stores dynamic filters
  Map<String, dynamic> additionalSelections = {}; // Stores user selections

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    entryTime = DateTime.now();
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
            MyScaffold(text: 'Something Went Wrong!').show(context);
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

  void fetchAdditionalFilters(String categoryType) async {
    setState(() {
      isLoading = true;
    });
    final response = await MyApi.getRequest(
      endpoint: 'getListingDetails/$categoryType',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response != null && response['fields'] != null) {
      setState(() {
        additionalFilters = {
          for (var field in response['fields'])
            if (field['choices'] != null && field['choices'].isNotEmpty)
              field['name']: field['choices'],
        };

        additionalSelections = {
          for (var field in additionalFilters.keys) field: []
        };
        isLoading = false;
      });
    } else {
      MyScaffold(text: 'Failed to fetch additional filters!').show(context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (entryTime != null) {
      DateTime exitTime = DateTime.now();
      int timeSpent = exitTime.difference(entryTime!).inSeconds;

      logUserActivity(
          "search_page_view_duration", {"time_spent_seconds": timeSpent});
    }
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
      if (listing['pictures'][i].length != 0) {
        if (listing['pictures'][i][0]['listingId'] == listingid) {
          return listing['pictures'][i][0]['picturePath'];
        }
      } else {
        return '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: _headerHeight),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MyColors.white,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: Screen.max(context) * 0.05,
                              ),
                              child: SizedBox(
                                width: Screen.width(context) * 0.9,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SearchBox(
                                      onclick: () {},
                                      hint: 'Start typing to search',
                                      controller: searchController,
                                      width: Screen.width(context) * 0.75,
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
                                        if (value.isNotEmpty) {
                                          logUserActivity("search",
                                              {"search_query": value});
                                        }
                                      },
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              _showFilterPopup(context),
                                          icon: Icon(
                                            Icons.tune,
                                            size: Screen.max(context) * 0.03,
                                            color: MyColors.white,
                                          ),
                                        ),
                                        // Additional Filters Icon
                                        if (appliedFilters.contains("Category"))
                                          IconButton(
                                            onPressed: () =>
                                                _showAdditionalFilterPopup(
                                                    context),
                                            icon: Icon(
                                              Icons.filter_alt,
                                              size: Screen.max(context) * 0.03,
                                              color: MyColors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (appliedFilters.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(
                                    top: Screen.max(context) * 0.02),
                                width: Screen.width(context) * 0.9,
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
                              width: Screen.width(context) * 0.9,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  String serviceName =
                                      templistings['HomeListing'][index]
                                          ['name'];
                                  int serviceId =
                                      templistings['HomeListing'][index]['id'];

                                  return GestureDetector(
                                    onTap: () {
                                      logUserActivity("service_click", {
                                        "service_id": serviceId,
                                        "service_name": serviceName
                                      });

                                      // Store entry time when user starts viewing service
                                      DateTime entryTime = DateTime.now();

                                      Navigator.pushNamed(
                                        context,
                                        '/SearchServiceDetails',
                                        arguments: {
                                          "id": serviceId,
                                          "service_name": serviceName,
                                          "entry_time":
                                              entryTime.toIso8601String(),
                                        },
                                      ).then((_) {
                                        DateTime exitTime = DateTime.now();
                                        int duration = exitTime
                                            .difference(entryTime)
                                            .inSeconds;

                                        logUserActivity(
                                            "service_view_duration", {
                                          "service_id": serviceId,
                                          "service_name": serviceName,
                                          "duration_seconds": duration
                                        });
                                      });
                                    },
                                    child: Productcard(
                                      listingType: templistings['HomeListing']
                                              [index]['type']
                                          .toString(),
                                      listingid: templistings['HomeListing']
                                              [index]['id']
                                          .toString(),
                                      imageUrl: searchListingPicture(
                                                  templistings['HomeListing']
                                                      [index]['id'],
                                                  templistings) ==
                                              ""
                                          ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                                          : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${searchListingPicture(templistings['HomeListing'][index]['id'], templistings)}',
                                      venueName: templistings['HomeListing']
                                          [index]['name'],
                                      location: templistings['HomeListing']
                                          [index]['location'],
                                      type: templistings['HomeListing'][index]
                                              ['type']
                                          .toString(),
                                    ),
                                  );
                                },
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
            ),
          ),
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
          fetchAdditionalFilters(categoryController.selections[0]);
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
            padding: EdgeInsets.all(Screen.max(context) * 0.02),
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: Screen.max(context) * 0.8,
            ),
            decoration: BoxDecoration(
              color: MyColors.DarkLighter,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Screen.max(context) * 0.05),
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
                      fontSize: Screen.max(context) * 0.03,
                      fontWeight: FontWeight.bold,
                      color: MyColors.red,
                    ),
                  ),
                  Text('Pricing',
                      style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.02,
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
                        fontSize: Screen.max(context) * 0.02,
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
                        fontSize: Screen.max(context) * 0.02,
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
                        logUserActivity("category_click",
                            {"selected_category": selections});
                      }),
                  Text('Location',
                      style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.02,
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
                        fontSize: Screen.max(context) * 0.02,
                        fontWeight: FontWeight.w500,
                        color: MyColors.Yellow,
                      )),
                  DateQuestion(question: "", valuecontroller: dateController),
                  ColoredButton(
                    text: 'Apply Filters',
                    onPressed: () {
                      setState(() {
                        appliedFilters.clear();
                        FiltertoApply.forEach((filter) {
                          appliedFilters.add(filter);
                        });
                      });

                      // ✅ Create metadata object with actual filter values
                      Map<String, dynamic> filterData = {
                        "applied_filters": appliedFilters,
                        "filter_values": {} // Stores values for each filter
                      };

                      // 🏷️ Add Ratings filter values
                      if (appliedFilters.contains("Ratings")) {
                        filterData["filter_values"]["Ratings"] =
                            ratingController.selections;
                      }

                      // 🏷️ Add Category filter values
                      if (appliedFilters.contains("Category")) {
                        filterData["filter_values"]["Category"] =
                            categoryController.selections;
                      }

                      // 🏷️ Add Price Range filter values
                      if (appliedFilters.contains("Price")) {
                        filterData["filter_values"]["Price"] = {
                          "min": rangeSliderController.minValue,
                          "max": rangeSliderController.maxValue
                        };
                      }

                      // 🏷️ Add Location filter values
                      if (appliedFilters.contains("Location")) {
                        filterData["filter_values"]["Location"] =
                            locationcontroller.text;
                      }

                      // 🏷️ Add Date filter values
                      if (appliedFilters.contains("Date")) {
                        filterData["filter_values"]["Date"] =
                            dateController.text;
                      }

                      // ✅ Log filter application with values
                      logUserActivity("filter", filterData);

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

// Method to Show Additional Filters Popup
  void _showAdditionalFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.Dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Filters',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.Yellow,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: additionalFilters.entries.map((entry) {
                        String fieldName = entry.key;
                        List<String> choices =
                            entry.value.cast<String>().toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fieldName,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MyColors.Yellow,
                              ),
                            ),
                            CheckBoxQuestion(
                              question: '',
                              options: choices,
                              controller: CheckBoxController(
                                selections: additionalSelections[fieldName]
                                    .cast<String>()
                                    .toList(),
                              ),
                              onChanged: (selections) {
                                setState(() {
                                  additionalSelections[fieldName] = selections;
                                });
                              },
                            ),
                            Divider(color: MyColors.whiteDarker),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  ColoredButton(
                    text: 'Apply Filters',
                    onPressed: () {
                      setState(() {
                        searchwithFilters();
                      });
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
