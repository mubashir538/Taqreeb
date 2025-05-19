import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/screen_size.dart';

class ForgotPasswordForm extends StatelessWidget {
  final TextEditingController contactController;
  final VoidCallback onSendCode;

  const ForgotPasswordForm({super.key, 
    required this.contactController,
    required this.onSendCode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
          child: MyTextBox(
            prefixIcon: FontAwesomeIcons.envelope,
            hint: "Enter Email/Phone Number",
            valueController: contactController,
          ),
        ),
        SizedBox(
          height: Screen.height(context) * 0.05,
          child: Center(child: MyDivider()),
        ),
        ColoredButton(
          text: "Send Code",
          onPressed: onSendCode,
        ),
      ],
    );
  }
}
