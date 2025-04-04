import 'package:flutter/material.dart';
import 'package:taqreeb/Screens/Listings/Listing%20View%20Page/components/c_listing_booknowButton.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
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

class CategoryView_Saloon extends StatefulWidget {
  const CategoryView_Saloon({super.key});

  @override
  State<CategoryView_Saloon> createState() => _CategoryView_SaloonState();
}

class _CategoryView_SaloonState extends State<CategoryView_Saloon> {
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

  @override
  void initState() {
    super.initState();
    _entryTime = DateTime.now();
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
        "category": "Saloon",
        "listing_id": _listingId!,
        "time_spent_seconds": duration
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchListingData();
  }

  void _fetchListingData() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    setState(() {
      _listingId = args['id'];
    });

    if (!_hasChanged) {
      ApiCall.fetchAPI(
        'saloonviewpage/$_listingId',
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
                events: {},
              ),
              _buildDivider(),
              PricingSection(listing: _listing),
              DescriptionCategory(listing: _listing),
              CategoryDetails(
                listing: _listing,
                headings: _addonsHeadings,
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
          const ChatIcon(),
        ],
      ),
    );
  }
}
