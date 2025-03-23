import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddcategoryAddons extends StatefulWidget {
  const AddcategoryAddons({super.key});

  @override
  State<AddcategoryAddons> createState() => _AddcategoryAddonsState();
}

class _AddcategoryAddonsState extends State<AddcategoryAddons> {
  Map<String, dynamic> args = {};
  GlobalKey headerKey = GlobalKey();
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
  }

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
            child: Container(
              width: Screen.width(context),
              margin:
                  EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: UI_Management.headerHeight,
                  ),
                  Container(
                    margin: EdgeInsets.all(Screen.max(context) * 0.01),
                    child: Text(
                      "Add-Ons",
                      style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.025,
                        fontWeight: FontWeight.w600,
                        color: MyColors.Yellow,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(Screen.width(context) * 0.01),
                    width: Screen.width(context) * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: Screen.width(context) * 0.03,
                      vertical: Screen.height(context) * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        args['addons'] != null
                            ? Column(
                                children: [
                                  ...args['addons'].map<Widget>((addon) {
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal:
                                                Screen.width(context) * 0.02,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  height: Screen.max(context) *
                                                      0.01),
                                              Text(
                                                addon['name'],
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      Screen.max(context) *
                                                          0.015,
                                                  fontWeight: FontWeight.w400,
                                                  color: MyColors.Yellow,
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                textAlign: TextAlign.right,
                                                addon['perhead']
                                                            .toLowerCase() ==
                                                        'yes'
                                                    ? '${addon['price']}/${addon['headtype']}'
                                                    : addon['price'],
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      Screen.max(context) *
                                                          0.015,
                                                  fontWeight: FontWeight.w400,
                                                  color: MyColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: Screen.max(context) * 0.01),
                                      ],
                                    );
                                  }).toList(),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: Screen.max(context) * 0.02,
            left: Screen.width(context) * 0.25,
            right: Screen.width(context) * 0.25,
            child: ColoredButton(
                text: 'Continue',
                width: Screen.width(context) * 0.5,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/AddCategory_Packages',
                    arguments: args,
                  );
                }),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Add AddOns',
              para: 'Add AddOns for your Service',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.Yellow,
        onPressed: () {
          if (args['addons'] == null) {
            args.addAll({'addons': []});
          }
          Navigator.pushNamed(
            context,
            '/AddCategory_Add_Addons',
            arguments: args,
          );
        },
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: Screen.max(context) * 0.04,
        ),
      ),
    );
  }
}
