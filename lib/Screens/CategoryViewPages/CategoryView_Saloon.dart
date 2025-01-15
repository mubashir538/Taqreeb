import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/PricingSection.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/categoryAddons.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/categoryPackages.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/categoryReview.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/categorySlots.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/categorydetails.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/descriptionCategory.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/imageslider.dart';
import 'package:taqreeb/Screens/CategoryViewPages/components/upperheadings.dart';

class CategoryView_Saloon extends StatefulWidget {
  const CategoryView_Saloon({super.key});

  @override
  State<CategoryView_Saloon> createState() => _CategoryView_SaloonState();
}

class _CategoryView_SaloonState extends State<CategoryView_Saloon> {
  String token = '';
  Map<String, dynamic> listing = {};
  late int? listingId;
  bool isLoading = true;
  bool ischange = false;
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
  DateTime? selectedDate = DateTime.now();
  bool type = false;
  Map<String, dynamic> events = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

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
        endpoint: 'saloonviewpage/${this.listingId}');

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
            ischange = true;
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
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: _headerHeight),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
                      ))
                    : Column(
                        children: [
                          ImageSliderCategory(
                            imageUrls: _imageUrls,
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
                                UpperHeadings(
                                    listing: listing,
                                    type: type,
                                    listingId: listingId,
                                    selectedDate: selectedDate,
                                    events: events),
                                SizedBox(
                                  height: screenHeight * 0.05,
                                  child: Center(
                                      child: MyDivider(
                                    width: screenWidth * 0.85,
                                  )),
                                ),
                                PricingSection(listing: listing),
                                DescriptionCategory(listing: listing),
                                CategoryDetails(
                                    headings: headings, values: values),
                                addonsheadings.length != 0
                                    ? CategoryAddons(
                                        addonsheadings: addonsheadings,
                                        addonsvalues: addonsvalues,
                                      )
                                    : Container(),
                                listing['Package'].length != 0
                                    ? CategoryPackages(listing: listing)
                                    : Container(),
                                CategorySlots(
                                  listing: listing,
                                  onDateSelected: (date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.05,
                                  child: Center(
                                      child: MyDivider(
                                    width: screenWidth * 0.85,
                                  )),
                                ),
                                CategoryReview(
                                    listing: listing, starsvalue: starsvalue),
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
            ),
          ),
        ],
      ),
    );
  }
}
