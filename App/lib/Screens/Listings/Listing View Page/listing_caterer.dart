import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_booknowButton.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/user_logs.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
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
import 'package:taqreeb/core/utils/color.dart';

class CategoryViewCaterers extends StatefulWidget {
  const CategoryViewCaterers({super.key});

  @override
  State<CategoryViewCaterers> createState() => _CategoryViewCaterersState();
}

class _CategoryViewCaterersState extends State<CategoryViewCaterers> {
  // State variables
  late final Map<String, dynamic> _listing;
  late final List<String> _imageUrls = [];
  late final List<String> _values = [];
  late final List<String> _addonsHeadings = [];
  late final List<String> _addonsValues = [];
  late final List<String> _starsValue = [];

  int? _listingId;
  DateTime? _selectedDate;
  DateTime? _entryTime;
  bool _isLoading = true;
  bool _hasChanged = false;
  final GlobalKey _headerKey = GlobalKey();

  static const List<String> _headings = [
    'Service Type',
    'Catering Options',
    'Staff',
    'Expertise'
  ];
  static const List<String> _searchValues = [
    'serviceType',
    'cateringOptions',
    'staff',
    'expertise'
  ];

  @override
  void initState() {
    super.initState();
    _entryTime = DateTime.now();
      print("📍 [DEBUG] Entered Caterers View at $_entryTime");

    _initializeUI();
  }

  @override
  void dispose() {
    _logViewDuration();
    super.dispose();
  }

  void _initializeUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    setState(() {
      UI_Management.headerHeight = renderBox.size.height;
    });
  }

  void _logViewDuration() {
    if (_entryTime != null && _listingId != null) {
      final duration = DateTime.now().difference(_entryTime!).inSeconds;
      Logs.logUserActivity("category_view_duration", {
        "category": "Caterers",
        "listing_id": _listingId!,
        "time_spent_seconds": duration
      });
          print("🚪 [DEBUG] Exited Caterers View. Duration: $duration seconds");

    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchListingData();
  }

  void _fetchListingData() {
    if (!_hasChanged) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      setState(() {
        _listingId = args['id'];
        _hasChanged = true;
      });

      ApiCall.fetchAPI(
        'Caterer/viewpage/$_listingId',
        refresh: true,
        onSuccess: _handleFetchSuccess,
        onError: _handleFetchError,
      );
    }
  }

  void _handleFetchSuccess(String token, Map<String, dynamic> listing) {
    if (mounted) {
      setState(() {
        _listing = listing;
        _isLoading = false;

        ApiCall.updateListingDetails(
          listing: listing,
          updateState: _handleListingUpdate,
          imageUrls: _imageUrls,
          addonsheadings: _addonsHeadings,
          addonsvalues: _addonsValues,
          values: _values,
          starsvalue: _starsValue,
          searchValues: _searchValues,
        );
      });
    }
  }

  void _handleFetchError() {
    if (mounted) {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }
  }

  void _handleListingUpdate(bool isLoading, bool isChange) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
        _hasChanged = isChange;
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        ImageSliderCategory(imageUrls: _imageUrls),
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
                listing: _listing,
                listingId: _listingId,
                selectedDate: _selectedDate,
              ),
              _buildDivider(),
              PricingSection(listing: _listing),
              DescriptionCategory(listing: _listing),
              CategoryDetails(
                listing: _listing,
                headings: _headings,
                values: _values,
              ),
              CategoryAddons(listing: _listing),
              CategoryPackages(listing: _listing),
              CategoryReview(
                listing: _listing,
                starsvalue: _starsValue,
              ),
              _buildDivider(),
              _buildBookNowButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: Screen.height(context) * 0.05,
      child: Center(
        child: MyDivider(width: Screen.width(context) * 0.85),
      ),
    );
  }

  Widget _buildBookNowButton() {
    return BookNowButton(context: context, listing: _listing);
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UI_Management.headerHeight),
                _isLoading ? _buildLoadingIndicator() : _buildContent(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(key: _headerKey),
          ),
          _isLoading
              ? Container()
              : ChatIcon(
                  ownerId: _listing['Listing']['ownerID'],
                  listing: _listing,
                  type: 'Business',
                ),
        ],
      ),
    );
  }
}
