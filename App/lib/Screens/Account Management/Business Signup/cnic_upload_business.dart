import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_icon_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';
import 'package:taqreeb/core/utils/images.dart';
import '../../../core/services/picture_options.dart';

class BusinessSignup_CNICUpload extends StatefulWidget {
  const BusinessSignup_CNICUpload({super.key});

  @override
  State<BusinessSignup_CNICUpload> createState() =>
      _BusinessSignup_CNICUploadState();
}

class _BusinessSignup_CNICUploadState extends State<BusinessSignup_CNICUpload> {
  File? frontImage;
  File? backImage;
  GlobalKey headerKey = GlobalKey();

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: (Screen.height(context) * 0.02) +
                        UI_Management.headerHeight),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Screen.height(context) * 0.02),
                  child: Column(
                    children: [
                      frontImage != null
                          ? Image.file(
                              frontImage!,
                              width: Screen.width(context) * 0.5,
                              height: Screen.width(context) * 0.5,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              MyImages.Cnic,
                              height: Screen.height(context) * 0.2,
                              fit: BoxFit.contain,
                            ),
                      IconedButton(
                        onPressed: () => () => Picture.pickImage(context,
                            callback: (file) =>
                                setState(() => frontImage = file)),
                        icon: MyIcons.upload2,
                        text: 'Upload Front',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Screen.height(context) * 0.01),
                  child: Column(
                    children: [
                      backImage != null
                          ? Image.file(
                              backImage!,
                              width: Screen.width(context) * 0.5,
                              height: Screen.width(context) * 0.5,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              MyImages.Cnic,
                              height: Screen.height(context) * 0.2,
                              fit: BoxFit.contain,
                            ),
                      IconedButton(
                        onPressed: () => Picture.pickImage(context,
                            callback: (file) =>
                                setState(() => backImage = file)),
                        icon: MyIcons.upload2,
                        text: 'Upload Back',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.03),
                MyDivider(),
                SizedBox(height: Screen.height(context) * 0.02),
                ColoredButton(
                  onPressed: () {
                    if (frontImage == null || backImage == null) {
                      MyScaffold(text: 'Please upload both front and back')
                          .show(context);
                    } else {
                      MyStorage.saveToken(frontImage!.path, MyTokens.bsfront);
                      MyStorage.saveToken(backImage!.path, MyTokens.bsback);
                      Navigator.pushNamed(
                          context, '/BusinessSignup_Description');
                    }
                  },
                  text: 'Continue',
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Upload your ID Card for Verification',
              para:
                  'Uploading your ID card ensures secure identity verification for your account.',
            ),
          ),
        ],
      ),
    );
  }
}
