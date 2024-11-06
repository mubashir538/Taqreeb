import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Border%20Button.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Iconed%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class CreateChecklist extends StatelessWidget {
  const CreateChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
        backgroundColor: MyColors.Dark,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(
                    heading: "Create CheckList",
                    para:
                        "From to-do to done –\n" "one check at a time!",
                    image: MyImages.CheckList,
                  ),
                  Row(
                    children: [
                                          ],
                  )
                  
                ]),
                
          ),
        ));
  }
}
