import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  String token = '';
  Map<String, dynamic> user = {}; // Initialize as empty map
  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data in a separate method
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken('accessToken') ?? "";
    final Userid = await MyStorage.getToken('userId') ?? "";
    final user = await MyApi.getRequest(endpoint: 'accountInfo/$Userid');

    // Update the state
    setState(() {
      this.token = token;
      this.user = user ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
      
      print("${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}");
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    double size = MaximumThing * 0.03;
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        child: Column(children: [
          Header(
            heading: "My Profile",
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MaximumThing * 0.02, vertical: MaximumThing * 0.03),
            child: Text(
                "Here is the account information for your profile,please review and ensure all details are accurate for a seamless experience.",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: MaximumThing * 0.015,
                    fontWeight: FontWeight.w400,
                    color: MyColors.white)),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(MyColors.Yellow),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      //Circle Avatar
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.1,
                                backgroundImage: NetworkImage(
                                    "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}"),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: MaximumThing * 0.02),
                                child: Column(
                                  children: [
                                    Text(
                                      "${user['firstName']} ${user['lastName']}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: MaximumThing * 0.02,
                                          fontWeight: FontWeight.w600,
                                          color: MyColors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),

                      SizedBox(
                        height: screenHeight * 0.05,
                        child: Center(child: MyDivider()),
                      ),

                      //Gender
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                        child: Text(
                          'Gender',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w700,
                            color: MyColors.Yellow,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: screenWidth * 0.8,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                MyIcons.profile,
                                width: size,
                                height: size,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: MaximumThing * 0.02),
                                child: Text(
                                  user['gender'],
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.015,
                                    fontWeight: FontWeight.w200,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                            ]),
                      ),

                      SizedBox(
                        height: screenHeight * 0.05,
                        child:
                            Center(child: MyDivider(width: screenWidth * 0.7)),
                      ),

                      user['contactNumber'] == null
                          ? Container()
                          : Column(
                              children: [
                                //Phone
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: MaximumThing * 0.02),
                                  child: Text(
                                    'Phone',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: MaximumThing * 0.02,
                                      fontWeight: FontWeight.w700,
                                      color: MyColors.Yellow,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: screenWidth * 0.8,
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
                                              left: MaximumThing * 0.02),
                                          child: Text(
                                            user['contactNumber'],
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.montserrat(
                                              fontSize: MaximumThing * 0.015,
                                              fontWeight: FontWeight.w200,
                                              color: MyColors.white,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),

                                SizedBox(
                                  height: screenHeight * 0.05,
                                  child: Center(
                                      child:
                                          MyDivider(width: screenWidth * 0.7)),
                                ),
                              ],
                            ),

                      user['email'] == null
                          ? Container()
                          : Column(children: [
                              //Email
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: MaximumThing * 0.02),
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.02,
                                    fontWeight: FontWeight.w700,
                                    color: MyColors.Yellow,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: screenWidth * 0.8,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            left: MaximumThing * 0.02),
                                        child: Text(
                                          user['email'],
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.montserrat(
                                            fontSize: MaximumThing * 0.015,
                                            fontWeight: FontWeight.w200,
                                            color: MyColors.white,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),

                              SizedBox(
                                height: screenHeight * 0.05,
                                child: Center(
                                    child: MyDivider(width: screenWidth * 0.7)),
                              ),
                            ]),
                      //Location
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                        child: Text(
                          'Location',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: MaximumThing * 0.02,
                            fontWeight: FontWeight.w700,
                            color: MyColors.Yellow,
                          ),
                        ),
                      ),

                      SizedBox(
                        width: screenWidth * 0.8,
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
                                padding:
                                    EdgeInsets.only(left: MaximumThing * 0.02),
                                child: Text(
                                  user['city'],
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.015,
                                    fontWeight: FontWeight.w200,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                            ]),
                      ),

                      SizedBox(
                        height: screenHeight * 0.05,
                        child:
                            Center(child: MyDivider(width: screenWidth * 0.7)),
                      ),
                    ])
        ]),
      )),
    );
  }
}
