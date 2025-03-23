import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/global/header.dart';
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
  bool isLoading = true;
  Timer? timer;
  String token = '';
  Map<String, dynamic> listings = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";
    final fetchedListings = await MyApi.getRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint: 'wishlist/get/${id}');

    setState(() {
      this.token = token;
      this.listings = fetchedListings ?? {};
      if (listings == {} || listings['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something Went Wrong!',
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: MyColors.white,
                  fontWeight: FontWeight.w400)),
          backgroundColor: MyColors.red,
        ));
        return;
      } else {
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(heading: 'Your Wishlist'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < listings['list'].length; i++)
                        Productcard(
                            imageUrl: listings['pictures'][i].length != 0
                                ? (listings['pictures'][i][0]['picturePath'] ==
                                        " "
                                    ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                                    : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listings['pictures'][i][0]['picturePath']}')
                                : "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300",
                            venueName: listings['list'][i]['name'],
                            location: listings['list'][i]['location'],
                            isBusiness: false,
                            type: listings['list'][i]['type'],
                            mywidth: MediaQuery.of(context).size.width * 0.9,
                            listingid: listings['list'][i]['id'].toString(),
                            listingType: listings['list'][i]['type'])
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
