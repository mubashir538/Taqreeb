import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryMoreDetails extends StatefulWidget {
  const AddCategoryMoreDetails({super.key});

  @override
  State<AddCategoryMoreDetails> createState() => _AddCategoryMoreDetailsState();
}

class _AddCategoryMoreDetailsState extends State<AddCategoryMoreDetails> {
  final _formController = MoreDetailsFormController();
  final GlobalKey _headerKey = GlobalKey();
  Timer? _fetchTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && !_formController.isInitialized) {
      _formController.args = args as Map<String, dynamic>;
      _fetchDetails();
    }
  }

  @override
  void dispose() {
    _fetchTimer?.cancel();
    _formController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() => UI_Management.headerHeight = renderbox.size.height);
  }

  Future<void> _fetchDetails() async {
    final category = _formController.args['category']
        .toString()
        .replaceAll(RegExp(r'\s+'), '');
    await ApiCall.fetchAPI(
      'getListingDetails/$category',
      onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            _formController.token = token;
            _formController.textfields = data;
            _formController.initializeControllers();
            _formController.isLoading = false;
            _formController.isInitialized = true;
          });
        }
      },
      context: mounted ? context : null,
    );
  }

  Future<void> _submitForm() async {
    final isValid = await _formController.validateForm(context);
    if (!isValid) {
      return;
    }

    _formController.updateArgsWithFieldValues();
    Navigator.pushNamed(
      context,
      '/AddCategory_Addons',
      arguments: _formController.args,
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
          _buildContent(),
          _buildHeader(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height:
                  (Screen.height(context) * 0.04) + UI_Management.headerHeight),
          _formController.isLoading
              ? _buildLoadingIndicator()
              : _buildFormFields(),
          _buildDivider(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: _formController.textfields['fields'].map<Widget>((field) {
        final index = _formController.textfields['fields'].indexOf(field);
        return field['choices'] != null
            ? _buildDropdownField(field, index)
            : _buildTextField(field, index);
      }).toList(),
    );
  }

  Widget _buildDropdownField(Map<String, dynamic> field, int index) {
    return ResponsiveDropdown(
      focusNode: _formController.focusNodes[index],
      onFieldSubmitted: (_) => _focusNextField(index),
      items: field['choices']
          .map((e) => _formController.capitalize(e))
          .cast<String>()
          .toList(),
      labelText: _formController.capitalize(field['name']),
      onChanged: (value) => _formController.controllers[index].text = value,
    );
  }

  Widget _buildTextField(Map<String, dynamic> field, int index) {
    return MyTextBox(
      focusNode: _formController.focusNodes[index],
      onFieldSubmitted: (_) => _focusNextField(index),
      hint: _formController.capitalize(field['name']),
      valueController: _formController.controllers[index],
    );
  }

  void _focusNextField(int currentIndex) {
    if (currentIndex + 1 < _formController.focusNodes.length) {
      FocusScope.of(context)
          .requestFocus(_formController.focusNodes[currentIndex + 1]);
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Widget _buildDivider() {
    return SizedBox(
      height: Screen.height(context) * 0.1,
      child: const Center(child: MyDivider()),
    );
  }

  Widget _buildContinueButton() {
    return ColoredButton(
      text: 'Continue',
      onPressed: _submitForm,
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      child: Header(
        key: _headerKey,
        heading: 'Details of Service',
        para: 'Add the Specific Details for your Service',
      ),
    );
  }
}

class MoreDetailsFormController {
  // State
  String token = '';
  Map<String, dynamic> textfields = {};
  Map<String, dynamic> args = {};
  bool isLoading = true;
  bool isInitialized = false;

  // Form Controls
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  void initializeControllers() {
    for (int i = 0; i < textfields['fields'].length; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  Future<bool> validateForm(BuildContext context) async {
    for (int i = 0; i < textfields['fields'].length; i++) {
      if (controllers[i].text.isEmpty) {
        MyScaffold(text: 'Please fill all the fields').show(context);
        return false;
      }

      if (textfields['fields'][i]['name'] == 'portfolioLink') {
        final validationResult =
            await Validations.validatePortfolio(controllers[i].text);
        if (validationResult != 'Ok') {
          MyScaffold(text: 'Invalid Portfolio Link').show(context);
          return false;
        }
      }
    }
    return true;
  }

  void updateArgsWithFieldValues() {
    final fieldValues = <String, String>{};
    for (int i = 0; i < textfields['fields'].length; i++) {
      fieldValues[textfields['fields'][i]['name']] = controllers[i].text;
    }
    args.addAll(fieldValues);
  }

  String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
  }
}
