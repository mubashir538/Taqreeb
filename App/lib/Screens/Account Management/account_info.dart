import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/utils/color.dart';

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
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
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
    final colors = AppColors(context);

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
          color: colors.white,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    final colors = AppColors(context);

    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.white),
      ),
    );
  }

  Widget _buildUserInfo(double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildUserProfile(size),
        SizedBox(height: Screen.max(context) * 0.03),
        if (_user['gender'] != null)
          _buildInfoCard(
              size, FontAwesomeIcons.person, _user['gender'], 'Gender'),
        if (_user['contactNumber'] != null)
          _buildInfoCard(
              size, FontAwesomeIcons.phone, _user['contactNumber'], 'Phone'),
        if (_user['email'] != null)
          _buildInfoCard(
              size, FontAwesomeIcons.envelope, _user['email'], 'Email'),
        _buildInfoCard(
            size, FontAwesomeIcons.locationPin, _user['city'], 'Address'),
        SizedBox(height: Screen.max(context) * 0.02),
        ColoredButton(
            text: 'Edit Profile',
            onPressed: () async {
              if (await MyTokens.getBusinessType() == 'user') {
                context.pushNamedTransition(
                    routeName: '/AccountInfoEdit',
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(milliseconds: 300));
              } else {
                context.pushNamedTransition(
                    routeName: '/BusinessAccountInfoEdit',
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(milliseconds: 300));
              }
            }),
      ],
    );
  }

  Widget _buildUserProfile(double size) {
    final colors = AppColors(context);

    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.yellow, width: 3),
            ),
            child: CircleAvatar(
              radius: Screen.width(context) * 0.1,
              backgroundImage: NetworkImage(
                "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_user['profilePicture']}",
              ),
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
                  maxLines: 2,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.w700,
                    color: colors.white,
                  ),
                ),
              ),
              Container(
                width: Screen.width(context) * 0.5,
                margin: EdgeInsets.only(left: Screen.max(context) * 0.02),
                child: Text(
                  _user['username'],
                  softWrap: true,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.015,
                    fontWeight: FontWeight.w500,
                    color: colors.yellow,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      double size, IconData icon, String text, String heading) {
    final colors = AppColors(context);
    
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.darkLighter,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(Screen.max(context) * 0.03),
          margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
          width: Screen.width(context) * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                heading,
                style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w700,
                  color: colors.yellow,
                ),
              ),
              SizedBox(height: Screen.max(context) * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: size,
                    color: colors.white,
                  ),
                  SizedBox(width: Screen.max(context) * 0.03),
                  SizedBox(
                    width: Screen.width(context) * 0.6,
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      softWrap: true,
                      maxLines: 2,
                      overflow: text.length > 15
                          ? TextOverflow.clip
                          : TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: Screen.max(context) * 0.02,
                        fontWeight: FontWeight.w500,
                        color: colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
