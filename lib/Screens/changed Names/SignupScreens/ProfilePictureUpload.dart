import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/images.dart';

class ProfilePictureUpload extends StatelessWidget {
  const ProfilePictureUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: 1000),
          child: Column(
            children: [
              Header(
                heading: 'Upload Your Profile',
                para:
                    'The Profile Picture or Business Logo will create the impression of your brand and will help people to visualize the Brand',
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: SvgPicture.asset(
                        MyImages.UploadProfile,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: SvgPicture.asset(
                      'assets/icons/upload.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyDivider(),
              ColoredButton(
                text: 'Upload Profile',
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              SizedBox(height: 20),
              ProgressBar(Progress: 4)
            ],
          ),
        ),
      ),
    );
  }
}
