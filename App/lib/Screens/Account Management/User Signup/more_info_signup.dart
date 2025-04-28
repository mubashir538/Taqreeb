import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class SignupMoreInfo extends StatefulWidget {
  const SignupMoreInfo({super.key});

  @override
  State<SignupMoreInfo> createState() => _SignupMoreInfoState();
}

class _SignupMoreInfoState extends State<SignupMoreInfo> {
  // Form controllers
  final TextEditingController cityController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final GlobalKey headerKey = GlobalKey();
  final List<String> cities = ["Karachi"];
  final List<String> genders = ["Male", "Female"];
  static const int minimumAge = 18;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
  }

  @override
  void dispose() {
    cityController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _measureHeaderHeight() {
    UI_Management.getHeaderHeight(
      headerKey: headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _handleContinue() async {
    if (!_validateForm()) return;

    await _saveUserData();
    _navigateToProfilePictureUpload();
  }

  bool _validateForm() {
    cityController.text = cities[0];
    if (genderController.text.isEmpty ||
        cityController.text.isEmpty ||
        ageController.text.isEmpty) {
      _showErrorDialog('Details Missing', 'Please fill all the fields');
      return false;
    }

    final age = int.tryParse(ageController.text);
    if (age == null || age < minimumAge) {
      _showErrorDialog(
        'Invalid Age',
        'User should be at least $minimumAge years old',
      );
      return false;
    }

    return true;
  }

  void _showErrorDialog(String title, String message) {
    MyScaffold(text: message).show(context);
  }

  Future<void> _saveUserData() async {
    await MyStorage.saveToken(cityController.text, MyTokens.scity);
    await MyStorage.saveToken(genderController.text, MyTokens.sgender);
    await MyStorage.saveToken(ageController.text, MyTokens.sage);
  }

  void _navigateToProfilePictureUpload() {
    Navigator.pushNamed(
      context,
      '/ProfilePictureUpload',
      arguments: {'type': 'user'},
    );
  }

  Widget _buildFormField({
    required String labelText,
    required List<String> items,
    required TextEditingController controller,
  }) {
    return ResponsiveDropdown(
      items: items,
      labelText: labelText,
      onChanged: (value) {
        if (mounted) {
          setState(() {
            controller.text = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: (Screen.height(context) * 0.01) +
                            UI_Management.headerHeight,
                      ),
                      _buildFormField(
                        labelText: "Gender",
                        items: genders,
                        controller: genderController,
                      ),
                      MyTextBox(
                        hint: 'Enter Your Age',
                        valueController: ageController,
                        isNum: true,
                      ),
                      SizedBox(
                        height: Screen.height(context) * 0.1,
                        child: const Center(child: MyDivider()),
                      ),
                      ColoredButton(
                        text: 'Continue',
                        onPressed: _handleContinue,
                      ),
                    ],
                  ),
                  const ProgressBar(progress: 2),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'OTP Verification',
              para: 'Unlock exclusive events - sign up now!',
              image: MyImages.Signup1,
            ),
          ),
        ],
      ),
    );
  }
}
