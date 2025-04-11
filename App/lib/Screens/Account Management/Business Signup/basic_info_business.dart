import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/providers/BusinessSignupProvider.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class BusinessSignup_BasicInfo extends StatefulWidget {
  const BusinessSignup_BasicInfo({super.key});

  @override
  State<BusinessSignup_BasicInfo> createState() =>
      _BusinessSignup_BasicInfoState();
}

class _BusinessSignup_BasicInfoState extends State<BusinessSignup_BasicInfo> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<BusinessSignupProvider>(context, listen: false);
      provider.checkPreviousSignup(context);
      UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        },
      );
    });
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
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
                        UI_Management.headerHeight,
                  ),
                  Consumer<BusinessSignupProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          MyTextBox(
                            hint: 'CNIC',
                            focusNode: provider.cnicFocusNode,
                            isNum: true,
                            valueController: provider.cnicController,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(provider.profileNameFocusNode);
                            },
                          ),
                          MyTextBox(
                            hint: 'Profile Name',
                            focusNode: provider.profileNameFocusNode,
                            valueController: provider.profileNameController,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          ColoredButton(
                            onPressed: () {
                              provider.validateAndSave(context);
                            },
                            text: 'Continue',
                          ),
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
              image: MyImages.BusinessSignup,
            ),
          ),
        ],
      ),
    );
  }
}
