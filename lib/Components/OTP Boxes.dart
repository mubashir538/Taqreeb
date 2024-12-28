import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class OTPBoxes extends StatefulWidget {
  final Function(String) onChanged; // Callback to return the complete OTP
  const OTPBoxes({super.key, required this.onChanged});

  @override
  State<OTPBoxes> createState() => _OTPBoxesState();
}

class _OTPBoxesState extends State<OTPBoxes> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      // Move to the next box when a digit is entered
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to the previous box if the current box is cleared
      _focusNodes[index - 1].requestFocus();
    }

    // Concatenate all values and pass to the callback
    final otp = _controllers.map((controller) => controller.text).join();
    widget.onChanged(otp);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double maximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: Container(
              height: screenHeight * 0.07,
              width: screenHeight * 0.07,
              decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                maxLength: 1, // Only one character
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: GoogleFonts.montserrat(
                  fontSize: maximumThing * 0.02,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  counterText: '', // Hides the counter
                  border: InputBorder.none,
                ),
                onChanged: (value) => _onTextChanged(index, value),
              ),
            ),
          );
        }),
      ),
    );
  }
}
