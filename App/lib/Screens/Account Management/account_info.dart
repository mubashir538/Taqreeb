import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
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
  Map<String, dynamic> _user = {};
  bool _isLoading = true;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeHeaderHeight();
    _fetchData();
  }

  void _initializeHeaderHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: (renderbox) {
          _changeHeight(renderbox);
        },
      );
    });
  }

  Future<void> _fetchData() async {
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    await ApiCall.fetchAPI('accountInfo/$userId/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          _user = data;
          _isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  void _changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final double size = Screen.max(context) * 0.03;

    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderbox) {
        _changeHeight(renderbox);
      },
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UImanagement.headerHeight),
                _buildIntroText(),
                _isLoading ? _buildLoadingIndicator() : _buildUserInfo(size),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "My Profile",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroText() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.02,
        vertical: Screen.max(context) * 0.03,
      ),
      child: Text(
        "Here is the account information for your profile, please review and ensure all details are accurate for a seamless experience.",
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.015,
          fontWeight: FontWeight.w400,
          color: MyColors.white,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildUserInfo(double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserProfile(size),
        _buildDivider(),
        if (_user['gender'] != null) _buildGenderInfo(size),
        if (_user['contactNumber'] != null) _buildPhoneInfo(size),
        if (_user['email'] != null) _buildEmailInfo(size),
        _buildLocationInfo(size),
      ],
    );
  }

  Widget _buildUserProfile(double size) {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: Screen.width(context) * 0.1,
            backgroundImage: NetworkImage(
              "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_user['profilePicture']}",
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Screen.width(context) * 0.5,
                margin: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  "${_capitalize(_user['firstName'])} ${_capitalize(_user['lastName'])}",
                  softWrap: true,
                  maxLines: 3,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w600,
                    color: MyColors.white,
                  ),
                ),
              ),
              Container(
                width: Screen.width(context) * 0.5,
                margin: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  _user['username'],
                  softWrap: true,
                  maxLines: 3,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w400,
                    color: MyColors.yellow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: Screen.height(context) * 0.05,
      child: Center(child: MyDivider()),
    );
  }

  Widget _buildGenderInfo(double size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
          child: Text(
            'Gender',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w700,
              color: MyColors.yellow,
            ),
          ),
        ),
        SizedBox(
          width: Screen.width(context) * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                MyIcons.profile,
                width: size,
                height: size,
                colorFilter: ColorFilter.mode(
                  MyColors.white, // Your desired color
                  BlendMode.srcIn, // Ensures the SVG takes the specified color
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  _user['gender'],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildPhoneInfo(double size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
          child: Text(
            'Phone',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w700,
              color: MyColors.yellow,
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
                Icons.phone,
                color: MyColors.white,
                size: size,
              ),
              Padding(
                padding: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  _user['contactNumber'],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildEmailInfo(double size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
          child: Text(
            'Email',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w700,
              color: MyColors.yellow,
            ),
          ),
        ),
        SizedBox(
          width: Screen.width(context) * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                MyIcons.email,
                width: size,
                height: size,
                color: MyColors.white,
              ),
              Padding(
                padding: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  _user['email'],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildLocationInfo(double size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
          child: Text(
            'Location',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w700,
              color: MyColors.yellow,
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
                padding: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  _user['city'],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w200,
                    color: MyColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildDivider(),
      ],
    );
  }
}
