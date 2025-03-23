import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class FreelancerSignup_BasicInfo extends StatefulWidget {
  const FreelancerSignup_BasicInfo({super.key});

  @override
  State<FreelancerSignup_BasicInfo> createState() =>
      _FreelancerSignup_BasicInfoState();
}

class _FreelancerSignup_BasicInfoState
    extends State<FreelancerSignup_BasicInfo> {
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController cniccontroller = TextEditingController();
  TextEditingController portfoliocontroller = TextEditingController();
  FocusNode fullnameFocus = FocusNode();
  FocusNode cnicFocus = FocusNode();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHeaderHeight();

      check(context);
    });
  }

  void check(BuildContext context) async {
    if (await MyStorage.exists(MyTokens.bscnic) &&
        await MyStorage.exists(MyTokens.bsusername) &&
        await MyStorage.exists(MyTokens.bsname)) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to do Freelancer Signup in the app Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken(MyTokens.fscnic);
              MyStorage.deleteToken(MyTokens.fsname);
              MyStorage.deleteToken(MyTokens.fsdescription);

              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists(MyTokens.fsdescription)) {
                Navigator.pushNamed(context, '/ProfilePictureUpload',
                    arguments: {'type': 'Freelancer'});
              } else {
                Navigator.pushNamed(context, '/FreelancerSignup_Description');
              }
            },
          )
        ],
      ).showDialogBox(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.max(context) * 0.05) + _headerHeight,
                  ),
                  MyTextBox(
                    focusNode: fullnameFocus,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(cnicFocus);
                    },
                    hint: "Enter Business Name",
                    valueController: fullnamecontroller,
                  ),
                  MyTextBox(
                    focusNode: cnicFocus,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(portfolioFocus);
                    },
                    hint: "Enter CNIC Number",
                    valueController: cniccontroller,
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
                    height: Screen.height(context) * 0.05,
                    child: MyDivider(),
                  ),
                  ColoredButton(
                    text: "Continue",
                    onPressed: () {
                      if (cniccontroller.text.isEmpty ||
                          fullnamecontroller.text.isEmpty ||
                          portfoliocontroller.text.isEmpty) {
                        warningDialog(
                          message: "Please fill all the details",
                          title: "Invalid Details",
                        ).showDialogBox(context);
                      } else if (Validations.validateCNIC(
                              cniccontroller.text) !=
                          'Ok') {
                        warningDialog(
                          message:
                              Validations.validateCNIC(cniccontroller.text),
                          title: "Invalid Details",
                        ).showDialogBox(context);
                      } else {
                        MyStorage.saveToken(
                            cniccontroller.text, MyTokens.fscnic);
                        MyStorage.saveToken(
                            fullnamecontroller.text, MyTokens.fsname);
                        MyStorage.saveToken(
                            portfoliocontroller.text, MyTokens.fsportfolio);

                        Navigator.pushNamed(
                            context, '/FreelancerSignup_Description');
                      }
                    },
                  )
                ],
              ),
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
