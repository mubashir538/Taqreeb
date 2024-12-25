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
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                key: _headerKey,
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
