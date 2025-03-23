import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

class Add360video extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        children: [
          Header(
            heading: "Add Service Listing",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Screen.width(context) * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: MyColors.DarkLighter,
                      child: Padding(
                        padding: EdgeInsets.all(Screen.width(context) * 0.04),
                        child: Container(
                          height: Screen.height(context) * 0.2,
                          width: Screen.width(context),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '360° Video Tour',
                                style: TextStyle(
                                  fontSize: Screen.width(context) * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: Screen.height(context) * 0.01),
                              Text(
                                'Upload a video to create a 360 view.',
                                style: TextStyle(
                                  fontSize: Screen.width(context) * 0.035,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Icon(
                                    Icons.videocam,
                                    color: MyColors.red,
                                    size: Screen.width(context) * 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Screen.width(context) * 0.04, // Responsive padding
              vertical: Screen.height(context) * 0.02, // Responsive padding
            ),
            color: MyColors.Dark, // Match the background color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey[800], // Lighter dark color
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              Screen.width(context) *
                                  0.02), // Responsive rounded corners
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                            vertical: Screen.height(context) *
                                0.02), // Responsive padding
                      ),
                    ),
                    onPressed: () {
                      // Handle skip action
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Screen.width(context) *
                            0.04, // Responsive font size
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    width: Screen.width(context) * 0.04), // Responsive spacing
                Expanded(
                  child: ColoredButton(
                    text: 'Upload a video',
                    onPressed: () {
                      // Handle video upload
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
