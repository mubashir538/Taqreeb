import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';

class CategoryView_CarRenter extends StatefulWidget {
  const CategoryView_CarRenter({super.key});

  @override
  State<CategoryView_CarRenter> createState() => _CategoryView_CarRenterState();
}

class _CategoryView_CarRenterState extends State<CategoryView_CarRenter> {
  String token = '';
  Map<String, dynamic> listing = {}; // Initialize as empty map
  late int? listingId;
  bool isLoading = true; // Add a loading flag

  int _currentIndex = 0;
  bool isToggled = true;
  List<String> headings = [
    'Service Type',
    'Catering Options',
    'Staff',
    'Expertise'
  ];
  List<String> values = [];
  List<String> addonsheadings = [];
  List<String> addonsvalues = [];
  List<String> stars = [
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Stars',
  ];
  List<String> starsvalue = [];

  final List<String> _imageUrls = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as int?;
    setState(() {
      listingId = args;
      listingId = 1;
    });
    fetchData();
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken('accessToken') ?? "";
    final listing = await MyApi.getRequest(
        endpoint: 'carrenter/viewpage/${this.listingId}');

    // Update the state
    setState(() {
      this.token = token;
      this.listing = listing ?? {};
      isLoading = false;
      for (var i = 0; i < listing['pictures'].length; i++) {
        this._imageUrls.add(listing['pictures'][i]['picturePath']);
      }
      for (var i = 0; i < listing['Addons'].length; i++) {
        this.addonsheadings.add(listing['Addons'][i]['name']);
        if (listing['Addons'][i]['isPer']) {
          this.addonsvalues.add(
              '${listing['Addons'][i]['price'].toString()}/${listing['Addons'][i]['perType'].toString()}');
        } else {
          this.addonsvalues.add(listing['Addons'][i]['price'].toString());
        }
      }
      this.values.add(listing['View']['serviceType']);
      this.values.add(listing['View']['cateringOptions']);
      this.values.add(listing['View']['staff']);
      this.values.add(listing['View']['expertise']);
      this.starsvalue.add('(${listing['reveiewData']['5'].toString()})');
      this.starsvalue.add('(${listing['reveiewData']['4'].toString()})');
      this.starsvalue.add('(${listing['reveiewData']['3'].toString()})');
      this.starsvalue.add('(${listing['reveiewData']['2'].toString()})');
      this.starsvalue.add('(${listing['reveiewData']['1'].toString()})');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                  ))
                : Column(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: screenHeight * 0.3,
                                child: PageView.builder(
                                  itemCount: _imageUrls.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      _imageUrls[index],
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: -(maximumDimension * 0.01),
                                child: Container(
                                  height: maximumDimension * 0.05,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    color: MyColors.Dark,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: maximumDimension * 0.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(_imageUrls.length,
                                        (index) {
                                      return AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        width: _currentIndex == index
                                            ? maximumDimension * 0.015
                                            : maximumDimension * 0.01,
                                        height: _currentIndex == index
                                            ? maximumDimension * 0.015
                                            : maximumDimension * 0.01,
                                        decoration: BoxDecoration(
                                          color: _currentIndex == index
                                              ? MyColors.red
                                              : MyColors.whiteDarker,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        width: screenWidth,
                        color: MyColors.Dark,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      listing['Listing']['name'],
                                      softWrap: true,
                                      style: GoogleFonts.montserrat(
                                        fontSize: maximumDimension * 0.025,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.white,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: MyColors.Yellow,
                                    size: maximumDimension * 0.05,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: maximumDimension * 0.01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.star,
                                            color: MyColors.Yellow),
                                        Text(
                                          "${listing['reveiewData']['average'].toString()} (${listing['reveiewData']['count'].toString()})",
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              color: MyColors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      listing['Listing']['location'],
                                      softWrap: true,
                                      style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.015,
                                          color: MyColors.white),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: maximumDimension * 0.01),
                                    child: Icon(
                                      Icons.location_on,
                                      color: MyColors.white,
                                      size: maximumDimension * 0.04,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Pricing:",
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.02,
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      Text(
                                        "Rs. ${listing['Listing']['priceMin'].toString()} - ${listing['Listing']['priceMax'].toString()}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: maximumDimension * 0.02,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: maximumDimension * 0.015),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Basic Price:",
                                          style: GoogleFonts.montserrat(
                                            fontSize: maximumDimension * 0.015,
                                            fontWeight: FontWeight.w500,
                                            color: MyColors.Yellow,
                                          ),
                                        ),
                                        Text(
                                          listing['Listing']['basicPrice']
                                              .toString(),
                                          style: GoogleFonts.montserrat(
                                            fontSize: maximumDimension * 0.015,
                                            fontWeight: FontWeight.w400,
                                            color: MyColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: maximumDimension * 0.015),
                                    child: Text(
                                      "Description",
                                      style: GoogleFonts.montserrat(
                                        fontSize: maximumDimension * 0.025,
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.Yellow,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        setState(() => isToggled = !isToggled),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: maximumDimension * 0.01),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            listing['Listing']['description'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: isToggled ? 6 : 200,
                                            style: GoogleFonts.montserrat(
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              fontWeight: FontWeight.w300,
                                              color: MyColors.white,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          Icon(isToggled
                                              ? Icons.arrow_downward_outlined
                                              : Icons.arrow_upward_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Column(
                                children: [
                                  for (var heading in headings)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: maximumDimension * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            heading,
                                            style: GoogleFonts.montserrat(
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              fontWeight: FontWeight.w500,
                                              color: MyColors.Yellow,
                                            ),
                                          ),
                                          Text(
                                            values[headings.indexOf(heading)],
                                            style: GoogleFonts.montserrat(
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              fontWeight: FontWeight.w400,
                                              color: MyColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Text(
                              'Add-Ons',
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.025,
                                fontWeight: FontWeight.w600,
                                color: MyColors.Yellow,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Column(
                                children: [
                                  for (var heading in addonsheadings)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: maximumDimension * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            heading,
                                            style: GoogleFonts.montserrat(
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              fontWeight: FontWeight.w500,
                                              color: MyColors.Yellow,
                                            ),
                                          ),
                                          Text(
                                            addonsvalues[addonsheadings
                                                .indexOf(heading)],
                                            style: GoogleFonts.montserrat(
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              fontWeight: FontWeight.w400,
                                              color: MyColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Text(
                              'Packages',
                              style: GoogleFonts.montserrat(
                                fontSize: maximumDimension * 0.025,
                                fontWeight: FontWeight.w600,
                                color: MyColors.Yellow,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.02),
                              child: Column(
                                children: listing['Package']
                                    .map((package) {
                                      return PackageBox(
                                          packagedetails:
                                              package['description'],
                                          packageprice:
                                              package['price'].toString(),
                                          packagename: package['name']);
                                    })
                                    .cast<Widget>()
                                    .toList(),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Reviews',
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.025,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                                Text(
                                  'View All',
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.015,
                                    fontWeight: FontWeight.w400,
                                    color: MyColors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: maximumDimension * 0.02,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${listing['reveiewData']['count'].toString()} Reviews',
                                    style: GoogleFonts.montserrat(
                                      fontSize: maximumDimension * 0.015,
                                      fontWeight: FontWeight.w400,
                                      color: MyColors.white,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Icon(Icons.star, color: MyColors.Yellow),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    "${listing['reveiewData']['average'].toString()}",
                                    style: GoogleFonts.montserrat(
                                        fontSize: maximumDimension * 0.015,
                                        color: MyColors.white),
                                  ),
                                ],
                              ),
                            ),
                            for (var star in stars)
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: maximumDimension * 0.01),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      star,
                                      style: GoogleFonts.montserrat(
                                        fontSize: maximumDimension * 0.015,
                                        fontWeight: FontWeight.w500,
                                        color: MyColors.white,
                                      ),
                                    ),
                                    Text(
                                      starsvalue[stars.indexOf(star)],
                                      style: GoogleFonts.montserrat(
                                        fontSize: maximumDimension * 0.015,
                                        fontWeight: FontWeight.w500,
                                        color: MyColors.Yellow,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: screenHeight * 0.05,
                              child: Center(
                                  child: MyDivider(
                                width: screenWidth * 0.85,
                              )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenHeight * 0.03),
                              child: Center(
                                  child: ColoredButton(text: 'Book Venue')),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
