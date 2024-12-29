import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart'; // Adjust the path to your MyColors class

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic> user = {}; // Initialize as empty map
  String token = '';
  bool isLoading = true; // Add a loading flag

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    fetchData(); // Fetch data in a separate method
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final Userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    final user = await MyApi.getRequest(
      endpoint: 'businessowner/accountInfo/$Userid',
      headers: {'Authorization': 'Bearer $token'},
    );

    // Update the state
    setState(() {
      this.token = token;
      this.user = user ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: MyColors.white,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(maximumDimension * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: (screenHeight * 0.02) + _headerHeight),
                        // Profile Info Section
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: maximumDimension * 0.03,
                              vertical: maximumDimension * 0.02),
                          decoration: BoxDecoration(
                            color: MyColors.DarkLighter,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: MyColors.red,
                                radius: screenHeight * 0.05,
                                backgroundImage: NetworkImage(
                                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']['profilepic']}',
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['businessInfo']['businessName'],
                                    style: GoogleFonts.montserrat(
                                      color: MyColors.Yellow,
                                      fontSize: maximumDimension * 0.02,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    "${user['listingCount']} Active Listings",
                                    style: GoogleFonts.montserrat(
                                      color: MyColors.white.withOpacity(0.7),
                                      fontSize: maximumDimension * 0.015,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        // Dashboard Options
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildOptionCard(context, "My Bookings",
                                Icons.calendar_today, MyColors.red, () {}),
                            _buildOptionCard(
                              context,
                              "My Messages",
                              Icons.message,
                              MyColors.red,
                              () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/ChatsScreen', ModalRoute.withName('/'));
                            },
                            ),
                            _buildOptionCard(
                              context,
                              "Manage Listings",
                              Icons.business,
                              MyColors.red,
                              () {
                                Navigator.pushNamed(context, '/YourListings');
                              },
                            ),
                            _buildOptionCard(
                              context,
                              "Profile Settings",
                              Icons.settings,
                              MyColors.red,
                              () {
                                Navigator.pushNamed(
                                    context, '/BusinessAccountInfo');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Business Dashboard",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback? onpressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maximumDimension = screenWidth > MediaQuery.of(context).size.height
        ? screenWidth
        : MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onpressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: maximumDimension * 0.01),
        padding: EdgeInsets.all(maximumDimension * 0.02),
        decoration: BoxDecoration(
          color: MyColors.DarkLighter,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              radius: screenWidth * 0.05,
              child: Icon(
                icon,
                color: MyColors.white,
                size: screenWidth * 0.05,
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: MyColors.white,
                fontSize: maximumDimension * 0.02,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: MyColors.white,
              size: maximumDimension * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
