import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:taqreeb/core/services/api_service.dart';

class YourListingsController {
  Map<String, dynamic> listings = {};
  String token = '';
  String type = "";
  bool isLoading = true;

  Future<void> fetchData() async {
    isLoading = true;
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";
    type = await MyTokens.getBusinessType();
    if (type == 'user') {
      return;
    }
    await ApiCall.fetchAPI('YourListing/$id/$type', onSuccess: (token, data) {
      this.token = token;
      listings = data;
      isLoading = false;
    });
  }
}

class YourListingsScreen extends StatelessWidget {
  final YourListingsController controller;

  const YourListingsScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _buildMainContent(context),
          const Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (controller.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(MyColors.white),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Screen.height(context) * 0.14),
          _buildTitle(context),
          _buildListings(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Your Listings",
      style: GoogleFonts.roboto(
        fontSize: Screen.max(context) * 0.025,
        fontWeight: FontWeight.w700,
        color: MyColors.yellow,
      ),
    );
  }

  Widget _buildListings() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.listings['YourListings']?.length ?? 0,
      itemBuilder: (context, index) {
        final listing = controller.listings['YourListings'][index];
        final pictures = controller.listings['pictures'][index];

        return ProductCard(
          rating: listing['rating'].toString(),
          isBusiness: true,
          listingType: listing['type'],
          listingid: listing['id'].toString(),
          imageUrl: _getImageUrl(pictures),
          venueName: listing['name'],
          location: listing['location'],
          type: listing['type'],
        );
      },
    );
  }

  String _getImageUrl(List<dynamic> pictures) {
    if (pictures.isEmpty || pictures[0]['picturePath'] == ' ') {
      return "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300";
    }
    return '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${pictures[0]['picturePath']}';
  }
}
