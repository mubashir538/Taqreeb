import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class Add360Video extends StatelessWidget {
  const Add360Video({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Column(
        children: [
          const Header(heading: "Add Service Listing"),
          _buildVideoUploadSection(context),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildVideoUploadSection(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Screen.width(context) * 0.04),
          child: _buildVideoCard(context),
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context) {
    return Card(
      color: MyColors.darkLighter,
      child: Padding(
        padding: EdgeInsets.all(Screen.width(context) * 0.04),
        child: SizedBox(
          height: Screen.height(context) * 0.2,
          width: Screen.width(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              SizedBox(height: Screen.height(context) * 0.01),
              _buildDescription(context),
              const Spacer(),
              _buildVideoIcon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      '360° Video Tour',
      style: TextStyle(
        fontSize: Screen.width(context) * 0.045,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Upload a video to create a 360 view.',
      style: TextStyle(
        fontSize: Screen.width(context) * 0.035,
        color: Colors.white,
      ),
    );
  }

  Widget _buildVideoIcon(BuildContext context) {
    return Center(
      child: Icon(
        Icons.videocam,
        color: MyColors.red,
        size: Screen.width(context) * 0.1,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.04,
        vertical: Screen.height(context) * 0.02,
      ),
      color: MyColors.dark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSkipButton(context),
          SizedBox(width: Screen.width(context) * 0.04),
          _buildUploadButton(context),
        ],
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: _skipButtonStyle(context),
        onPressed: () {
          // Handle skip action
        },
        child: Text(
          'Skip',
          style: TextStyle(
            color: Colors.white,
            fontSize: Screen.width(context) * 0.04,
          ),
        ),
      ),
    );
  }

  ButtonStyle _skipButtonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.grey[800]),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Screen.width(context) * 0.02),
        ),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(vertical: Screen.height(context) * 0.02),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return Expanded(
      child: ColoredButton(
        text: 'Upload a video',
        onPressed: () {
          // Handle video upload
        },
      ),
    );
  }
}
