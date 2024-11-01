import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/components/header.dart';
import 'package:taqreeb/theme/images.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Header(
            heading: 'Profile Submitted Successfully',
            para: 'Your Profile Has been Submitted Successfully\n'
                'Now our team is Reviewing your Profile\n'
                'We\'ll notify you when it is Approved.',
            image: MyImages.BusinessSignup4,
          ),
          SizedBox(height: 20),
          ColoredButton(
            text: 'Continue to Home',
          ),
        ],
      ),
    );
  }
}
