import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/components/header.dart';
import 'package:taqreeb/theme/images.dart';
//import 'package:taqreeb/Components/divider.dart';

class BusinessSignup4 extends StatelessWidget {
  const BusinessSignup4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: 
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(
              heading: 'Profile Submitted Successfully',
              para: 'Your Profile Has been Submitted Successfully\n'
                  'Now our team is Reviewing your Profile\n'
                  'We\'ll notify you when it is Approved.',
              image: MyImages.BusinessSignup4, 
            ),
            
            //Divider code ni h
           // Divider(
              //color: Colors.grey,
              //thickness: 1,
              //indent: screenWidth * 0.1,
              //endIndent: screenWidth * 0.1,
            //),
          
            SizedBox(height: 40), // Spacer between header and button
            ColoredButton(
              text: 'Continue to Home',
            ),
          ],
        ),
      
    );
  }
}
