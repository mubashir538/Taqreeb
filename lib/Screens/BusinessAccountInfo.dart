import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Checklist%20Items%20Adder.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';

class BusinessAccountInfo extends StatefulWidget {
  BusinessAccountInfo({super.key});

  @override
  State<BusinessAccountInfo> createState() => _BusinessAccountInfoState();
}

class _BusinessAccountInfoState extends State<BusinessAccountInfo> {
  String token = '';
  Map<String, dynamic> user = {}; 
  bool isLoading = true; 
  List<String> items = [];
  String type = "";
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());

    fetchData();
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final Userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    type = await MyTokens.getBusinessType();
    final user = await MyApi.getRequest(
      endpoint: 'businessowner/accountInfo/$Userid/$type',
      headers: {'Authorization': 'Bearer $token'},
    );

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.user = user ?? {}; 
          if (user == null || user['status'] == 'error') {
            print('$user');
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
            this.items = user['categories'].cast<String>().toList() ?? [];
            isLoading = false;
          }
        });
      }
    });
  }
  
@override
void dispose(){
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextStyle style = GoogleFonts.montserrat(
      fontSize: MaximumThing * 0.015,
      fontWeight: FontWeight.w300,
      color: MyColors.white,
    );

    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: _headerHeight,
                        ),
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            type == 'freelancer'
                                ? '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']['profilePic']}'
                                : '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']['profilepic']}',
                          ),
                        ),
                        SizedBox(
                          height: MaximumThing * 0.02,
                        ),
                        Text(
                          user['businessInfo']['businessName'],
                          style: GoogleFonts.montserrat(
                              color: MyColors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: MaximumThing * 0.03),
                        ),
                        MyDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04),
                          child: Text(
                            type == 'freelancer'
                                ? user['businessInfo']['description']
                                : user['businessInfo']['Description'],
                            style: style,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.04,
                            child: Center(child: MyDivider())),
                        Container(
                          padding: EdgeInsets.all(MaximumThing * 0.03),
                          child: Column(
                            children: [
                              Row(children: [
                                Icon(Icons.location_on_outlined),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  '${user['userinfo']['city']},Pakistan',
                                  style: style,
                                )
                              ]),
                              user['userinfo']['email'] == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.015,
                                        ),
                                        Row(children: [
                                          Icon(Icons.mail,
                                              color: MyColors.white),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text(user['userinfo']['email'],
                                              style: style)
                                        ]),
                                      ],
                                    ),
                              user['userinfo']['contactNumber'] == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.015,
                                        ),
                                        Row(children: [
                                          Icon(
                                            Icons.phone,
                                            color: MyColors.white,
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          Text(
                                              user['userinfo']['contactNumber']
                                                  .toString(),
                                              style: style)
                                        ]),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.02,
                            child: Center(child: MyDivider())),
                        Container(
                          margin: EdgeInsets.only(
                              top: MaximumThing * 0.03,
                              left: MaximumThing * 0.03),
                          child: Row(
                            children: [
                              Text(
                                "Category",
                                style: GoogleFonts.montserrat(
                                    color: MyColors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: MaximumThing * 0.02),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ChecklistItemsAdder(text: items[index]);
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        )
                      ],
                    )),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Account Info",
            ),
          ),
        ],
      ),
    );
  }
}
