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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(
              heading: 'Add AddOns',
              para: 'Add AddOns for your Service',
            ),
            SizedBox(height: screenHeight * 0.03),
            // Container for displaying Addons dynamically
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
                  // Heading for AddOns (only shown once)
                  Text(
                    "Add-Ons",
                    style: GoogleFonts.montserrat(
                      fontSize: MaximumThing * 0.02,
                      fontWeight: FontWeight.w600,
                      color: MyColors.Yellow,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Dynamically generated Add-Ons List
                  args['addons'] != null
                      ? Column(
                          children: [
                            ...args['addons'].map<Widget>((addon) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: MaximumThing * 0.02),
                                      Text(
                                        addon['name'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: MaximumThing * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        addon['perhead'].toLowerCase() == 'yes'
                                            ? '${addon['price']}/${addon['headtype']}'
                                            : addon['price'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: MaximumThing * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: MaximumThing * 0.02),
                                ],
                              );
                            }).toList(),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ColoredButton(
                text: 'Continue',
                width: screenWidth * 0.5,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/AddCategory_Packages', // Replace with your target screen's route
                    arguments: args, // Passing the args map to the next screen
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.Yellow,
        onPressed: () {
          if (args['addons'] == null) {
            print(args);
            args.addAll({'addons': []});
          }
          print(' args+${args}');
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
