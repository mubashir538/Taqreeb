import 'package:flutter/material.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class SendEmailScreen extends StatefulWidget {
  const SendEmailScreen({super.key});

  @override
  State<SendEmailScreen> createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    FocusNode emailFocus = FocusNode();
    FocusNode nameFocus = FocusNode();
    FocusNode messageFocus = FocusNode();

    return Scaffold(
      backgroundColor: MyColors.Dark,
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
                focusNode: nameFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(emailFocus);
                },
                hint: "Name",
                valueController: nameController,
              ),
              SizedBox(height: 10),
              MyTextBox(
                focusNode: emailFocus,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(messageFocus);
                },
                hint: "Email",
                valueController: emailController,
              ),
              SizedBox(height: 10),
              MyTextBox(
                focusNode: messageFocus,
                onFieldSubmitted: (_) {
                  messageFocus.unfocus();
                },
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
