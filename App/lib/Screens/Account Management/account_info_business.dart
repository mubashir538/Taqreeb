import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/c_business_categories.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/providers/businessInfoViewModel.dart';
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
    UI_Management.getHeaderHeight(
      headerKey: headerKey,
      callback: (renderbox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderbox.size.height;
          });
        }
      },
    );
  }

  Future<void> _loadInitialData() async {
    final viewModel =
        Provider.of<BusinessAccountInfoViewModel>(context, listen: false);
    // Only fetch if we don't have data
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
    print("Current loading state: ${viewModel.isLoading}");

    // Safely get data with null checks
    final userInfo = viewModel.userInfo ?? {};
    final businessInfo = businessData.businessInfo;
    final items = viewModel.items;

    TextStyle style = GoogleFonts.montserrat(
      fontSize: Screen.max(context) * 0.015,
      fontWeight: FontWeight.w300,
      color: MyColors.white,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          if (viewModel.isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
              ),
            )
          else
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: UI_Management.headerHeight),
                  SizedBox(height: Screen.height(context) * 0.04),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: businessData.profileImageUrl != null
                        ? NetworkImage(businessData.profileImageUrl!)
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
                  ),
                  SizedBox(height: Screen.max(context) * 0.02),
                  Text(
                    businessInfo['businessName'] ?? 'No Business Name',
                    style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: Screen.max(context) * 0.03,
                    ),
                  ),
                  const MyDivider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Screen.width(context) * 0.04),
                    child: Text(
                      businessInfo['Description'] ?? 'No Description',
                      style: style,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.04,
                    child: const Center(child: MyDivider()),
                  ),
                  Container(
                    padding: EdgeInsets.all(Screen.max(context) * 0.03),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            SizedBox(width: Screen.width(context) * 0.02),
                            Text(
                              '${userInfo['city'] ?? 'Unknown City'}, Pakistan',
                              style: style,
                            ),
                          ],
                        ),
                        if (userInfo['email'] != null) ...[
                          SizedBox(height: Screen.height(context) * 0.015),
                          Row(
                            children: [
                              Icon(Icons.mail, color: MyColors.white),
                              SizedBox(width: Screen.width(context) * 0.02),
                              Text(userInfo['email'], style: style),
                            ],
                          ),
                        ],
                        if (userInfo['contactNumber'] != null) ...[
                          SizedBox(height: Screen.height(context) * 0.015),
                          Row(
                            children: [
                              Icon(Icons.phone, color: MyColors.white),
                              SizedBox(width: Screen.width(context) * 0.02),
                              Text(
                                userInfo['contactNumber'].toString(),
                                style: style,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.02,
                    child: const Center(child: MyDivider()),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: Screen.max(context) * 0.03,
                      left: Screen.max(context) * 0.03,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Category",
                          style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: Screen.max(context) * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.1,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ChecklistItemsAdder(text: items[index]);
                      },
                      scrollDirection: Axis.horizontal,
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
}
