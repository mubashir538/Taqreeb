import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessSignupDescription extends StatefulWidget {
  const BusinessSignupDescription({super.key});

  @override
  State<BusinessSignupDescription> createState() => _BusinessSignupDescriptionState();
}

class _BusinessSignupDescriptionState extends State<BusinessSignupDescription> {
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey _headerKey = GlobalKey();
  static const int _maxCharacters = 1100;
  static const int _minCharacters = 50;
  int _charactersLeft = _maxCharacters;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _measureHeaderHeight() {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  void _updateCharacterCount(String value) {
    setState(() {
      _charactersLeft = _maxCharacters - value.length;
    });
  }

  Future<void> _handleContinue() async {
    if (!_validateDescription()) return;

    await MyStorage.saveToken(
      _descriptionController.text, 
      MyTokens.bsdescription
    );
    
    if (mounted) {
      Navigator.pushNamed(
        context, 
        '/ProfilePictureUpload',
        arguments: {'type': 'Business'},
      );
    }
  }

  bool _validateDescription() {
    if (_descriptionController.text.isEmpty) {
      _showError("Please Enter a Description");
      return false;
    }

    if (_descriptionController.text.length > _maxCharacters) {
      _showError("Description should be less than $_maxCharacters characters");
      return false;
    }

    if (_descriptionController.text.length < _minCharacters) {
      _showError("Description should be more than $_minCharacters characters");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    MyScaffold(text: message).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: UI_Management.headerHeight),
                      DescriptionBox(
                        valueController: _descriptionController,
                        onChanged: _updateCharacterCount,
                      ),
                      SizedBox(
                        width: Screen.width(context) * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "$_charactersLeft characters left",
                              style: GoogleFonts.montserrat(
                                color: MyColors.white,
                                fontSize: Screen.max(context) * 0.018,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Screen.height(context) * 0.05,
                        child: const MyDivider(),
                      ),
                      ColoredButton(
                        text: "Continue",
                        onPressed: _handleContinue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Create a Description",
              para: 'Your Description Creates a Great Impact on the\n'
                  'customers and can help your get more clients',
            ),
          ),
        ],
      ),
    );
  }
}