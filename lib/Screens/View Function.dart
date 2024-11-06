import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:taqreeb/Components/Colored%20Button.dart';
// import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
// import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
// import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class ViewFunctionsScreen extends StatelessWidget {
  const ViewFunctionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Header(
              heading: "Your Function Details",
              image: MyImages.CheckList, //image folder mn mojood ni hai
            ),
            SizedBox(height: 10,),
            Text(
              'WishFa',
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: MyColors.Yellow),
            ),
            SizedBox(height: 10,),
            Container(
              height: 1762,
              width: 374,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: MyColors.DarkLighter,
              ),
              


              child: Column(
                children: [
                  Container(
                    height: 76,
                    width: 374,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                      color: MyColors.red,
                    ),

                    child: Center(
                child: Text(
                  "Mehendi ",
                  style: GoogleFonts.montserrat(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffEDF2F4)),
                ),
              ),
                  ),
                  SizedBox(height: 20,),

                  Container(
                    height: 1686,
                    width: 374,
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),

            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20,),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      )
    );
  }
}
