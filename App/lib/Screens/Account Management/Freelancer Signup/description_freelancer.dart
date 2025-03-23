import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class FreelancerSignup_Description extends StatefulWidget {
  const FreelancerSignup_Description({super.key});

  @override
  State<FreelancerSignup_Description> createState() =>
      _FreelancerSignup_DescriptionState();
}

class _FreelancerSignup_DescriptionState
    extends State<FreelancerSignup_Description> {
  int charactersLeft = 1100;
  final GlobalKey _headerKey = GlobalKey();
  TextEditingController descriptionController = TextEditingController();
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

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: screenWidth,
              child: Column(
                children: [
                  SizedBox(
                    height: (MaximumThing * 0.05) + _headerHeight,
                  ),
                  DescriptionBox(
                      valueController: descriptionController,
                      onChanged: (value) {
                        setState(() {
                          charactersLeft = 1100 - value.length;
                        });
                      }),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${charactersLeft.toString()} characters left",
                            style: GoogleFonts.montserrat(
                              color: MyColors.white,
                              fontSize: MaximumThing * 0.018,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: MyDivider(),
                  ),
                  ColoredButton(
                    text: "Continue",
                    onPressed: () {
                      if (descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Enter a Description")));
                        return;
                      }
                      if (descriptionController.text.length > 1100) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Description should be less than 1100 characters")));
                        return;
                      }
                      if (descriptionController.text.length < 50) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Description should be more than 50 characters")));
                        return;
                      }
                      MyStorage.saveToken(
                          descriptionController.text, MyTokens.fsdescription);

                      Navigator.pushNamed(context, '/ProfilePictureUpload',
                          arguments: {'type': 'Freelancer'});
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
              heading: "Create A Description",
              para:
                  "Your Description Creates a Great Impact on the customers and can help your get more clients ",
            ),
          ),
        ],
      ),
    );
  }
}
