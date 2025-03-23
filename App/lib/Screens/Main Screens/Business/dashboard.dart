import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic> user = {};
  String token = '';
  bool isLoading = true;
  GlobalKey headerKey = GlobalKey();
  String type = '';

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
    fetchData();
  }

  void fetchData() async {
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    type = await MyTokens.getBusinessType();
    ApiCall.fetchAPI('businessowner/accountInfo/$userid/$type',
        onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          token = token;
          user = data;
          isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Stack(
          children: [
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: MyColors.white,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(Screen.max(context) * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: (Screen.height(context) * 0.02) +
                                  UI_Management.headerHeight),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Screen.max(context) * 0.03,
                                vertical: Screen.max(context) * 0.02),
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
                                  radius: Screen.height(context) * 0.05,
                                  backgroundImage: NetworkImage(
                                    type == 'freelancer'
                                        ? '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']['profilePic']}'
                                        : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']['profilepic']}',
                                  ),
                                ),
                                SizedBox(width: Screen.width(context) * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user['businessInfo']['businessName'],
                                      style: GoogleFonts.montserrat(
                                        color: MyColors.Yellow,
                                        fontSize: Screen.max(context) * 0.02,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                        height: Screen.height(context) * 0.01),
                                    Text(
                                      "${user['listingCount']} Active Listings",
                                      style: GoogleFonts.montserrat(
                                        color: MyColors.white.withOpacity(0.7),
                                        fontSize: Screen.max(context) * 0.015,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Screen.height(context) * 0.01),
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
                key: headerKey,
                heading: "Business Dashboard",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback? onpressed) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
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
              radius: Screen.width(context) * 0.05,
              child: Icon(
                icon,
                color: MyColors.white,
                size: Screen.width(context) * 0.05,
              ),
            ),
            SizedBox(width: Screen.width(context) * 0.05),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: MyColors.white,
                fontSize: Screen.max(context) * 0.02,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: MyColors.white,
              size: Screen.max(context) * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
