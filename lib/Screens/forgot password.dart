import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taqreeb/Components/OTP%20Boxes.dart';

import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:google_fonts/google_fonts.dart';


// class ForgotPassword extends StatelessWidget {
//   const ForgotPassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//     child: Container(
    
//       child: Column(
//         children: [ 
//           Container(
//         height: 380,
//         width: 431,
//         decoration: BoxDecoration(
          
//           color:MyColors.red,
//           borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
//       ),
//        child: Column(
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset(MyIcons.arrowLeft),
//               SizedBox(
//                 width: 100,
//               ),
//               Text(
//                     "Taqreeb",
//                     style: GoogleFonts.montserrat(
//                         fontSize: 28,
//                         fontWeight: FontWeight.w700,
//                         color: MyColors.white
//                         ),
//                   ),
//             ],
//           ),
//           Text( "Forgot Password",
//                     style: GoogleFonts.montserrat(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w700,
//                         color: MyColors.Yellow),
//                   ),
//                   SizedBox(
//                 width: 15,
//               ),
//           Text(
//                     "Enter the email address with your account  and we’ll send an email with confirmation to restet your password",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.montserrat(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w300,
//                         color: MyColors.white),
//                   ),
//           SizedBox(
//                 height: 30,
//               ),
//           SvgPicture.asset(MyImages.ForgotPassword)
//         ],
//        ),
//       ),
//       SizedBox(
//                 height: 50,
//               ),
//               Column(
//                 children: [
//                   Container(
//         width: 352,
//         height: 63,
//         decoration: BoxDecoration(
//           color: MyColors.DarkLighter,
//           borderRadius: BorderRadius.circular(10),
//         ),
        
//         child: Row(
//           children: [
//             SizedBox(height: 18, width: 20,),
//              Text( "Enter Email or Phone Number",
//                     style: GoogleFonts.montserrat(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w300,
//                         color: MyColors.white),
//                   ),
//                   SizedBox(
//                 width: 15,
//               ),
           
//           ],
//         ),
//       ),
//                 ],
//               ),
//               SizedBox(height: 30,),
//               Divider(
//                 color: MyColors.DarkLighter,
//                 thickness: 1.5, 
//               ),
//                SizedBox(height: 30,),
//                ColoredButton(text: "Send Code")
       
//         ],
//       ),
//     )
//     );
//   }
// }




class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 244,
            width: 431,
            decoration: BoxDecoration(
              color: MyColors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
            children: [
              SvgPicture.asset(MyIcons.arrowLeft),
              SizedBox(
                width: 100,
              ),
              Text(
                    "Taqreeb",
                    style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: MyColors.white
                        ),
                  ),
            ],
          ),
                SizedBox(height: 15),
                Text(
                  "Upload your ID Card for Verification",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: MyColors.Yellow,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "We have sent the code to abc@gmail.com",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),

          // Wrapping OTPBoxes in Center
          Center(
            child: OTPBoxes(),
          ),
        ],
      ),
    );
  }
}