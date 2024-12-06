import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/components/header.dart';
import 'package:taqreeb/theme/images.dart';

class SubmissionSucessful extends StatelessWidget {
  const SubmissionSucessful({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            heading: 'Profile Submitted Successfully',
            para:
                'Your Profile Has been Submitted Successfully Now our team is Reviewing your Profile We\'ll notify you when it is Approved.',
            image: MyImages.BusinessSignup,
          ),
          SizedBox(
            height: screenHeight * 0.1,
            child: Center(child: MyDivider()),
          ),
          ColoredButton(
            text: 'Continue to Home',
          ),
        ],
      ),
    );
  }
}
