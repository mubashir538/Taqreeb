import 'package:flutter/material.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';

class SendEmailScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                heading: "",
                para: "",
                image: "assets/contact_image.svg",
              ),
              SizedBox(height: 20),
              MyTextBox(
                hint: "Name",
              ),
              SizedBox(height: 10),
              MyTextBox(
                hint: "Email",
              ),
              SizedBox(height: 10),
              MyTextBox(
                hint: "Message",
              ),
              SizedBox(height: 50),
              ColoredButton(
                text: "Send",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
