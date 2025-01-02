import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/calendar.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryView_Photographer extends StatefulWidget {
  const CategoryView_Photographer({super.key});

  @override
  State<CategoryView_Photographer> createState() =>
      _CategoryView_PhotographerState();
}

class _CategoryView_PhotographerState extends State<CategoryView_Photographer> {
  String token = '';
  Map<String, dynamic> listing = {};
  late int? listingId;
  bool isLoading = true;

  int _currentIndex = 0;
  bool isToggled = true;
  List<String> headings = [
    'portfolio Link',
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
  DateTime? selectedDate = DateTime.now();
  Map<String, dynamic> events = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  bool type = false;
  bool ischange = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    setState(() {
      listingId = args['id'];
      type = args['isBusiness'];
    });
    if (!ischange) {
      fetchData();
    }
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final listing = await MyApi.getRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint: 'Photographer/viewpage/${this.listingId}');

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.listing = listing ?? {};
          if (listing == null || listing['status'] == 'error') {
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
            this.values.add(listing['View']['portfolioLink']);
            this.starsvalue.add('(${listing['reveiewData']['5'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['4'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['3'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['2'].toString()})');
            this.starsvalue.add('(${listing['reveiewData']['1'].toString()})');
            timer.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void showHierarchicalOptions(
      BuildContext context, double maxThing, double width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.Dark,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(maxThing * 0.02),
          decoration: BoxDecoration(
            color: MyColors.Dark,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(maxThing * 0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: maxThing * 0.02),
                child: Text(
                  "Choose for a Function",
                  style: GoogleFonts.montserrat(
                    fontSize: maxThing * 0.025,
                    fontWeight: FontWeight.w500,
                    color: MyColors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: events['Event']?.length ?? 0,
                  itemBuilder: (context, index) {
                    final event = events['Event'][index];
                    return Container(
                      margin: EdgeInsets.only(bottom: maxThing * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: MyColors.red,
                        ),
                        color: MyColors.DarkLighter,
                      ),
                      child: ExpansionTile(
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: MyColors.red,
                        collapsedBackgroundColor: MyColors.DarkLighter,
                        title: Text(
                          event['name'],
                          style: GoogleFonts.montserrat(
                            fontSize: maxThing * 0.015,
                            fontWeight: FontWeight.w400,
                            color: MyColors.white,
                          ),
                        ),
                        children: [
                          ...event['functions'].map<Widget>((function) {
                            return ListTile(
                              title: Text(
                                function['name'],
                                style: GoogleFonts.montserrat(
                                  fontSize: maxThing * 0.015,
                                  color: MyColors.whiteDarker,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onTap: () async {
                                final response = await MyApi.postRequest(
                                    headers: {'Authorization': 'Bearer $token'},
                                    endpoint: 'add/Bookcart/',
                                    body: {
                                      'fid': function['id'].toString(),
                                      'uid': await MyStorage.getToken(
                                              MyTokens.userId) ??
                                          "",
                                      'lid': listingId.toString(),
                                      'type': 'Venue',
                                      'slot': selectedDate.toString(),
                                    });

                                if (response['status'] == 'success') {
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Something went wrong',
                                        style: GoogleFonts.montserrat(
                                          fontSize: maxThing * 0.015,
                                          color: MyColors.white,
                                        ),
                                      ),
                                      backgroundColor: MyColors.red,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
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
                                          _imageUrls[index] == ' '
                                              ? 'https://tse2.mm.bing.net/th?id=OIP.dZWWg5LlJhlUFNNdNuLsIQHaEL&pid=Api&P=0&h=220'
                                              : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_imageUrls[index]}',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            _imageUrls.length, (index) {
                                          return AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
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
                                      GestureDetector(
                                        onTap: () {
                                          showHierarchicalOptions(context,
                                              maximumDimension, screenWidth);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: MyColors.Yellow,
                                          size: maximumDimension * 0.05,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight * 0.02),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                maximumDimension * 0.01),
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
                                              fontSize:
                                                  maximumDimension * 0.015,
                                              color: MyColors.white),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                maximumDimension * 0.01),
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
                                                fontSize:
                                                    maximumDimension * 0.015,
                                                fontWeight: FontWeight.w500,
                                                color: MyColors.Yellow,
                                              ),
                                            ),
                                            Text(
                                              listing['Listing']['basicPrice']
                                                  .toString(),
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
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight * 0.02),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        onTap: () => setState(
                                            () => isToggled = !isToggled),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: maximumDimension * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                listing['Listing']
                                                    ['description'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: isToggled ? 6 : 200,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: maximumDimension *
                                                        0.015,
                                                    fontWeight: FontWeight.w300,
                                                    color: MyColors.white),
                                                textAlign: TextAlign.justify,
                                              ),
                                              Icon(isToggled
                                                  ? Icons
                                                      .arrow_downward_outlined
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
                                              vertical:
                                                  maximumDimension * 0.01),
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
                                                values[
                                                    headings.indexOf(heading)],
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
                                              vertical:
                                                  maximumDimension * 0.01),
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
                                Text(
                                  'Available Slots',
                                  style: GoogleFonts.montserrat(
                                    fontSize: maximumDimension * 0.025,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: maximumDimension * 0.02,
                                      horizontal: maximumDimension * 0.01),
                                  child: CalendarView(
                                    onDateSelected: (date) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    },
                                    bookedDates: listing['bookedDates']
                                        .map((date) {
                                          return DateTime.parse(date);
                                        })
                                        .cast<DateTime>()
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
          Positioned(
              top: 0,
              child: Header(
                key: _headerKey,
              )),
        ],
      ),
    );
  }
}
