import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/business_edit_info_view_model.dart';
import 'package:taqreeb/core/providers/business_info_view_model.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey _headerKey = GlobalKey();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeaderHeight();
      _loadInitialData();
    });
  }

  void _measureHeaderHeight() {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UImanagement.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _loadInitialData() async {
    final viewModel =
        Provider.of<BusinessAccountInfoViewModel>(context, listen: false);
    await viewModel.fetch(context);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Provider.of<BusinessAccountInfoViewModel>(context, listen: false)
        .fetch(context);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildProfileCard(BusinessData businessData) {
    final businessInfo = businessData.businessInfo;
    final listingCount = businessData.businessInfo['listingCount'] ?? 0;

    final profileImage = businessData.profileImageUrl != null
        ? NetworkImage(businessData.profileImageUrl!)
        : const AssetImage('assets/default_profile.png') as ImageProvider;

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
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.red,
            radius: Screen.height(context) * 0.05,
            backgroundImage: profileImage,
          ),
          SizedBox(width: Screen.width(context) * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                businessInfo['businessName'] ?? 'No Business Name',
                style: GoogleFonts.roboto(
                  color: MyColors.yellow,
                  fontSize: Screen.max(context) * 0.02,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Screen.height(context) * 0.01),
              Text(
                "$listingCount Active Listings",
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
                            UImanagement.headerHeight,
                      ),
                      Consumer2<BusinessInfoEditViewModel, BusinessData>(
                          builder: (context, viewModel, businessData, child) {
                        return _buildProfileCard(businessData);
                      }),
                      SizedBox(height: Screen.height(context) * 0.01),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildDashboardOption(
                            title: "My Bookings",
                            icon: Icons.calendar_today,
                            onTap: () => Navigator.pushNamed(
                                context, '/BusinessBookings'),
                          ),
                          _buildDashboardOption(
                            title: "My Wallet",
                            icon: Icons.wallet,
                            onTap: () =>
                                Navigator.pushNamed(context, '/WalletScreen'),
                          ),
                          _buildDashboardOption(
                            title: "My Messages",
                            icon: Icons.message,
                            onTap: () =>
                                Navigator.pushNamed(context, '/ChatsScreen'),
                          ),
                          _buildDashboardOption(
                            title: "Manage Slots",
                            icon: Icons.access_time,
                            onTap: () => Navigator.pushNamed(
                                context, '/UpdateBookedSlots'),
                          ),
                          _buildDashboardOption(
                            title: "Manage Listings",
                            icon: Icons.business,
                            onTap: () =>
                                Navigator.pushNamed(context, '/YourListings'),
                          ),
                          _buildDashboardOption(
                            title: "Profile Settings",
                            icon: Icons.settings,
                            onTap: () => Navigator.pushNamed(
                                context, '/BusinessInfoEdit'),
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
