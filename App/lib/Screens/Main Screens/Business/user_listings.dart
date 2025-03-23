import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'dart:math';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class YourListings extends StatefulWidget {
  const YourListings({super.key});

  @override
  State<YourListings> createState() => _YourListingsState();
}

class _YourListingsState extends State<YourListings> {
  Map<String, dynamic> listings = {};
  String token = '';
  String type = "";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";
    type = await MyTokens.getBusinessType();
    ApiCall.fetchAPI('YourListing/$id/$type', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          token = token;
          listings = data;
          isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          isLoading
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.white),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: Screen.height(context) * 0.14),
                      Text(
                        "Your Listings",
                        style: GoogleFonts.montserrat(
                            fontSize: Screen.max(context) * 0.025,
                            fontWeight: FontWeight.w700,
                            color: MyColors.Yellow),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listings['YourListings'].length,
                        itemBuilder: (context, index) {
                          return Productcard(
                              isBusiness: true,
                              listingType: listings['YourListings'][index]
                                  ['type'],
                              listingid: listings['YourListings'][index]['id']
                                  .toString(),
                              imageUrl: listings['pictures'][index][0]
                                          ['picturePath'] ==
                                      ' '
                                  ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                                  : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listings['pictures'][index][0]['picturePath']}',
                              venueName: listings['YourListings'][index]
                                  ['name'],
                              location: listings['YourListings'][index]
                                  ['location'],
                              type: listings['YourListings'][index]['type']);
                        },
                      )
                    ],
                  ),
                ),
          Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }
}
