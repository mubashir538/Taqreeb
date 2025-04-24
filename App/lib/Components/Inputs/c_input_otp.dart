import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
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
    // Only allow numeric input
    if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
      _controllers[index].text = '';
      return;
    }

    // Handle pasted code (4 digits)
    if (value.length == 4 && index == 0) {
      for (int i = 0; i < 4; i++) {
        _controllers[i].text = value[i];
        if (i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      }
      _focusNodes[3].unfocus();
      widget.onChanged(value);
      return;
    }

    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus(); // Hide keyboard after last digit
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _controllers.map((controller) => controller.text).join();
    widget.onChanged(otp);
  }

  void _handleKeyEvent(int index, RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Screen.width(context) * 0.02,
            ),
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) => _handleKeyEvent(index, event),
              child: Container(
                height: Screen.height(context) * 0.07,
                width: Screen.height(context) * 0.07,
                decoration: BoxDecoration(
                  color: MyColors.darkLighter,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _focusNodes[index].hasFocus
                        ? Colors.blue
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.roboto(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _onTextChanged(index, value),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
