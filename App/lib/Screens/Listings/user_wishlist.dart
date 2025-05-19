import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class WishlistViewPage extends StatefulWidget {
  const WishlistViewPage({super.key});

  @override
  State<WishlistViewPage> createState() => _WishlistViewPageState();
}

class _WishlistViewPageState extends State<WishlistViewPage> {
  final _wishlistController = WishlistController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadWishlist() async {
    await _wishlistController.fetchWishlist();
    if (mounted) setState(() {});
  }

  void _setupAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadWishlist();
    });
  }

  String _getImageUrl(int index) {
    final pictures = _wishlistController.listings['pictures'][index];
    if (pictures.isEmpty || pictures[0]['picturePath'] == " ") {
      return "https://picsum.photos/id/${DateTime.now().millisecondsSinceEpoch % 50 + 1}/600/300";
    }
    return '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${pictures[0]['picturePath']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Header(heading: 'Your Wishlist'),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            _buildWishlistContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistContent() {
    if (_wishlistController.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < _wishlistController.listings['list'].length; i++)
          _buildWishlistItem(i),
      ],
    );
  }

  Widget _buildWishlistItem(int index) {
    final item = _wishlistController.listings['list'][index];
    return ProductCard(
      imageUrl: _getImageUrl(index),
      venueName: item['name'],
      location: item['location'],
      isBusiness: false,
      type: item['type'],
      rating: item['rating'],
      myWidth: MediaQuery.of(context).size.width * 0.9,
      listingid: item['id'].toString(),
      listingType: item['type'],
    );
  }
}

class WishlistController {
  bool isLoading = true;
  Map<String, dynamic> listings = {};
  String token = '';

  Future<void> fetchWishlist() async {
    isLoading = true;
    try {
      final String id = await MyStorage.getToken(MyTokens.userId) ?? "";
      await ApiCall.fetchAPI('wishlist/get/$id', onSuccess: (token, data) {
        this.token = token;
        listings = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }
}
