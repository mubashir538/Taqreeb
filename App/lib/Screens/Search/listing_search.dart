import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Home%20Page/c_product.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Inputs/c_checkbox_question.dart';
import 'package:taqreeb/Components/Inputs/c_date_question.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_location.dart';
import 'package:taqreeb/Components/Inputs/c_input_range_slider.dart';
import 'package:taqreeb/Components/c_package_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/user_logs.dart';
import 'package:taqreeb/core/utils/color.dart';

class SearchService extends StatefulWidget {
  const SearchService({super.key});

  @override
  State<SearchService> createState() => _SearchServiceState();
}

class _SearchServiceState extends State<SearchService>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data State
  final Map<String, dynamic> _args = {};
  final Map<String, dynamic> _categories = {};
  final Map<String, dynamic> _searchResults = {
    'listings': [],
    'packages': [],
    'products': [],
  };
  final Map<String, dynamic> _additionalFilters = {};
  final Map<String, dynamic> _additionalSelections = {};

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final RangeSliderController _rangeSliderController = RangeSliderController(
    minValue: 10000,
    maxValue: 5000000,
  );
  final RangeSliderController _ratingController = RangeSliderController(
    minValue: 1,
    maxValue: 5,
  );
  final TextEditingController _categoryController =
      TextEditingController(text: 'All');

  FocusNode searchFocus = FocusNode();

  // UI State
  final GlobalKey _headerKey = GlobalKey();
  String _token = '';
  bool _isLoading = true;
  bool _isChanged = false;
  final List<String> _appliedFilters = [];
  final List<String> _filtersToApply = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _performSearch();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        UImanagement.getHeaderHeight(
            headerKey: _headerKey,
            callback: (renderbox) => _updateHeaderHeight(renderbox)));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isChanged) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        _args.addAll(args as Map<String, dynamic>);
      }
      _isChanged = true;
      _fetchData();
    }
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _fetchData() async {
    await _fetchCategories();
    await _performSearch();
  }

  Future<void> _fetchCategories() async {
    await ApiCall.fetchAPI('home/categories/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          _token = token;
          _categories.addAll(data);
        });
      }
    }, context: mounted ? context : null);
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);

    final params = {
      if (_searchController.text.isNotEmpty) 'q': _searchController.text,
      if (_categoryController.text != 'All')
        'category': _categoryController.text,
      if (_locationController.text.isNotEmpty)
        'location': _locationController.text,
      if (_dateController.text.isNotEmpty) 'date': _dateController.text,
      if (_appliedFilters.contains('Price'))
        'min_price': _rangeSliderController.minValue.toString(),
      if (_appliedFilters.contains('Price'))
        'max_price': _rangeSliderController.maxValue.toString(),
      if (_appliedFilters.contains('Ratings'))
        'min_rating': _ratingController.minValue.toString(),
      if (_appliedFilters.contains('Ratings'))
        'max_rating': _ratingController.maxValue.toString(),
      'type': _getCurrentTabType(),
    };

    // Add additional filters if they exist
    _additionalSelections.forEach((key, value) {
      if (value.isNotEmpty) {
        params[key] = value.join(',');
      }
    });

    await ApiCall.fetchAPI('unified_search/', params: params,
        onSuccess: (_, data) {
      if (mounted) {
        setState(() {
          _searchResults[_getCurrentTabType()] = data['results'];
          _isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  String _getCurrentTabType() {
    switch (_tabController.index) {
      case 0:
        return 'listings';
      case 1:
        return 'packages';
      case 2:
        return 'products';
      default:
        return 'listings';
    }
  }

  Future<void> _fetchAdditionalFilters(String categoryType) async {
    setState(() => _isLoading = true);

    final response = await MyApi.getRequest(
      context: context,
      endpoint: 'getListingDetails/$categoryType',
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (mounted) {
      setState(() {
        if (response != null && response['fields'] != null) {
          _additionalFilters.clear();
          _additionalSelections.clear();

          for (var field in response['fields']) {
            if (field['choices'] != null && field['choices'].isNotEmpty) {
              _additionalFilters[field['name']] = field['choices'];
              _additionalSelections[field['name']] = [];
            }
          }
        } else {
          MyScaffold(text: 'Failed to fetch additional filters!').show(context);
        }
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _appliedFilters.clear();
      _appliedFilters.addAll(_filtersToApply);
      _filtersToApply.clear();
    });

    if (_appliedFilters.contains("Category") &&
        _categoryController.text != "All") {
      _fetchAdditionalFilters(_categoryController.text);
    }

    final filterData = {
      "applied_filters": _appliedFilters,
      "filter_values": {
        if (_appliedFilters.contains("Ratings"))
          "Ratings": {
            "min": _ratingController.minValue,
            "max": _ratingController.maxValue
          },
        if (_appliedFilters.contains("Category"))
          "Category": _categoryController.text,
        if (_appliedFilters.contains("Price"))
          "Price": {
            "min": _rangeSliderController.minValue.toInt(),
            "max": _rangeSliderController.maxValue.toInt()
          },
        if (_appliedFilters.contains("Location"))
          "Location": _locationController.text,
        if (_appliedFilters.contains("Date")) "Date": _dateController.text,
      }
    };

    Logs.logUserActivity("filter", filterData);
    _performSearch();
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.only(top: Screen.max(context) * 0.02),
      child: TabBar(
        controller: _tabController,
        indicatorColor: MyColors.red,
        labelColor: MyColors.white,
        unselectedLabelColor: MyColors.whiteDarker,
        tabs: const [
          Tab(text: 'Listings'),
          Tab(text: 'Packages'),
          Tab(text: 'Products'),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      margin: EdgeInsets.only(top: Screen.max(context) * 0.02),
      width: Screen.width(context) * 0.9,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _appliedFilters.map((filter) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: MyColors.whiteDarker,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    filter,
                    style: GoogleFonts.roboto(
                      color: MyColors.dark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _appliedFilters.remove(filter);
                        if (filter == "Category") {
                          _categoryController.text = 'All';
                        }
                        if (filter == "Price") {
                          _rangeSliderController.updateValues(
                              _rangeSliderController.minValue,
                              _rangeSliderController.maxValue);
                        }
                        if (filter == "Ratings") {
                          _ratingController.updateValues(
                              _ratingController.minValue,
                              _ratingController.maxValue);
                        }
                        if (filter == "Location") _locationController.clear();
                        if (filter == "Date") _dateController.clear();
                        _performSearch();
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: MyColors.dark,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.only(top: Screen.max(context) * 0.05),
      child: SizedBox(
        width: Screen.width(context) * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchBox(
              focusNode: searchFocus,
              onclick: () => searchFocus.requestFocus(),
              hint: 'Start typing to search',
              controller: _searchController,
              width: Screen.width(context) * 0.75,
              onChanged: (value) => _performSearch(),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => _showFilterPopup(context),
                  icon: Icon(
                    Icons.tune,
                    size: Screen.max(context) * 0.03,
                    color: MyColors.white,
                  ),
                ),
                if (_appliedFilters.contains("Category") &&
                    _additionalFilters.isNotEmpty)
                  IconButton(
                    onPressed: () => _showAdditionalFilterPopup(context),
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
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
        ),
      );
    }

    switch (_tabController.index) {
      case 0:
        return _buildListingsTab();
      case 1:
        return _buildPackagesTab();
      case 2:
        return _buildProductsTab();
      default:
        return _buildListingsTab();
    }
  }

  Widget _buildListingsTab() {
    return _searchResults['listings'].isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            itemCount: _searchResults['listings'].length,
            itemBuilder: (context, index) {
              final listing = _searchResults['listings'][index];
              return ProductCard(
                rating: listing['rating'].toString(),
                listingType: listing['type'].toString(),
                listingid: listing['id'].toString(),
                imageUrl: listing['pictures']?['picturePath'] ??
                    "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300",
                venueName: listing['name'],
                location: listing['location'],
                type: listing['type'].toString(),
              );
            },
          );
  }

  Widget _buildPackagesTab() {
    return _searchResults['packages'].isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            itemCount: _searchResults['packages'].length,
            itemBuilder: (context, index) {
              final package = _searchResults['packages'][index];
              return PackageBox(
                packageId: package['id'].toString(),
                imageUrls: package['pictures'].length != 0
                    ? package['pictures']
                        ?.map((p) => p['picturePath'].toString())
                        .toList()
                    : [],
                packagedetails: package['description'],
                packageprice: package['price'].toString(),
                packagename: package['name'],
              );
            },
          );
  }

  Widget _buildProductsTab() {
    return _searchResults['products'].isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            itemCount: _searchResults['products'].length,
            itemBuilder: (context, index) {
              final product = _searchResults['products'][index];
              return ProductBox(
                productId: product['id'].toString(),
                productName: product['name'],
                productDescription: product['description'],
                productPrice: product['price'].toString(),
                productImage: product['pictures']?[0]['picturePath'] ?? '',
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No results found',
        style: GoogleFonts.montserrat(
          color: MyColors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  void _showFilterPopup(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(Screen.max(context) * 0.02),
          constraints: BoxConstraints(maxHeight: Screen.max(context) * 0.8),
          decoration: BoxDecoration(
            color: MyColors.darkLighter,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Screen.max(context) * 0.05),
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Filter Options",
                      style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.03,
                        fontWeight: FontWeight.bold,
                        color: MyColors.red,
                      ),
                    ),
                    _buildFilterSection(
                      title: 'Pricing',
                      child: RangeSliderWidget(
                        start: 10000,
                        end: 5000000,
                        divisions: 500,
                        controller: _rangeSliderController,
                        onChanged: (min, max) {
                          if (!_filtersToApply.contains("Price")) {
                            _filtersToApply.add("Price");
                          }
                        },
                      ),
                    ),
                    _buildFilterSection(
                      title: 'Ratings',
                      child: RangeSliderWidget(
                        start: 1,
                        end: 5,
                        divisions: 8,
                        startLabel: '1 Star',
                        endLabel: '5 Star',
                        price: false,
                        controller: _ratingController,
                        onChanged: (min, max) {
                          if (!_filtersToApply.contains("Ratings")) {
                            _filtersToApply.add("Ratings");
                          }
                        },
                      ),
                    ),
                    _buildFilterSection(
                        title: 'Category',
                        child: ResponsiveDropdown(
                          items: _isLoading
                              ? []
                              : _categories['categories']
                                  .map((value) => value['name'].toString())
                                  .cast<String>()
                                  .toList(),
                          labelText: _categoryController.text == 'All'
                              ? 'Select Category'
                              : _categoryController.text,
                          onChanged: (text) {
                            setState(() {
                              _categoryController.text = text;
                            });
                            if (!_filtersToApply.contains("Category")) {
                              _filtersToApply.add("Category");
                            }
                            if (_categoryController.text == "All" &&
                                _filtersToApply.contains("Category")) {
                              _filtersToApply.remove('Category');
                            }
                          },
                        )),
                    _buildFilterSection(
                      title: 'Location',
                      child: LocationInputWidget(
                        locationController: _locationController,
                        onLocationChanged: (_) {
                          if (!_filtersToApply.contains("Location")) {
                            _filtersToApply.add("Location");
                          }
                        },
                      ),
                    ),
                    _buildFilterSection(
                      title: 'Date',
                      child: DateQuestion(
                        question: "",
                        valuecontroller: _dateController,
                      ),
                    ),
                    SizedBox(height: Screen.height(context) * 0.1),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: ColoredButton(
                  text: 'Apply Filters',
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        );
      },
    ).whenComplete(() {
      scrollController.dispose();
    });
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: Screen.max(context) * 0.02,
            fontWeight: FontWeight.w500,
            color: MyColors.yellow,
          ),
        ),
        child,
      ],
    );
  }

  void _showAdditionalFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Filters',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.yellow,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: _additionalFilters.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MyColors.yellow,
                              ),
                            ),
                            CheckBoxQuestion(
                              question: '',
                              options: entry.value.cast<String>().toList(),
                              controller: CheckBoxController(
                                selections: _additionalSelections[entry.key]
                                    .cast<String>()
                                    .toList(),
                              ),
                              onChanged: (selections) {
                                setState(() {
                                  _additionalSelections[entry.key] = selections;
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
                      _performSearch();
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

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderbox) => _updateHeaderHeight(renderbox),
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Column(
        children: [
          Header(key: _headerKey),
          Expanded(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildTabBar(),
                if (_appliedFilters.isNotEmpty) _buildFilterChips(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
