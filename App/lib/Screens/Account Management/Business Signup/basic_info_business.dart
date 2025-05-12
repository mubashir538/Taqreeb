import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/core/providers/business_signup_provider.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class BusinessSignupBasicInfo extends StatefulWidget {
  const BusinessSignupBasicInfo({super.key});

  @override
  State<BusinessSignupBasicInfo> createState() =>
      _BusinessSignupBasicInfoState();
}

class _BusinessSignupBasicInfoState extends State<BusinessSignupBasicInfo> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<BusinessSignupProvider>(context, listen: false);
      provider.checkPreviousSignup(context);
      UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        },
      );
    });
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: (Screen.height(context) * 0.05) +
                        UImanagement.headerHeight,
                  ),
                  Consumer<BusinessSignupProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          MyTextBox(
                            prefixIcon: FontAwesomeIcons.building,
                            hint: 'Enter Business Name',
                            focusNode: provider.profileNameFocusNode,
                            valueController: provider.profileNameController,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          MyTextBox(
                            prefixIcon: FontAwesomeIcons.addressCard,
                            hint: 'Enter CNIC Number',
                            focusNode: provider.cnicFocusNode,
                            isNum: true,
                            valueController: provider.cnicController,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(provider.profileNameFocusNode);
                            },
                          ),
                          ColoredButton(
                            onPressed: () {
                              provider.validateAndSave(context);
                            },
                            text: 'Continue',
                          ),
                          ProgressBar(progress: 1),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Sign Up',
              para:
                  'Unlock Success with Just One Click - Join Our Community Today!',
              image: MyImages.businessSignup,
            ),
          ),
        ],
      ),
    );
  }
}
