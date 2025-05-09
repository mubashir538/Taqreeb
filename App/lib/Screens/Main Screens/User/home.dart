import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Home%20Page/c_image_slider.dart';
import 'package:taqreeb/Components/Home%20Page/c_category_icon.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/user_logs.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

DateTime? entryTime; // ⏱️ Track view duration

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  Map<String, dynamic> categories = {};
  Map<String, dynamic> listings = {};
  Map<String, dynamic> demoImages = {};
  bool _isLoading = true;
  List<String> _myImages = [];
  GlobalKey headerKey = GlobalKey();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    entryTime = DateTime.now();
    _initializeHeaderHeight();
    _fetchData();
  }

  void _initializeHeaderHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          _changeHeight(renderbox);
        },
      );
    });
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchCategories(),
      _fetchDemoImages(),
      _fetchListings(),
    ]);

    if (mounted) {
      setState(() {
        if (listings.isEmpty || categories.isEmpty || demoImages.isEmpty) {
          return;
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCategories() async {
    await ApiCall.fetchAPI('home/categories/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          categories = data;
        });
      }
    }, context: mounted ? context : null);
  }

  Future<void> _fetchDemoImages() async {
    await ApiCall.fetchAPI('Homepage/DemoImages/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          demoImages = data;
          _loadImages();
        });
      }
    }, context: mounted ? context : null);
  }

  Future<void> _fetchListings() async {
    await ApiCall.fetchAPI('home/listings/?page=1&page_size=10',
        onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          listings = data['results'];
        });
      }
    }, context: mounted ? context : null);
  }

  void _loadImages() {
    _myImages = demoImages['images']
        .map((value) =>
            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${value["image"]}')
        .cast<String>()
        .toList();
  }

  void _changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Logs.logUserActivity("search", {"search_query": query});
    }
    Navigator.pushNamed(context, '/SearchService');
  }

  void _handleCategoryClick(String categoryName) {
    Logs.logUserActivity("category_click", {"category": categoryName});
    Navigator.pushNamed(
      context,
      '/SearchService',
      arguments: {'category': categoryName},
    );
  }

  void _handleServiceClick(int serviceId, String serviceName) {
    Logs.logUserActivity("service_click", {
      "service_id": serviceId,
      "service_name": serviceName,
    });

    Navigator.pushNamed(
      context,
      '/ServiceDetails',
      arguments: {
        "id": serviceId,
        "service_name": serviceName,
        "entry_time": DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: headerKey,
      callback: (renderbox) {
        _changeHeight(renderbox);
      },
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          if (UImanagement.headerHeight > 0)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: UImanagement.headerHeight),
                  _buildSearchBox(),
                  _isLoading
                      ? _buildLoadingIndicator()
                      : Column(
                          children: [
                            _buildImageSlider(),
                            _buildCategorySection(),
                            _buildAIPackageButton(),
                            _buildForYouSection(),
                          ],
                        ),
                ],
              ),
            ),
          Positioned(
            top: 0,
            child: Header(key: headerKey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SearchBox(
            focusNode: searchFocus,
            onChanged: (value) {},
            hint: 'Start Typing to Search',
            onclick: _handleSearch,
            controller: _searchController,
            width: Screen.width(context) * 0.9,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Center(
      child: AutoImageSlider(
        imageUrls: _myImages,
        height: Screen.height(context) * 0.25,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      children: [
        Center(
          child: Container(
            width: Screen.width(context) * 0.95,
            margin:
                EdgeInsets.symmetric(vertical: Screen.height(context) * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Browse Categories',
                  style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w600,
                    color: MyColors.yellow,
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
              final categoryName = categories['categories'][index]['name'];
              return CategoryIcon(
                onpressed: () => _handleCategoryClick(categoryName),
                label: categoryName,
                imageUrl:
                    '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${categories['categories'][index]['picture']}',
              );
            },
            itemCount: categories['categories'].length,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  Widget _buildAIPackageButton() {
    return Center(
      child: ColoredButton(
        onPressed: () {
          Logs.logUserActivity("ai_package_button_click", {});

          Navigator.pushNamed(context, '/ChatBot');
        },
        text: 'Create Package with AI',
      ),
    );
  }

  Widget _buildForYouSection() {
    return Column(
      children: [
        Center(
          child: Container(
            width: Screen.width(context) * 0.95,
            margin:
                EdgeInsets.symmetric(vertical: Screen.height(context) * 0.015),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'For You',
                  style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w600,
                    color: MyColors.yellow,
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listings['HomeListing'].length > 10
                  ? 10
                  : listings['HomeListing'].length,
              itemBuilder: (context, index) {
                final serviceName = listings['HomeListing'][index]['name'];
                final serviceId = listings['HomeListing'][index]['id'];
                final imageUrl = listings['pictures'][index].isNotEmpty
                    ? (listings['pictures'][index][0]['picturePath'] == " "
                        ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                        : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listings['pictures'][index][0]['picturePath']}')
                    : "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300";

                return GestureDetector(
                  onTap: () => _handleServiceClick(serviceId, serviceName),
                  child: Productcard(
                    listingType:
                        listings['HomeListing'][index]['type'].toString(),
                    listingid: listings['HomeListing'][index]['id'].toString(),
                    imageUrl: imageUrl,
                    venueName: serviceName,
                    location: listings['HomeListing'][index]['location'],
                    type: listings['HomeListing'][index]['type'].toString(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    if (entryTime != null) {
      final exitTime = DateTime.now();
      final duration = exitTime.difference(entryTime!).inSeconds;

      Logs.logUserActivity("homepage_view_duration", {
        "time_spent_seconds": duration,
      });
    }
    super.dispose();
  }
}
