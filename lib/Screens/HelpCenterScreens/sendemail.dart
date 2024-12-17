import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';

class SendEmailScreen extends StatelessWidget {
  const SendEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    
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
                valueController: nameController,
              ),
              SizedBox(height: 10),
              MyTextBox(
                hint: "Email",
                valueController: emailController,
              ),
              SizedBox(height: 10),
              MyTextBox(
                hint: "Message",
                valueController: messageController,
              ),
              SizedBox(height: 10),
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
