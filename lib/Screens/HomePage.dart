import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/automatic%20Slider.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/theme/color.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  String token = '';
  Map<String, dynamic> categories = {}; // Initialize as empty map
  Map<String, dynamic> listings = {}; // Initialize as empty map
  Map<String, dynamic> demoImages = {}; // Initialize as empty map
  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data in a separate method
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken('accessToken') ?? "";
    final fetchedCategories = await MyApi.getRequest(
      endpoint: 'home/categories/',
      //  headers: {
      //   'Authorization': 'Bearer $token',
      // }
    );

    final fetchedImages = await MyApi.getRequest(
      endpoint: 'Homepage/DemoImages/',
      //  headers: {
      //   'Authorization
      // }
    );
    final fetchedListings = await MyApi.getRequest(endpoint: 'home/listings/');

    // Update the state
    setState(() {
      this.token = token;
      this.categories = fetchedCategories ?? {}; // Ensure no null data
      this.listings = fetchedListings ?? {}; // Ensure no null data
      this.demoImages = fetchedImages ?? {}; // Ensure no null data
      print(demoImages);
      isLoading = false; // Data has been fetched, so stop loading
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Container(
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SearchBox(
                    onChanged: (value) {},
                    hint: 'Search Typing to Search',
                    onclick: () {
                      Navigator.pushNamed(context, '/SearchService');
                    },
                    controller: _searchController,
                    width: screenWidth * 0.9,
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.tune, color: MyColors.white),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ),
            // Show CircularProgressIndicator while loading
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MyColors.Yellow),
                    ),
                  )
                : Column(
                    children: [
                      Center(
                        child: AutoImageSlider(
                          imageUrls: demoImages[
                                  'images'] // Filter items with "image"
                              .map((value) =>
                                  '${MyApi.baseUrl.toString().substring(0, MyApi.baseUrl.toString().length - 1)}${value["image"]}')
                              .cast<String>() // Extract "image" values
                              .toList(),
                          height: screenHeight * 0.25,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: screenWidth * 0.95,
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Browse Categories',
                                style: GoogleFonts.montserrat(
                                  fontSize: MaximumThing * 0.02,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.Yellow,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/SearchService');
                                },
                                child: Text(
                                  'See all',
                                  style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.017,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.19,
                        child: ListView.builder(
                          itemBuilder: (context, index) => CategoryIcon(
                            onpressed: () {
                              Navigator.pushNamed(context, '/SearchService',
                                  arguments: {
                                    'category': categories['categories'][index]
                                        ['name'],
                                  });
                            },
                            label: categories['categories'][index]['name'],
                            imageUrl:
                                '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${categories['categories'][index]['picture']}',
                          ),
                          itemCount: categories['categories'].length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
            // Center(
            //   child: ColoredButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/CreateAIPackage');
            //     },
            //     text: 'Create Package with AI',
            //   ),
            // ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MyColors.Yellow),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listings['HomeListing'].length,
                        itemBuilder: (context, index) {
                          return Productcard(
                            listingType: listings['HomeListing'][index]['type']
                                .toString(),
                            listingid:
                                listings['HomeListing'][index]['id'].toString(),
                            imageUrl: listings['pictures'][index][0]
                                        ['picturePath'] ==
                                    " "
                                ? "https://picsum.photos/id/${Random().nextInt(49) + 1}/600/300"
                                : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${listings['pictures'][index][0]['picturePath']}',
                            venueName: listings['HomeListing'][index]['name'],
                            location: listings['HomeListing'][index]
                                ['location'],
                            type: listings['HomeListing'][index]['type']
                                .toString(),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
