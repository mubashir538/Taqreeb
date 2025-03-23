import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Home%20Page/c_image_slider.dart';
import 'package:taqreeb/Components/Home%20Page/c_category_icon.dart';
import 'dart:math';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    fetchData();
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final fetchedCategories = await MyApi.getRequest(
      endpoint: 'home/categories/',
      headers: {'Authorization': 'Bearer $token'},
    );

    final fetchedImages = await MyApi.getRequest(
      endpoint: 'Homepage/DemoImages/',
      headers: {'Authorization': 'Bearer $token'},
    );
    final fetchedListings = await MyApi.getRequest(
      endpoint: 'home/listings/',
      headers: {'Authorization': 'Bearer $token'},
    );

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.categories = fetchedCategories ?? {};
          this.listings = fetchedListings ?? {};
          this.demoImages = fetchedImages ?? {};
          if (fetchedCategories == null ||
              fetchedCategories['status'] == 'error' ||
              fetchedListings == null ||
              fetchedListings['status'] == 'error' ||
              fetchedImages == null ||
              fetchedImages['status'] == 'error') {
            MyScaffold(text: 'Something Went Wrong!').show(context);
            return;
          } else {
            loadimages();
            isLoading = false;
          }
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void loadimages() async {
    this.myImages = await demoImages['images']
        .map((value) =>
            '${MyApi.baseUrl.toString().substring(0, MyApi.baseUrl.toString().length - 1)}${value["image"]}')
        .cast<String>()
        .toList();
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
        await MyStorage.getToken(MyTokens.userId); // Fetch actual user ID

    if (userId == null) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'User ID not found. Skipping activity log'});
      return;
    }

    final response = await MyApi.postRequest(
      endpoint: 'log-user-activity/', // Ensure this matches Django API URL
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

  // Future<void> logUserActivity(
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
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          if (_headerHeight > 0)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: _headerHeight),
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
                              logUserActivity("search",
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
                                          logUserActivity("category_click",
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
                                          logUserActivity("service_click", {
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
                key: _headerKey,
              )),
        ],
      ),
    );
  }
}
