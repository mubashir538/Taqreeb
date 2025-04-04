import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

class FreelancerSignup_BasicInfo extends StatefulWidget {
  const FreelancerSignup_BasicInfo({super.key});

  @override
  State<FreelancerSignup_BasicInfo> createState() =>
      _FreelancerSignup_BasicInfoState();
}

class _FreelancerSignup_BasicInfoState
    extends State<FreelancerSignup_BasicInfo> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _cnicFocus = FocusNode();
  final FocusNode _portfolioFocus = FocusNode();

  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeUI();
    _checkForPreviousSignup();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _cnicController.dispose();
    _portfolioController.dispose();
    _fullNameFocus.dispose();
    _cnicFocus.dispose();
    _portfolioFocus.dispose();
    super.dispose();
  }

  void _initializeUI() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    setState(() {
      UI_Management.headerHeight = renderBox.size.height;
    });
  }

  Future<void> _checkForPreviousSignup() async {
    final hasPreviousSignup = await MyStorage.exists(MyTokens.bscnic) &&
        await MyStorage.exists(MyTokens.bsusername) &&
        await MyStorage.exists(MyTokens.bsname);

    if (hasPreviousSignup && mounted) {
      _showContinueDialog();
    }
  }

  void _showContinueDialog() {
    WarningDialog(
      title: 'Fresh Start',
      message:
          'We noticed that you had lately attempted to do Freelancer Signup in the app. Do you want to continue where you left or want a Fresh Start?',
      actions: [
        ColoredButton(
          text: 'Fresh Start',
          onPressed: _handleFreshStart,
        ),
        ColoredButton(
          text: 'Continue',
          onPressed: _handleContinue,
        )
      ],
    ).showDialogBox(context);
  }

  void _handleFreshStart() {
    MyStorage.deleteToken(MyTokens.fscnic);
    MyStorage.deleteToken(MyTokens.fsname);
    MyStorage.deleteToken(MyTokens.fsdescription);
    Navigator.pop(context);
  }

  Future<void> _handleContinue() async {
    if (await MyStorage.exists(MyTokens.fsdescription)) {
      Navigator.pushNamed(context, '/ProfilePictureUpload',
          arguments: {'type': 'Freelancer'});
    } else {
      Navigator.pushNamed(context, '/FreelancerSignup_Description');
    }
  }

  Future<void> _handleContinueButton() async {
    if (_validateInputs()) {
      await _saveUserData();
      Navigator.pushNamed(context, '/FreelancerSignup_Description');
    }
  }

  bool _validateInputs() {
    if (_fullNameController.text.isEmpty ||
        _cnicController.text.isEmpty ||
        _portfolioController.text.isEmpty) {
      _showErrorDialog("Please fill all the details", "Invalid Details");
      return false;
    }

    final cnicValidation = Validations.validateCNIC(_cnicController.text);
    if (cnicValidation != 'Ok') {
      _showErrorDialog(cnicValidation, "Invalid Details");
      return false;
    }

    return true;
  }

  void _showErrorDialog(String message, String title) {
    MyScaffold(text: message).show(context);
  }

  Future<void> _saveUserData() async {
    await MyStorage.saveToken(_cnicController.text, MyTokens.fscnic);
    await MyStorage.saveToken(_fullNameController.text, MyTokens.fsname);
    await MyStorage.saveToken(_portfolioController.text, MyTokens.fsportfolio);
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        MyTextBox(
          focusNode: _fullNameFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_cnicFocus),
          hint: "Enter Business Name",
          valueController: _fullNameController,
        ),
        MyTextBox(
          focusNode: _cnicFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_portfolioFocus),
          hint: "Enter CNIC Number",
          valueController: _cnicController,
        ),
        MyTextBox(
          focusNode: _portfolioFocus,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          hint: "Enter Portfolio Link",
          valueController: _portfolioController,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: Screen.height(context) * 0.05,
      child: MyDivider(),
    );
  }

  Widget _buildContinueButton() {
    return ColoredButton(
      text: "Continue",
      onPressed: _handleContinueButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.max(context) * 0.05) +
                        UI_Management.headerHeight,
                  ),
                  _buildInputFields(),
                  _buildDivider(),
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Create A Freelancer Account",
              para:
                  "Earn a Soothing Income by Editing Videos or Pictures of Events",
              image: MyImages.FreelancerSignup,
            ),
          ),
        ],
      ),
    );
  }
}
