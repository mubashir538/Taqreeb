import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class AddcategoryAddons extends StatefulWidget {
  const AddcategoryAddons({super.key});

  @override
  State<AddcategoryAddons> createState() => _AddcategoryAddonsState();
}

class _AddcategoryAddonsState extends State<AddcategoryAddons> {
  Map<String, dynamic> args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
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
            child: Container(
              width: screenWidth,
              margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _headerHeight,
                  ),
                  Container(
                    margin: EdgeInsets.all(MaximumThing * 0.01),
                    child: Text(
                      "Add-Ons",
                      style: GoogleFonts.montserrat(
                        fontSize: MaximumThing * 0.025,
                        fontWeight: FontWeight.w600,
                        color: MyColors.Yellow,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(screenWidth * 0.01),
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.02,
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
                                            horizontal: screenWidth * 0.02,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  height: MaximumThing * 0.01),
                                              Text(
                                                addon['name'],
                                                style: GoogleFonts.montserrat(
                                                  fontSize:
                                                      MaximumThing * 0.015,
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
                                                      MaximumThing * 0.015,
                                                  fontWeight: FontWeight.w400,
                                                  color: MyColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: MaximumThing * 0.01),
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
            bottom: MaximumThing * 0.02,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: ColoredButton(
                text: 'Continue',
                width: screenWidth * 0.5,
                onPressed: () {
                  print('args: ${args}');
                  Navigator.pushNamed(
                    context,
                    '/AddCategory_Packages', // Replace with your target screen's route
                    arguments: args, // Passing the args map to the next screen
                  );
                }),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
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
            print(args);
            args.addAll({'addons': []});
          }
          print(' args: ${args}');
          Navigator.pushNamed(
            context,
            '/AddCategory_Add_Addons', // Replace with your target screen's route
            arguments: args, // Passing the args map to the next screen
          );
        },
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: MaximumThing * 0.04,
        ),
      ),
    );
  }
}
