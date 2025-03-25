import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/c_business_categories.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/providers/businessInfoViewModel.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessAccountInfo extends StatefulWidget {
  const BusinessAccountInfo({super.key});

  @override
  State<BusinessAccountInfo> createState() => _BusinessAccountInfoState();
}

class _BusinessAccountInfoState extends State<BusinessAccountInfo> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          setState(() {
            UI_Management.headerHeight = renderbox.size.height;
          });
        },
      );
      Provider.of<BusinessAccountInfoViewModel>(context, listen: false)
          .fetch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BusinessAccountInfoViewModel>(context);
    final user = viewModel.user;
    final items = viewModel.items;

    TextStyle style = GoogleFonts.montserrat(
      fontSize: Screen.max(context) * 0.015,
      fontWeight: FontWeight.w300,
      color: MyColors.white,
    );

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: viewModel.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: UI_Management.headerHeight),
                      SizedBox(height: Screen.height(context) * 0.04),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']['profilepic']}',
                        ),
                      ),
                      SizedBox(height: Screen.max(context) * 0.02),
                      Text(
                        user['businessInfo']['businessName'],
                        style: GoogleFonts.montserrat(
                          color: MyColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: Screen.max(context) * 0.03,
                        ),
                      ),
                      MyDivider(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Screen.width(context) * 0.04,
                        ),
                        child: Text(
                          user['businessInfo']['Description'],
                          style: style,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context) * 0.04,
                        child: Center(child: MyDivider()),
                      ),
                      Container(
                        padding: EdgeInsets.all(Screen.max(context) * 0.03),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined),
                                SizedBox(width: Screen.width(context) * 0.02),
                                Text(
                                  '${user['userinfo']['city']},Pakistan',
                                  style: style,
                                ),
                              ],
                            ),
                            if (user['userinfo']['email'] != null)
                              Column(
                                children: [
                                  SizedBox(
                                      height: Screen.height(context) * 0.015),
                                  Row(
                                    children: [
                                      Icon(Icons.mail, color: MyColors.white),
                                      SizedBox(
                                          width: Screen.width(context) * 0.02),
                                      Text(user['userinfo']['email'],
                                          style: style),
                                    ],
                                  ),
                                ],
                              ),
                            if (user['userinfo']['contactNumber'] != null)
                              Column(
                                children: [
                                  SizedBox(
                                      height: Screen.height(context) * 0.015),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: MyColors.white),
                                      SizedBox(
                                          width: Screen.width(context) * 0.02),
                                      Text(
                                        user['userinfo']['contactNumber']
                                            .toString(),
                                        style: style,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context) * 0.02,
                        child: Center(child: MyDivider()),
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
