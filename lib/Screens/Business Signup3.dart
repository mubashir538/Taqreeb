import 'package:flutter/material.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';

class BusinessSignup3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Header(
                heading: "Create a Description",
                para: 'Your Description Creates a Great Impact on the\n' 
                'customers and can help your get more clients '
                ),
                const SizedBox(height: 20),

            //TextBoxes
            MyTextBox(hint: 'Profile Username'),
            const SizedBox(height: 30),
            MyTextBox(hint: 'Profile Name'),
            const SizedBox(height: 30),
            MyTextBox(hint: 'Profile Description', ),
            const SizedBox(height: 50),
            
            GestureDetector(
              child: Text("1100 Character Left",
                style: TextStyle(color: MyColors.white),  
                ),
            ),
            SizedBox(height: 20),

            // Divider
            MyDivider(width: 1000),
            const SizedBox(height: 20),
            
            ColoredButton(
                text: "Sign Up",
              ),
              SizedBox(height: 30),
            ]
            ),
          
        ),
      )
    );

    
  }
}
            