import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  String token = '';
  Map<String, dynamic> user = {};
  bool isLoading = true;
  GlobalKey headerKey = GlobalKey();

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
    await ApiCall.fetchAPI('accountInfo/$userid', onSuccess: (token, data) {
      user = user;
      token = token;
    }, context: mounted ? context : null);
    isLoading = false;
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    double size = Screen.max(context) * 0.03;
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Container(
            child: Column(children: [
              SizedBox(
                height: UI_Management.headerHeight,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Screen.max(context) * 0.02,
                    vertical: Screen.max(context) * 0.03),
                child: Text(
                    "Here is the account information for your profile,please review and ensure all details are accurate for a seamless experience.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.015,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white)),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          SizedBox(
                            width: Screen.width(context) * 0.9,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: Screen.width(context) * 0.1,
                                    backgroundImage: NetworkImage(
                                        "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}"),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Screen.width(context) * 0.5,
                                        margin: EdgeInsets.only(
                                            left: Screen.max(context) * 0.02),
                                        child: Text(
                                          "${_capitalize(user['firstName'])} ${_capitalize(user['lastName'])}",
                                          softWrap: true,
                                          maxLines: 3,
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  Screen.max(context) * 0.02,
                                              fontWeight: FontWeight.w600,
                                              color: MyColors.white),
                                        ),
                                      ),
                                      Container(
                                        width: Screen.width(context) * 0.5,
                                        margin: EdgeInsets.only(
                                            left: Screen.max(context) * 0.02),
                                        child: Text(
                                          user['username'],
                                          softWrap: true,
                                          maxLines: 3,
                                          style: GoogleFonts.montserrat(
                                              fontSize:
                                                  Screen.max(context) * 0.015,
                                              fontWeight: FontWeight.w400,
                                              color: MyColors.Yellow),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: Screen.height(context) * 0.05,
                            child: Center(child: MyDivider()),
                          ),
                          user['gmail'] == null
                              ? Container()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Screen.max(context) * 0.02),
                                      child: Text(
                                        'Gender',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: Screen.max(context) * 0.02,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Screen.width(context) * 0.8,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              MyIcons.profile,
                                              width: size,
                                              height: size,
                                              color: MyColors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Screen.max(context) *
                                                      0.02),
                                              child: Text(
                                                user['gender'],
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      Screen.max(context) *
                                                          0.015,
                                                  fontWeight: FontWeight.w200,
                                                  color: MyColors.white,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: Screen.height(context) * 0.05,
                                      child: Center(
                                          child: MyDivider(
                                              width:
                                                  Screen.width(context) * 0.7)),
                                    ),
                                  ],
                                ),
                          user['contactNumber'] == null
                              ? Container()
                              : Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Screen.max(context) * 0.02),
                                      child: Text(
                                        'Phone',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: Screen.max(context) * 0.02,
                                          fontWeight: FontWeight.w700,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Screen.width(context) * 0.8,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: MyColors.white,
                                              size: size,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: Screen.max(context) *
                                                      0.02),
                                              child: Text(
                                                user['contactNumber'],
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      Screen.max(context) *
                                                          0.015,
                                                  fontWeight: FontWeight.w200,
                                                  color: MyColors.white,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: Screen.height(context) * 0.05,
                                      child: Center(
                                          child: MyDivider(
                                              width:
                                                  Screen.width(context) * 0.7)),
                                    ),
                                  ],
                                ),
                          user['email'] == null
                              ? Container()
                              : Column(children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Screen.max(context) * 0.02),
                                    child: Text(
                                      'Email',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Screen.max(context) * 0.02,
                                        fontWeight: FontWeight.w700,
                                        color: MyColors.Yellow,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Screen.width(context) * 0.8,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            MyIcons.email,
                                            width: size,
                                            height: size,
                                            color: MyColors.white,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left:
                                                    Screen.max(context) * 0.02),
                                            child: Text(
                                              user['email'],
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.montserrat(
                                                fontSize:
                                                    Screen.max(context) * 0.015,
                                                fontWeight: FontWeight.w200,
                                                color: MyColors.white,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  SizedBox(
                                    height: Screen.height(context) * 0.05,
                                    child: Center(
                                        child: MyDivider(
                                            width:
                                                Screen.width(context) * 0.7)),
                                  ),
                                ]),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Screen.max(context) * 0.02),
                            child: Text(
                              'Location',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: Screen.max(context) * 0.02,
                                fontWeight: FontWeight.w700,
                                color: MyColors.Yellow,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Screen.width(context) * 0.8,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: MyColors.white,
                                    size: size,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Screen.max(context) * 0.02),
                                    child: Text(
                                      user['city'],
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Screen.max(context) * 0.015,
                                        fontWeight: FontWeight.w200,
                                        color: MyColors.white,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: Screen.height(context) * 0.05,
                            child: Center(
                                child: MyDivider(
                                    width: Screen.width(context) * 0.7)),
                          ),
                        ])
            ]),
          )),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: "My Profile",
            ),
          ),
        ],
      ),
    );
  }
}
