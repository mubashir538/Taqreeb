import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'dart:math';

class YourListings extends StatefulWidget {
  const YourListings({super.key});

  @override
  State<YourListings> createState() => _YourListingsState();
}

class _YourListingsState extends State<YourListings> {
  Map<String, dynamic> listings = {}; // Initialize as empty map
  String token = '';
  bool isLoading = true; // Add a loading flag
  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data in a separate method
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";

    final fetchedListings = await MyApi.getRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint: 'YourListing/$id');

    // Update the state
    setState(() {
      this.token = token;
      this.listings = fetchedListings ?? {}; // Ensure no null data
      if (listings == null || listings['status'] == 'error') {
        print('$listings');
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
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
                      SizedBox(height: screenHeight * 0.14),
                      Text(
                        "Your Listings",
                        style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.025,
                            fontWeight: FontWeight.w700,
                            color: MyColors.Yellow),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listings['YourListings'].length,
                        itemBuilder: (context, index) {
                          return Productcard(
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