import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/images.dart';
//import 'package:taqreeb/Components/divider.dart';

class BusinessSignup4 extends StatefulWidget {
  const BusinessSignup4({super.key});

  @override
  State<BusinessSignup4> createState() => _BusinessSignup4State();
}

class _BusinessSignup4State extends State<BusinessSignup4> {
  final GlobalKey _headerKey = GlobalKey();
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
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Header(
            key: _headerKey,
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
