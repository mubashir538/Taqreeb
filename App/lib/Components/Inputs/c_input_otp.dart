import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class OTPBoxes extends StatefulWidget {
  final Function(String) onChanged;
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
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _controllers.map((controller) => controller.text).join();
    widget.onChanged(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.02),
            child: Container(
              height: Screen.height(context) * 0.07,
              width: Screen.height(context) * 0.07,
              decoration: BoxDecoration(
                color: MyColors.DarkLighter,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                maxLength: 1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: GoogleFonts.montserrat(
                  fontSize: Screen.max(context) * 0.02,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  counterText: '',
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
