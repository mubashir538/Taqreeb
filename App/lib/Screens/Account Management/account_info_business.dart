import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/c_business_categories.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/business_info_view_model.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessAccountInfo extends StatefulWidget {
  const BusinessAccountInfo({super.key});

  @override
  State<BusinessAccountInfo> createState() => _BusinessAccountInfoState();
}

class _BusinessAccountInfoState extends State<BusinessAccountInfo> {
  final GlobalKey headerKey = GlobalKey();

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
      headerKey: headerKey,
      callback: (renderbox) {
        if (mounted) {
          setState(() {
            UImanagement.headerHeight = renderbox.size.height;
          });
        }
      },
    );
  }

  Future<void> _loadInitialData() async {
    final viewModel =
        Provider.of<BusinessAccountInfoViewModel>(context, listen: false);
    if (viewModel.userInfo.isEmpty) {
      try {
        await viewModel.fetch(context);
      } catch (e) {
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BusinessAccountInfoViewModel>(context);
    final businessData = Provider.of<BusinessData>(context);
    final userInfo = viewModel.userInfo;
    final businessInfo = businessData.businessInfo;
    final items = viewModel.items;

    // Responsive text styles
    final double titleSize = Screen.max(context) * 0.03;
    final double bodySize = Screen.max(context) * 0.016;
    final double iconSize = Screen.max(context) * 0.025;

    final colors = AppColors(context);

    TextStyle titleStyle = GoogleFonts.roboto(
      fontSize: titleSize,
      fontWeight: FontWeight.w600,
      color: colors.white,
    );

    TextStyle bodyStyle = GoogleFonts.roboto(
      fontSize: bodySize,
      fontWeight: FontWeight.w400,
      color: colors.white.withOpacity(0.9),
    );

    TextStyle sectionTitleStyle = GoogleFonts.roboto(
      fontSize: titleSize * 0.9,
      fontWeight: FontWeight.w500,
      color: colors.white,
    );

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          if (viewModel.isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colors.white),
              ),
            )
          else
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: UImanagement.headerHeight),
                  SizedBox(height: Screen.height(context) * 0.03),

                  // Profile Section
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Screen.width(context) * 0.05,
                      vertical: Screen.height(context) * 0.02,
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.red,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: Screen.max(context) * 0.07,
                                backgroundImage:
                                    businessData.profileImageUrl != null
                                        ? NetworkImage(
                                            businessData.profileImageUrl!)
                                        : const AssetImage(
                                                'assets/default_profile.png')
                                            as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Screen.height(context) * 0.02),
                        Text(
                          businessInfo['businessName'] ?? 'No Business Name',
                          style: titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Screen.height(context) * 0.01),
                        Container(
                          width: Screen.width(context) * 0.3,
                          height: 2,
                          color: colors.red.withOpacity(0.5),
                        ),
                        SizedBox(height: Screen.height(context) * 0.02),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Screen.width(context) * 0.05,
                          ),
                          child: Text(
                            businessInfo['Description'] ?? 'No Description',
                            style: bodyStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider with icon
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Screen.height(context) * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: colors.red,
                        ),
                        SizedBox(width: Screen.width(context) * 0.03),
                        Container(
                          width: Screen.width(context) * 0.3,
                          height: 1,
                          color: colors.red.withOpacity(0.3),
                        ),
                        SizedBox(width: Screen.width(context) * 0.03),
                        Icon(
                          FontAwesomeIcons.circle,
                          size: 8,
                          color: colors.red,
                        ),
                      ],
                    ),
                  ),

                  // Contact Info Section
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: Screen.width(context) * 0.05,
                    ),
                    padding: EdgeInsets.all(Screen.max(context) * 0.025),
                    decoration: BoxDecoration(
                      color: colors.darkLighter,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.red,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: sectionTitleStyle,
                        ),
                        SizedBox(height: Screen.height(context) * 0.015),
                        _buildInfoRow(
                          context,
                          icon: FontAwesomeIcons.locationDot,
                          text:
                              '${userInfo['city'] ?? 'Unknown City'}, Pakistan',
                          iconSize: iconSize,
                          style: bodyStyle,
                        ),
                        if (userInfo['email'] != null) ...[
                          SizedBox(height: Screen.height(context) * 0.015),
                          _buildInfoRow(
                            context,
                            icon: FontAwesomeIcons.envelope,
                            text: userInfo['email'],
                            iconSize: iconSize,
                            style: bodyStyle,
                          ),
                        ],
                        if (userInfo['contactNumber'] != null) ...[
                          SizedBox(height: Screen.height(context) * 0.015),
                          _buildInfoRow(
                            context,
                            icon: FontAwesomeIcons.phone,
                            text: userInfo['contactNumber'].toString(),
                            iconSize: iconSize,
                            style: bodyStyle,
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: Screen.height(context) * 0.03),

                  // Categories Section
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                      horizontal: Screen.width(context) * 0.05,
                    ),
                    padding: EdgeInsets.all(Screen.max(context) * 0.025),
                    decoration: BoxDecoration(
                      color: colors.darkLighter,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.red,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Business Categories",
                          style: sectionTitleStyle,
                        ),
                        SizedBox(height: Screen.height(context) * 0.015),
                        SizedBox(
                          height: Screen.height(context) * 0.12,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: Screen.width(context) * 0.03,
                                ),
                                child: ChecklistItemsAdder(text: items[index]),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                              horizontal: Screen.width(context) * 0.01,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Screen.height(context) * 0.05),
                ],
              ),
            ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: "Account Info",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    required double iconSize,
    required TextStyle style,
  }) {
    final colors = AppColors(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: colors.red,
        ),
        SizedBox(width: Screen.width(context) * 0.03),
        Expanded(
          child: Text(
            text,
            style: style,
          ),
        ),
      ],
    );
  }
}
