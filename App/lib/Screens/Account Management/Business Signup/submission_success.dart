import 'package:flutter/material.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/utils/images.dart';

class SubmissionSucessful extends StatefulWidget {
  const SubmissionSucessful({super.key});

  @override
  State<SubmissionSucessful> createState() => _SubmissionSucessfulState();
}

class _SubmissionSucessfulState extends State<SubmissionSucessful> {
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
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/HomePage', ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
