import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Home%20Page/c_custom_tab.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Home%20Page/c_image_slider.dart';
import 'package:taqreeb/Components/Home%20Page/c_category_icon.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/c_package_box.dart';
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

DateTime? entryTime;

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _searchBoxKey = GlobalKey();
  final GlobalKey _imageSliderKey = GlobalKey();
  final GlobalKey _categorySectionKey = GlobalKey();
  final GlobalKey _aiPackageButtonKey = GlobalKey();
  final GlobalKey _contentSectionKey = GlobalKey();
  final GlobalKey _categoryIconKey = GlobalKey();

  Map<String, dynamic> categories = {};
  Map<String, dynamic> demoImages = {};

  Map<String, dynamic> listings = {
    'results': {'HomeListing': [], 'pictures': []}
  };
  Map<String, dynamic> packages = {
    'results': {'HomePackages': []}
  };
  Map<String, dynamic> products = {
    'results': {'HomeProducts': []}
  };

  bool _isLoading = true;
  bool isLoadingServices = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _currentTab = 0; 
  List<String> _myImages = [];
  GlobalKey headerKey = GlobalKey();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    entryTime = DateTime.now();
    _initializeHeaderHeight();
    _fetchInitialData();
    _scrollController.addListener(_scrollListener);
  }

  void _initializeHeaderHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          _changeHeight(renderbox);
        },
      );
      // ShowCaseWidget.of(context).startShowCase([
      //   _searchBoxKey,
      //   _imageSliderKey,
      //   _categorySectionKey,
      //   _categoryIconKey,
      //   _aiPackageButtonKey,
      //   _contentSectionKey,
      //   _listingsKey
      // ]);
    });
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _fetchCategories(),
      _fetchDemoImages(),
      _fetchTabData(resetPagination: true),
    ]);
    _isLoading = false;
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

  Future<void> _fetchTabData({bool resetPagination = false}) async {
    if (resetPagination) {
      _currentPage = 1;
    }

    setState(() {
      if (resetPagination) {
        isLoadingServices = true;
        if (_currentTab == 0) {
          listings = {
            'results': {'HomeListing': [], 'pictures': []}
          };
        } else if (_currentTab == 1) {
          packages = {
            'results': {'HomePackages': []}
          };
        } else {
          products = {
            'results': {'HomeProducts': []}
          };
        }
      } else {
        _isLoadingMore = true;
      }
    });

    String endpoint;
    if (_currentTab == 0) {
      endpoint = 'home/listings/?page=$_currentPage&page_size=10';
    } else if (_currentTab == 1) {
      endpoint = 'home/packages/?page=$_currentPage&page_size=10';
    } else {
      endpoint = 'home/products/?page=$_currentPage&page_size=10';
    }

    await ApiCall.fetchAPI(endpoint, onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          if (_currentTab == 0) {
            if (resetPagination) {
              listings = data;
            } else {
              listings['results']['HomeListing']
                  .addAll(data['results']['HomeListing']);
              listings['results']['pictures']
                  .addAll(data['results']['pictures']);
            }
          } else if (_currentTab == 1) {
            if (resetPagination) {
              packages = data;
            } else {
              packages['results']['HomePackages']
                  .addAll(data['results']['HomePackages']);
            }
          } else {
            if (resetPagination) {
              products = data;
            } else {
              products['results']['HomeProducts']
                  .addAll(data['results']['HomeProducts']);
            }
          }

          isLoadingServices = false;
          _isLoadingMore = false;
          if (!resetPagination) {
            _currentPage++;
          }
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

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchTabData();
    }
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Logs.logUserActivity("search", {"search_query": query});
    }
    context.pushNamedTransition(
        routeName: '/SearchService',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300));
  }

  void _handleCategoryClick(String categoryName) {
    Logs.logUserActivity("category_click", {"category": categoryName});

    context.pushNamedTransition(
        routeName: '/SearchService',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300),
        arguments: {'category': categoryName});
  }

  void _handleServiceClick(int serviceId, String serviceName) {
    Logs.logUserActivity("service_click", {
      "service_id": serviceId,
      "service_name": serviceName,
    });

    context.pushNamedTransition(
        routeName: '/ServiceDetails',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300),
        arguments: {
          "id": serviceId,
          "service_name": serviceName,
          "entry_time": DateTime.now().toIso8601String(),
        });
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentTab = index;
    });
    _fetchTabData(resetPagination: true);
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: headerKey,
      callback: (renderbox) {
        _changeHeight(renderbox);
      },
    );
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          if (UImanagement.headerHeight > 0)
            ShowCaseWidget(
              builder: (context) => SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: UImanagement.headerHeight),
                    Showcase(
                        key: _searchBoxKey,
                        description:
                            'Search for services, packages, or products',
                        title: 'Search',
                        targetShapeBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        targetPadding: EdgeInsets.all(8),
                        targetBorderRadius: BorderRadius.circular(8),
                        overlayColor: colors.lightDark.withOpacity(0.5),
                        child: _buildSearchBox()),
                    _isLoading
                        ? _buildSkeletonLoader()
                        : Column(
                            children: [
                              Showcase(
                                  key: _imageSliderKey,
                                  description: 'Featured images slider',
                                  title: 'Image Slider',
                                  targetShapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  targetPadding: EdgeInsets.all(8),
                                  targetBorderRadius: BorderRadius.circular(8),
                                  overlayColor:
                                      colors.lightDark.withOpacity(0.5),
                                  child: _buildImageSlider()),
                              Showcase(
                                  key: _categorySectionKey,
                                  description: 'Browse categories',
                                  title: 'Categories',
                                  targetShapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  targetPadding: EdgeInsets.all(8),
                                  targetBorderRadius: BorderRadius.circular(8),
                                  overlayColor:
                                      colors.lightDark.withOpacity(0.5),
                                  child: _buildCategorySection()),
                              Showcase(
                                  key: _aiPackageButtonKey,
                                  description: 'Create a package using AI',
                                  title: 'AI Package',
                                  targetShapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  targetPadding: EdgeInsets.all(8),
                                  targetBorderRadius: BorderRadius.circular(8),
                                  overlayColor:
                                      colors.lightDark.withOpacity(0.5),
                                  child: _buildAIPackageButton()),
                              Showcase(
                                  key: _contentSectionKey,
                                  description:
                                      'Browse listings, packages, and products',
                                  title: 'Content Section',
                                  targetShapeBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  targetPadding: EdgeInsets.all(8),
                                  targetBorderRadius: BorderRadius.circular(8),
                                  overlayColor:
                                      colors.lightDark.withOpacity(0.5),
                                  child: _buildContentSection()),
                            ],
                          ),
                    if (_isLoadingMore) _buildLoadingMoreIndicator(),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              additionalIcons: [
                HeaderIcon(
                    icon: FontAwesomeIcons.cartShopping,
                    onPressed: () {
                      context.pushNamedTransition(
                          routeName: '/CartScreen',
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 300));
                    })
              ],
            ),
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

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        _buildImageSliderSkeleton(),
        _buildCategorySectionSkeleton(),
        _buildContentSectionSkeleton(),
      ],
    );
  }

  Widget _buildImageSliderSkeleton() {
    final colors = AppColors(context);

    return Container(
      height: Screen.height(context) * 0.25,
      margin: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.05,
        vertical: Screen.height(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: colors.dark.withAlpha(123),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildCategorySectionSkeleton() {
    final colors = AppColors(context);

    return Column(
      children: [
        Container(
          width: Screen.width(context) * 0.95,
          margin: EdgeInsets.symmetric(
            vertical: Screen.height(context) * 0.015,
          ),
          child: Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              color: colors.dark.withAlpha(123),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(
          height: Screen.height(context) * 0.19,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: colors.dark.withAlpha(123),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 70,
                      decoration: BoxDecoration(
                        color: colors.dark.withAlpha(123),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentSectionSkeleton() {
    final colors = AppColors(context);

    return Column(
      children: [
        Container(
          width: Screen.width(context) * 0.9,
          height: 40,
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: colors.dark.withAlpha(123),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        SizedBox(
          width: Screen.width(context) * 0.9,
          child: Column(
            children: List.generate(3, (index) {
              return Container(
                height: 120,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.dark.withAlpha(123),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ),
      ],
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
    final colors = AppColors(context);

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
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w700,
                    color: colors.white,
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
              if (index != 0) {
                return CategoryIcon(
                  onpressed: () => _handleCategoryClick(categoryName),
                  label: categoryName,
                  imageUrl:
                      '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${categories['categories'][index]['picture']}',
                );
              } else {
                return Showcase(
                  key: _categoryIconKey,
                  description: 'Click to explore $categoryName',
                  title: 'Category',
                  targetShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  targetPadding: EdgeInsets.all(8),
                  targetBorderRadius: BorderRadius.circular(8),
                  overlayColor: colors.lightDark.withOpacity(0.5),
                  child: CategoryIcon(
                    onpressed: () => _handleCategoryClick(categoryName),
                    label: categoryName,
                    imageUrl:
                        '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${categories['categories'][index]['picture']}',
                  ),
                );
              }
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
        icon: FontAwesomeIcons.wandMagicSparkles,
        onPressed: () {
          Logs.logUserActivity("ai_package_button_click", {});
          context.pushNamedTransition(
              routeName: '/ChatBot',
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: 300));
        },
        text: 'Create Package with AI',
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      children: [
        CustomTabBar(
          tabs: const ["Listings", "Packages", "Products"],
          onTabChanged: _handleTabChange,
        ),
        isLoadingServices
            ? Container(
                height: Screen.height(context),
              )
            : Center(
                child: SizedBox(
                  width: Screen.width(context) * 0.9,
                  child: _buildContentList(),
                ),
              ),
      ],
    );
  }

  Widget _buildContentList() {
    if (_currentTab == 0) {
      return _buildListingsList();
    } else if (_currentTab == 1) {
      return _buildPackagesList();
    } else {
      return _buildProductsList();
    }
  }

  Widget _buildListingsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listings['results']['HomeListing'].length,
      itemBuilder: (context, index) {
        final serviceName = listings['results']['HomeListing'][index]['name'];
        final serviceId = listings['results']['HomeListing'][index]['id'];
        final imageUrl = listings['results']['pictures'][index].isNotEmpty
            ? (listings['results']['pictures'][index][0]['picturePath'] == " "
                ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listings['results']['pictures'][index][0]['picturePath']}')
            : "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300";

        return GestureDetector(
          onTap: () => _handleServiceClick(serviceId, serviceName),
          child: ProductCard(
            listingType:
                listings['results']['HomeListing'][index]['type'].toString(),
            listingid:
                listings['results']['HomeListing'][index]['id'].toString(),
            imageUrl: imageUrl,
            venueName: serviceName,
            rating:
                listings['results']['HomeListing'][index]['rating'].toString(),
            location: listings['results']['HomeListing'][index]['location'],
            type: listings['results']['HomeListing'][index]['type'].toString(),
          ),
        );
      },
    );
  }

  Widget _buildPackagesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages['results']['HomePackages'].length,
      itemBuilder: (context, index) {
        final package = packages['results']['HomePackages'][index];
        return GestureDetector(
          onTap: () => _handleServiceClick(package['id'], package['name']),
          child: PackageBox(
            onPressed: () {
            },
            packageId: package['id'].toString(),
            packageDetails: package['description'].toString(),
            packagePrice: package['price'].toString(),
            imageUrl: package['pictures'].length != 0
                ? package['pictures'][0]
                : "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300",
            packageName: package['name'],
          ),
        );
      },
    );
  }

  Widget _buildProductsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products['results']['HomeProducts'].length,
      itemBuilder: (context, index) {
        final product = products['results']['HomeProducts'][index];
        return GestureDetector(
          onTap: () => _handleServiceClick(product['id'], product['name']),
          child: ProductCard(
            listingType: 'product',
            listingid: product['id'].toString(),
            imageUrl: product['image'] ??
                "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300",
            venueName: product['name'],
            rating: product['rating']?.toString() ?? '0',
            location: product['location'] ?? '',
            type: 'product',
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    final colors = AppColors(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
