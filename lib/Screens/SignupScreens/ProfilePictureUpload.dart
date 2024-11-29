import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class ProfilePictureUpload extends StatelessWidget {
  const ProfilePictureUpload({super.key});

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
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Header(
                    heading: 'Upload Your Profile',
                    para:
                        'The Profile Picture or Business Logo will create the impression of your brand and will help people to visualize the Brand',
                  ),
                  Container(
                    margin: EdgeInsets.all(MaximumThing * 0.04),
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Container(
                            color: Colors.white,
                            child: Image.asset(
                              MyImages.UploadProfile,
                              width: screenWidth * 0.5,
                              height: screenWidth * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: screenWidth * 0.03,
                          left: screenWidth * 0.03,
                          child: SvgPicture.asset(
                            MyIcons.upload,
                            width: MaximumThing * 0.03,
                            height: MaximumThing * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyDivider(),
                  ColoredButton(
                    text: 'Upload Profile',
                    onPressed: () {
                      Navigator.pushNamed(context, '/HomePage');
                    },
                  ),
                ],
              ),
              ProgressBar(Progress: 4)
            ],
          ),
        ),
      ),
    );
  }
}
