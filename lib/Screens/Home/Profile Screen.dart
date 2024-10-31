import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/components/header.dart';
import 'package:taqreeb/theme/images.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background color if required
      body: 
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header widget with parameters for heading, description, and image
            Header(
              heading: 'Profile Submitted Successfully',
              para: 'Your Profile Has been Submitted Successfully\n'
                  'Now our team is Reviewing your Profile\n'
                  'We\'ll notify you when it is Approved.',
              image: MyImages.BusinessSignup4, // Update with your image path
            ),
            
            SizedBox(height: 20), // Spacer between header and button
            
            // Colored Button widget with a text parameter
            ColoredButton(
              text: 'Continue to Home',
            ),
          ],
        ),
      
    );
  }
}

