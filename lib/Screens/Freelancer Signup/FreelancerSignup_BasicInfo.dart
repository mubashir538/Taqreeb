import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';

class FreelancerSignup_BasicInfo extends StatefulWidget {
  const FreelancerSignup_BasicInfo({super.key});

  @override
  State<FreelancerSignup_BasicInfo> createState() =>
      _FreelancerSignup_BasicInfoState();
}

class _FreelancerSignup_BasicInfoState
    extends State<FreelancerSignup_BasicInfo> {
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController portfoliocontroller = TextEditingController();
  FocusNode fullnameFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode portfolioFocus = FocusNode();
 

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: (MaximumThing * 0.05) + _headerHeight,
                ),
                MyTextBox(
                  focusNode: fullnameFocus,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(usernameFocus);
                  },
                  hint: "Enter Full Business Name",
                  valueController: fullnamecontroller,
                ),
                MyTextBox(
                  focusNode: usernameFocus,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(portfolioFocus);
                  },
                  hint: "Enter Username",
                  valueController: usernamecontroller,
                ),
                MyTextBox(
                  focusNode: portfolioFocus, 
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  hint: "Enter Portfolio Link",
                  valueController: portfoliocontroller,
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: MyDivider(),
                ),
                ColoredButton(
                  text: "Continue",
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/FreelancerSignup_Description');
                  },
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Create A Freelancer Account",
              para:
                  "Earn a Soothing Income by Editing Videos or Pictures of Events",
              image: MyImages.FreelancerSignup,
            ),
          ),
        ],
      ),
    );
  }
}
