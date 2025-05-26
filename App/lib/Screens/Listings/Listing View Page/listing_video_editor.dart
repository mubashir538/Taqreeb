import 'package:flutter/material.dart';
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

class CategoryViewVideoEditor extends StatefulWidget {
  const CategoryViewVideoEditor({super.key});

  @override
  State<CategoryViewVideoEditor> createState() =>
      _CategoryViewVideoEditorState();
}

class _CategoryViewVideoEditorState extends State<CategoryViewVideoEditor> {
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

  static const List<String> _headings = ['Portfolio Link'];
  static const List<String> _searchValues = [];

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
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    setState(() {
      UImanagement.headerHeight = renderBox.size.height;
    });
  }

  void _logViewDuration() {
    if (_entryTime != null && _listingId != null) {
      final duration = DateTime.now().difference(_entryTime!).inSeconds;

      Logs.logUserActivity("category_view_duration", {
        "category": "Video Editor",
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
        refresh: true,
        'carrenter/viewpage/$_listingId',
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
        final colors = AppColors(context);

    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.white),
      ),
    );
  }

  Widget _buildContent() {
    final colors = AppColors(context);

    return Column(
      children: [
        ImageSliderCategory(imageUrls: _imageUrls),
        Container(
          width: Screen.width(context),
          color: colors.dark,
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

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );
        final colors = AppColors(context);


    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UImanagement.headerHeight),
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
                  ownerId: _listing['Listing']['freelancerID'],
                  listing: _listing,
                  type: 'Freelancer',
                )
        ],
      ),
    );
  }
}
