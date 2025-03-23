import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Home%20Page/c_image_slider.dart';
import 'package:taqreeb/Components/Home%20Page/c_category_icon.dart';
import 'dart:math';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/user_logs.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> categories = {};
  Map<String, dynamic> listings = {};
  Map<String, dynamic> demoImages = {};
  String token = '';
  bool isLoading = true;
  List<String> myImages = [];
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
    fetchData();
  }

  void fetchData() async {
    await ApiCall.fetchAPI('home/categories/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          categories = data;
        });
      }
    }, context: mounted?context:null);
    await ApiCall.fetchAPI('Homepage/DemoImages/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          demoImages = data;
        });
      }
    }, context: mounted?context:null);
    await ApiCall.fetchAPI('home/listings/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          listings = data;
          loadimages();
        });
      }
    }, context: mounted?context:null);
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadimages() async {
    myImages = await demoImages['images']
        .map((value) =>
            '${MyApi.baseUrl.toString().substring(0, MyApi.baseUrl.toString().length - 1)}${value["image"]}')
        .cast<String>()
        .toList();
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  // Future<void> Logs.logUserActivity(
  //     int userId, String action, Map<String, dynamic> metadata) async {
  //   final response = await http.post(
  //     Uri.parse(
  //         'http://yourserver.com/api/log-activity/'), // Replace with actual Django API URL
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "user_id": userId,
  //       "action": action,
  //       "metadata": metadata,
  //     }),
  //   );

  //     if (response.statusCode == 201) {
  //
  //   print("Activity logged successfully: $action");
  //     } else {
  //
  //   print("Failed to log activity: ${response.body}");
  //     }
  //   //
  //   print("User ID: $userId");
  //   //
  //   print("Action: $action");
  //   //
  //   print("Metadata: $metadata");
  // }

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
          if (UI_Management.headerHeight > 0)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: UI_Management.headerHeight),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: Screen.height(context) * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SearchBox(
                          onChanged: (value) {},
                          hint: 'Start Typing to Search',
                          onclick: () {
                            if (_searchController.text.isNotEmpty) {
                              Logs.logUserActivity("search",
                                  {"search_query": _searchController.text});
                            }
                            Navigator.pushNamed(context, '/SearchService');
                          },
                          controller: _searchController,
                          width: Screen.width(context) * 0.9,
                        ),
                      ],
                    ),
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(MyColors.white),
                          ),
                        )
                      : Column(
                          children: [
                            Column(
                              children: [
                                Center(
                                  child: AutoImageSlider(
                                    imageUrls: this.myImages,
                                    height: Screen.height(context) * 0.25,
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: Screen.width(context) * 0.95,
                                    margin: EdgeInsets.symmetric(
                                        vertical:
                                            Screen.height(context) * 0.015),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Browse Categories',
                                          style: GoogleFonts.montserrat(
                                            fontSize:
                                                Screen.max(context) * 0.02,
                                            fontWeight: FontWeight.w600,
                                            color: MyColors.Yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Screen.height(context) * 0.19,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      String categoryName =
                                          categories['categories'][index]
                                              ['name'];
                                      return CategoryIcon(
                                        onpressed: () {
                                          Logs.logUserActivity("category_click",
                                              {"category": categoryName});
                                          Navigator.pushNamed(
                                              context, '/SearchService',
                                              arguments: {
                                                'category':
                                                    categories['categories']
                                                        [index]['name'],
                                              });
                                        },
                                        label: categories['categories'][index]
                                            ['name'],
                                        imageUrl:
                                            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${categories['categories'][index]['picture']}',
                                      );
                                    },
                                    itemCount: categories['categories'].length,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: ColoredButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/CreateAIPackage');
                                },
                                text: 'Create Package with AI',
                              ),
                            ),
                            Center(
                              child: Container(
                                width: Screen.width(context) * 0.95,
                                margin: EdgeInsets.symmetric(
                                    vertical: Screen.height(context) * 0.015),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'For You',
                                      style: GoogleFonts.montserrat(
                                        fontSize: Screen.max(context) * 0.02,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: Screen.width(context) * 0.9,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listings['HomeListing'].length > 10
                                      ? 10
                                      : listings['HomeListing'].length,
                                  itemBuilder: (context, index) {
                                    String serviceName =
                                        listings['HomeListing'][index]['name'];
                                    int serviceId =
                                        listings['HomeListing'][index]['id'];
                                    return GestureDetector(
                                        onTap: () {
                                          Logs.logUserActivity(
                                              "service_click", {
                                            "service_id": serviceId,
                                            "service_name": serviceName
                                          });

                                          DateTime entryTime = DateTime.now();
                                          Navigator.pushNamed(
                                              context, '/ServiceDetails',
                                              arguments: {
                                                "id": serviceId,
                                                "service_name": serviceName,
                                                "entry_time":
                                                    entryTime.toIso8601String(),
                                              });
                                        },
                                        child: Productcard(
                                          listingType: listings['HomeListing']
                                                  [index]['type']
                                              .toString(),
                                          listingid: listings['HomeListing']
                                                  [index]['id']
                                              .toString(),
                                          imageUrl: listings['pictures'][index]
                                                      .length !=
                                                  0
                                              ? (listings['pictures'][index][0]
                                                          ['picturePath'] ==
                                                      " "
                                                  ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                                                  : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listings['pictures'][index][0]['picturePath']}')
                                              : "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300",
                                          venueName: listings['HomeListing']
                                              [index]['name'],
                                          location: listings['HomeListing']
                                              [index]['location'],
                                          type: listings['HomeListing'][index]
                                                  ['type']
                                              .toString(),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          Positioned(
              top: 0,
              child: Header(
                key: headerKey,
              )),
        ],
      ),
    );
  }
}
