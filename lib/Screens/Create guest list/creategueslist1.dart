import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';


import 'package:taqreeb/Components/header.dart';

import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

import 'package:taqreeb/theme/images.dart';

class CreateGuestList1 extends StatelessWidget {
  const CreateGuestList1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(16.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                heading: 'Create Guest List',
                image: MyImages.GuestList,
              ),
              SizedBox(height: 400), 

              // Main Container
              Container(
                
                height: 71,
                width: 272,
                decoration: BoxDecoration(
                  color: MyColors.DarkLighter,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),                                       
                    bottomLeft: Radius.circular(16),
                    
                  ),
                  
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    ColoredButton(text: "Add Person",
                    height: 28, width: 115,),
                    SizedBox(width: 20,),
                     ColoredButton(text: "Add Family",
                    height: 28, width: 115,)
                  ],
                ),
              ),
              SizedBox(height: 5),

             
              Container(
                width: 324,
                height: 52,
                decoration: BoxDecoration(
                  color: MyColors.DarkLighter,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Create guest list",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SvgPicture.asset(
                        MyIcons.add,
                        color: MyColors.white,
                        height: 26,
                        width: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
