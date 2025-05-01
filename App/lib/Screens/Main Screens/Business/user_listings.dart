import 'package:provider/provider.dart';
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

class YourListingsController with ChangeNotifier {
  Map<String, dynamic> listings = {};
  String token = '';
  String type = "";
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners when loading starts

    print('Fetching data...');
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";
    type = await MyTokens.getBusinessType();

    if (type == 'user') {
      _isLoading = false;
      notifyListeners();
      return;
    }

    await ApiCall.fetchAPI('YourListing/$id/$type', onSuccess: (token, data) {
      this.token = token;
      listings = data;
      _isLoading = false;
      notifyListeners(); // Notify listeners when data is loaded
    });
  }
}

class YourListingsScreen extends StatelessWidget {
  const YourListingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<YourListingsController>();
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _buildMainContent(context, controller),
          const Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context, YourListingsController controller) {
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
          _buildListings(controller),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Your Listings",
      style: GoogleFonts.montserrat(
        fontSize: Screen.max(context) * 0.025,
        fontWeight: FontWeight.w700,
        color: MyColors.Yellow,
      ),
    );
  }

  Widget _buildListings(YourListingsController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.listings['YourListings']?.length ?? 0,
      itemBuilder: (context, index) {
        final listing = controller.listings['YourListings'][index];
        final pictures = controller.listings['pictures'][index];

        return Productcard(
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
