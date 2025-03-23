import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessSignup_Description extends StatefulWidget {
  const BusinessSignup_Description({super.key});

  @override
  State<BusinessSignup_Description> createState() =>
      _BusinessSignup_DescriptionState();
}

class _BusinessSignup_DescriptionState
    extends State<BusinessSignup_Description> {
  int charactersLeft = 1100;
  TextEditingController descriptionController = TextEditingController();
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
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: Screen.width(context),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: UI_Management.headerHeight,
                          ),
                          DescriptionBox(
                              valueController: descriptionController,
                              onChanged: (value) {
                                setState(() {
                                  charactersLeft = 1100 - value.length;
                                });
                              }),
                          SizedBox(
                            width: Screen.width(context) * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${charactersLeft.toString()} characters left",
                                  style: GoogleFonts.montserrat(
                                    color: MyColors.white,
                                    fontSize: Screen.max(context) * 0.018,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Screen.height(context) * 0.05,
                            child: MyDivider(),
                          ),
                          ColoredButton(
                              text: "Continue",
                              onPressed: () {
                                if (descriptionController.text.isEmpty) {
                                  MyScaffold(text: "Please Enter a Description")
                                      .show(context);
                                  return;
                                }
                                if (descriptionController.text.length > 1100) {
                                  MyScaffold(
                                          text:
                                              "Description should be less than 1100 characters")
                                      .show(context);
                                  return;
                                }
                                if (descriptionController.text.length < 50) {
                                  MyScaffold(
                                          text:
                                              "Description should be more than 50 characters")
                                      .show(context);
                                  return;
                                }
                                MyStorage.saveToken(descriptionController.text,
                                    MyTokens.bsdescription);
                                Navigator.pushNamed(
                                    context, '/ProfilePictureUpload',
                                    arguments: {'type': 'Business'});
                              })
                        ],
                      )
                    ]),
              ),
            ),
            Positioned(
              top: 0,
              child: Header(
                  key: headerKey,
                  heading: "Create a Description",
                  para: 'Your Description Creates a Great Impact on the\n'
                      'customers and can help your get more clients '),
            ),
          ],
        ));
  }
}
