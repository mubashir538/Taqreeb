import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey _headerKey = GlobalKey();
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  String _businessType = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
    _fetchData();
  }

  void _measureHeaderHeight() {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _fetchData() async {
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    _businessType = await MyTokens.getBusinessType();

    ApiCall.fetchAPI(
      'businessowner/accountInfo/$userId/$_businessType',
      onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            _userData = data;
            _isLoading = false;
          });
        }
      },
      context: mounted ? context : null,
    );
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await _fetchData();
  }

  Widget _buildProfileCard() {
    final profileImage = _businessType == 'freelancer'
        ? '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_userData['businessInfo']['profilePic']}'
        : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_userData['businessInfo']['profilepic']}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.03,
        vertical: Screen.max(context) * 0.02,
      ),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(102),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.red,
            radius: Screen.height(context) * 0.05,
            backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(width: Screen.width(context) * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userData['businessInfo']['businessName'],
                style: GoogleFonts.roboto(
                  color: MyColors.yellow,
                  fontSize: Screen.max(context) * 0.02,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Screen.height(context) * 0.01),
              Text(
                "${_userData['listingCount']} Active Listings",
                style: GoogleFonts.roboto(
                  color: MyColors.white.withAlpha(172),
                  fontSize: Screen.max(context) * 0.015,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(102),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: MyColors.red,
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
              style: GoogleFonts.roboto(
                color: MyColors.white,
                fontSize: Screen.max(context) * 0.02,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Stack(
          children: [
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: MyColors.white,
                ),
              )
            else
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(Screen.max(context) * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: (Screen.height(context) * 0.02) +
                            UI_Management.headerHeight,
                      ),
                      _buildProfileCard(),
                      SizedBox(height: Screen.height(context) * 0.01),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildDashboardOption(
                            title: "My Bookings",
                            icon: Icons.calendar_today,
                            onTap: () {},
                          ),
                          _buildDashboardOption(
                            title: "My Wallet",
                            icon: Icons.calendar_today,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/WalletScreen',
                              );
                            },
                          ),
                          _buildDashboardOption(
                            title: "My Messages",
                            icon: Icons.message,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/ChatsScreen',
                              );
                            },
                          ),
                          _buildDashboardOption(
                            title: "Manage Listings",
                            icon: Icons.business,
                            onTap: () {
                              Navigator.pushNamed(context, '/YourListings');
                            },
                          ),
                          _buildDashboardOption(
                            title: "Profile Settings",
                            icon: Icons.settings,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/BusinessInfoEdit',
                              );
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
      ),
    );
  }
}
