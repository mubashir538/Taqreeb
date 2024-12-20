import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/ProductCard.dart';
import 'package:taqreeb/Components/Search Box.dart';
import 'package:taqreeb/Components/category_icon.dart';
import 'package:taqreeb/theme/color.dart';

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
    final fetchedListings = await MyApi.getRequest(endpoint: 'home/listings/');

    // Update the state
    setState(() {
      this.token = token;
      this.categories = fetchedCategories ?? {}; // Ensure no null data
      this.listings = fetchedListings ?? {}; // Ensure no null data
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
                  SearchBox(controller: _searchController),
                  IconButton(
                    icon: Icon(Icons.tune, color: MyColors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.2,
              alignment: Alignment.center,
              child: Image.network(
                'https://tse2.mm.bing.net/th?id=OIP.dZWWg5LlJhlUFNNdNuLsIQHaEL&pid=Api&P=0&h=220',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Center(
              child: Container(
                width: screenWidth * 0.95,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
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
            // Show CircularProgressIndicator while loading
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(MyColors.Yellow),
                    ),
                  )
                : SizedBox(
                    height: screenHeight * 0.19,
                    child: ListView.builder(
                      itemBuilder: (context, index) => CategoryIcon(
                        onpressed: () {
                          Navigator.pushNamed(
                              context, '/CategoryView_Caterers');
                        },
                        label: categories['categories'][index]['name'],
                        imageUrl:
                            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${categories['categories'][index]['picture']}',
                      ),
                      itemCount: categories['categories'].length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
            Center(
              child: ColoredButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/CreateAIPackage');
                },
                text: 'Create Package with AI',
              ),
            ),
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
                            onpressed: () {
                              Navigator.pushNamed(
                                  context, '/CategoryView_Venue');
                            },
                            imageUrl:
                                // '${MyApi.baseUrl}${listings['HomeListing'][index]['picture']}.png',
                                'https://tse2.mm.bing.net/th?id=OIP.dZWWg5LlJhlUFNNdNuLsIQHaEL&pid=Api&P=0&h=220',
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
