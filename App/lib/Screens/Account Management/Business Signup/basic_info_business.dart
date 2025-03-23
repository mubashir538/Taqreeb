import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class BusinessSignup_BasicInfo extends StatefulWidget {
  const BusinessSignup_BasicInfo({super.key});

  @override
  State<BusinessSignup_BasicInfo> createState() =>
      _BusinessSignup_BasicInfoState();
}

class _BusinessSignup_BasicInfoState extends State<BusinessSignup_BasicInfo> {
  TextEditingController cnicController = TextEditingController();
  TextEditingController profileNameController = TextEditingController();
  FocusNode cnicFocusNode = FocusNode();
  FocusNode profileNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      check(context);
      _getHeaderHeight();
    });
  }

  void check(BuildContext context) async {
    if (await MyStorage.exists(MyTokens.bscnic) &&
        await MyStorage.exists(MyTokens.bsusername) &&
        await MyStorage.exists(MyTokens.bsname)) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to do Business Signup in the app Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken(MyTokens.bscnic);
              MyStorage.deleteToken(MyTokens.bsname);
              MyStorage.deleteToken(MyTokens.bsusername);
              MyStorage.deleteToken(MyTokens.bsfront);
              MyStorage.deleteToken(MyTokens.bsback);
              MyStorage.deleteToken(MyTokens.bsdescription);

              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists(MyTokens.bsdescription)) {
                Navigator.pushNamed(context, '/ProfilePictureUpload',
                    arguments: {'type': 'Business'});
              } else if (await MyStorage.exists(MyTokens.bsfront)) {
                Navigator.pushNamed(context, '/BusinessSignup_Description');
              } else {
                Navigator.pushNamed(context, '/BusinessSignup_CNICUpload');
              }
            },
          )
        ],
      ).showDialogBox(context);
    }
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
    _getHeaderHeight();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: (Screen.height(context) * 0.05) + _headerHeight,
                  ),
                  MyTextBox(
                    hint: 'CNIC',
                    focusNode: cnicFocusNode,
                    isNum: true,
                    valueController: cnicController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(profileNameFocusNode);
                    },
                  ),
                  MyTextBox(
                    hint: 'Profile Name',
                    focusNode: profileNameFocusNode,
                    valueController: profileNameController,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  ColoredButton(
                    onPressed: () {
                      if (cnicController.text.isEmpty ||
                          profileNameController.text.isEmpty) {
                        warningDialog(
                          message: "Please fill all the details",
                          title: "Invalid Details",
                        ).showDialogBox(context);
                      } else if (Validations.validateCNIC(
                              cnicController.text) !=
                          'Ok') {
                        warningDialog(
                          message:
                              Validations.validateCNIC(cnicController.text),
                          title: "Invalid Details",
                        ).showDialogBox(context);
                      } else {
                        MyStorage.saveToken(
                            cnicController.text, MyTokens.bscnic);
                        MyStorage.saveToken(
                            profileNameController.text, MyTokens.bsname);
                        Navigator.pushNamed(
                            context, '/BusinessSignup_CNICUpload');
                      }
                    },
                    text: 'Continue',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Sign Up',
              para:
                  'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.BusinessSignup,
            ),
          ),
        ],
      ),
    );
  }
}
