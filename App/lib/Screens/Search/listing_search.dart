import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Inputs/c_input_location.dart';
import 'package:taqreeb/Components/Inputs/c_input_range_slider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/Date%20Question.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/checkbox%20question.dart';
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

class _SearchServiceState extends State<SearchService> {
  // Data State
  final Map<String, dynamic> _args = {};
  final Map<String, dynamic> _categories = {};
  final Map<String, dynamic> _listings = {};
  final Map<String, dynamic> _tempListings = {};
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
  final CheckBoxController _ratingController =
      CheckBoxController(selections: []);
  final CheckBoxController _categoryController =
      CheckBoxController(selections: []);

  FocusNode searchFocus = FocusNode();

  // UI State
  final GlobalKey _headerKey = GlobalKey();
  // DateTime? _entryTime;
  String _token = '';
  bool _isLoading = true;
  bool _isChanged = false;
  final List<String> _appliedFilters = [];
  final List<String> _filtersToApply = [];

  @override
  void initState() {
    super.initState();
    // _entryTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        UI_Management.getHeaderHeight(
            headerKey: _headerKey,
            callback: (renderbox) => _updateHeaderHeight(renderbox)));
  }

  @override
  void dispose() {
    print('Listing is Disposed...');
    // TODO: implement dispose
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
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _fetchData() async {
    await _fetchCategories();
    await _fetchListings();
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

  Future<void> _fetchListings() async {
    await ApiCall.fetchAPI('home/listings/', onSuccess: (_, data) {
      if (mounted) {
        setState(() {
          _listings.addAll(data);
          _tempListings.addAll(Map.from(data));
          if (_args.isNotEmpty) {
            _appliedFilters.add('Category');
            _categoryController.selections.add(_args['category']);
            _searchWithFilters();
          }
          _isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  Future<void> _fetchAdditionalFilters(String categoryType) async {
    setState(() => _isLoading = true);

    final response = await MyApi.getRequest(
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

  String _getListingPicture(int listingId, Map<String, dynamic> listing) {
    for (var pictureGroup in listing['pictures']) {
      if (pictureGroup.isNotEmpty &&
          pictureGroup[0]['listingId'] == listingId) {
        return pictureGroup[0]['picturePath'];
      }
    }
    return '';
  }

  void _searchWithFilters() {
    setState(() {
      _tempListings['HomeListing'] = List.from(_listings['HomeListing']);

      for (String filter in _appliedFilters) {
        switch (filter) {
          case "Price":
            _tempListings['HomeListing'] = _tempListings['HomeListing']
                .where((element) =>
                    element['basicPrice'] >= _rangeSliderController.minValue &&
                    element['basicPrice'] <= _rangeSliderController.maxValue)
                .toList();
            break;

          case "Ratings":
            _tempListings['HomeListing'] = _tempListings['HomeListing']
                .where((element) =>
                    _ratingController.selections.contains(element['rating']))
                .toList();
            break;

          case "Category":
            _tempListings['HomeListing'] = _tempListings['HomeListing']
                .where((element) =>
                    _categoryController.selections.contains(element['type']))
                .toList();
            break;

          case "Location":
            _tempListings['HomeListing'] = _tempListings['HomeListing']
                .where((element) => element['location']
                    .toLowerCase()
                    .contains(_locationController.text.toLowerCase()))
                .toList();
            break;
        }
      }

      // Apply additional filters if they exist
      if (_additionalSelections.isNotEmpty) {
        _tempListings['HomeListing'] =
            _tempListings['HomeListing'].where((listing) {
          return _additionalSelections.entries.every((entry) {
            if (entry.value.isEmpty)
              return true; // No filter applied for this field
            if (listing[entry.key] == null) return false;
            return entry.value.contains(listing[entry.key].toString());
          });
        }).toList();
      }
    });
  }

  void _navigateToServiceDetails(Map<String, dynamic> service) {
    final entryTime = DateTime.now();
    final serviceId = service['id'];
    final serviceName = service['name'];

    Logs.logUserActivity("service_click",
        {"service_id": serviceId, "service_name": serviceName});

    Navigator.pushNamed(
      context,
      '/SearchServiceDetails',
      arguments: {
        "id": serviceId,
        "service_name": serviceName,
        "entry_time": entryTime.toIso8601String(),
      },
    ).then((_) {
      final duration = DateTime.now().difference(entryTime).inSeconds;
      Logs.logUserActivity("service_view_duration", {
        "service_id": serviceId,
        "service_name": serviceName,
        "duration_seconds": duration
      });
    });
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
                    style: GoogleFonts.montserrat(
                      color: MyColors.Dark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _appliedFilters.remove(filter);
                        _searchWithFilters();
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
    );
  }

  Widget _buildServiceList() {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final service = _tempListings['HomeListing'][index];
          final imageUrl = _getListingPicture(service['id'], _tempListings);

          return GestureDetector(
            onTap: () => _navigateToServiceDetails(service),
            child: Productcard(
              listingType: service['type'].toString(),
              listingid: service['id'].toString(),
              imageUrl: imageUrl.isEmpty
                  ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                  : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$imageUrl',
              venueName: service['name'],
              location: service['location'],
              type: service['type'].toString(),
            ),
          );
        },
        itemCount: _tempListings['HomeListing'].length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
              onclick: () {
                searchFocus.requestFocus();
              },
              hint: 'Start typing to search',
              controller: _searchController,
              width: Screen.width(context) * 0.75,
              onChanged: (value) {
                setState(() {
                  _searchWithFilters();
                  _tempListings['HomeListing'] = _tempListings['HomeListing']
                      .where((element) => element['name']
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
                if (value.isNotEmpty) {
                  print('searchlog');
                  Logs.logUserActivity("search", {"search_query": value});
                  print('searchlog');
                }
              },
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
                // Only show additional filters button if we have additional filters
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

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderbox) => _updateHeaderHeight(renderbox),
    );

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
                  SizedBox(height: UI_Management.headerHeight),
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MyColors.white,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            _buildSearchBar(),
                            if (_appliedFilters.isNotEmpty) _buildFilterChips(),
                            _buildServiceList(),
                          ],
                        ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(key: _headerKey),
          ),
        ],
      ),
    );
  }

  void _showFilterPopup(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final keyboard = MediaQuery.of(context).viewInsets.bottom;
        final isKeyboardVisible = keyboard > 0;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isKeyboardVisible && _scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

        return Container(
          padding: EdgeInsets.all(Screen.max(context) * 0.02),
          constraints: BoxConstraints(maxHeight: Screen.max(context) * 0.8),
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Screen.max(context) * 0.05),
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
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
                      child: CheckBoxQuestion(
                        question: '',
                        options: [
                          '5 Stars',
                          '4 Stars',
                          '3 Stars',
                          '2 Stars',
                          '1 Stars'
                        ],
                        controller: _ratingController,
                        onChanged: (_) {
                          if (!_filtersToApply.contains("Ratings")) {
                            _filtersToApply.add("Ratings");
                          }
                        },
                      ),
                    ),
                    _buildFilterSection(
                      title: 'Category',
                      child: CheckBoxQuestion(
                        question: '',
                        options: _isLoading
                            ? []
                            : _categories['categories']
                                .map((value) => value['name'].toString())
                                .cast<String>()
                                .toList(),
                        controller: _categoryController,
                        onChanged: (selections) {
                          if (!_filtersToApply.contains("Category")) {
                            _filtersToApply.add("Category");
                          }
                          Logs.logUserActivity("category_click",
                              {"selected_category": selections});
                        },
                      ),
                    ),
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
                    SizedBox(height: keyboard + Screen.height(context) * 0.1),
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
                  ))
            ],
          ),
        );
      },
    ).whenComplete(() {
      _scrollController.dispose();
    });
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: Screen.max(context) * 0.02,
            fontWeight: FontWeight.w500,
            color: MyColors.Yellow,
          ),
        ),
        child,
      ],
    );
  }

  void _applyFilters() {
    setState(() {
      _appliedFilters.clear();
      _appliedFilters.addAll(_filtersToApply);
    });

    // Fetch additional filters when category is selected
    if (_appliedFilters.contains("Category") &&
        _categoryController.selections.isNotEmpty) {
      _fetchAdditionalFilters(_categoryController.selections[0]);
    }

    final filterData = {
      "applied_filters": _appliedFilters,
      "filter_values": {
        if (_appliedFilters.contains("Ratings"))
          "Ratings": _ratingController.selections,
        if (_appliedFilters.contains("Category"))
          "Category": _categoryController.selections,
        if (_appliedFilters.contains("Price"))
          "Price": {
            "min": _rangeSliderController.minValue,
            "max": _rangeSliderController.maxValue
          },
        if (_appliedFilters.contains("Location"))
          "Location": _locationController.text,
        if (_appliedFilters.contains("Date")) "Date": _dateController.text,
      }
    };

    Logs.logUserActivity("filter", filterData);
    _searchWithFilters();
  }

  void _showAdditionalFilterPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.Dark,
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
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.Yellow,
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
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MyColors.Yellow,
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
                      setState(() => _searchWithFilters());
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
