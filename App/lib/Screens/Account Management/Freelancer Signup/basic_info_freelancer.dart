import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
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

class FreelancerSignupBasicInfo extends StatefulWidget {
  const FreelancerSignupBasicInfo({super.key});

  @override
  State<FreelancerSignupBasicInfo> createState() =>
      _FreelancerSignupBasicInfoState();
}

class _FreelancerSignupBasicInfoState extends State<FreelancerSignupBasicInfo> {
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
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    setState(() {
      UImanagement.headerHeight = renderBox.size.height;
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
    if (await _validateInputs()) {
      await _saveUserData();
      Navigator.pushNamed(context, '/FreelancerSignup_Description');
    }
  }

  Future<bool> _validateInputs() async {
    if (_fullNameController.text.isEmpty ||
        _cnicController.text.isEmpty ||
        _portfolioController.text.isEmpty) {
      _showErrorDialog("Please fill all the details", "Invalid Details");
      return false;
    }

    final fullNameValidation =
        Validations.validateServiceName(_fullNameController.text);
    if (fullNameValidation != 'Ok') {
      _showErrorDialog(fullNameValidation, "Invalid Details");
      return false;
    }

    final cnicValidation = Validations.validateCNIC(_cnicController.text);
    if (cnicValidation != 'Ok') {
      _showErrorDialog(cnicValidation, "Invalid Details");
      return false;
    }

    final linkValidation =
        await Validations.validateLink(_portfolioController.text);
    if (linkValidation != 'Ok') {
      _showErrorDialog(linkValidation, "Invalid Details");
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
          prefixIcon: FontAwesomeIcons.userTie,
          focusNode: _fullNameFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_cnicFocus),
          hint: "Enter Agency Name",
          valueController: _fullNameController,
        ),
        MyTextBox(
          prefixIcon: FontAwesomeIcons.addressCard,
          focusNode: _cnicFocus,
          onFieldSubmitted: (_) =>
              FocusScope.of(context).requestFocus(_portfolioFocus),
          hint: "Enter CNIC Number",
          isNum: true,
          valueController: _cnicController,
        ),
        MyTextBox(
          prefixIcon: FontAwesomeIcons.upwork,
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
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.max(context) * 0.05) +
                        UImanagement.headerHeight,
                  ),
                  _buildInputFields(),
                  _buildDivider(),
                  _buildContinueButton(),
                  ProgressBar(progress: 2),
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
              image: MyImages.freelancerSignup,
            ),
          ),
        ],
      ),
    );
  }
}
