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
    if (args != null &&
        args is Map<String, dynamic> &&
        !_formController.isInitialized) {
      _formController.initialize(args);
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
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    if (mounted) {
      setState(() => UImanagement.headerHeight = renderbox.size.height);
    }
  }

  Future<void> _fetchDetails() async {
    final category = _formController.args['category']
            ?.toString()
            .replaceAll(RegExp(r'\s+'), '') ??
        '';
    if (category.isEmpty) return;

    await ApiCall.fetchAPI(
      'getListingDetails/$category',
      onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            _formController.handleSuccessResponse(token, data);
          });
        }
      },
      context: context,
    );
  }

  Future<void> _submitForm() async {
    if (!await _formController.validateForm(context)) return;

    final viewData = _formController.prepareViewData();
    Navigator.pushNamed(
      context,
      '/AddCategory_Addons',
      arguments: {
        ..._formController.args,
        'viewData': viewData, // Add viewData as a separate key
      },
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
          _buildContent(),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Details of Service',
              para: 'Add the Specific Details for your Service',
            ),
          ),
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
                  (Screen.height(context) * 0.04) + UImanagement.headerHeight),
          _formController.isLoading
              ? _buildLoadingIndicator()
              : _buildFormFields(),
          _buildDivider(),
          _buildContinueButton(),
          SizedBox(height: Screen.height(context) * 0.1), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: Screen.height(context) * 0.5,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: List.generate(
        _formController.textfields['fields']?.length ?? 0,
        (index) => _buildField(index),
      ),
    );
  }

  Widget _buildField(int index) {
    final field = _formController.textfields['fields'][index];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.05,
        vertical: Screen.height(context) * 0.01,
      ),
      child: field['choices'] != null
          ? _buildDropdownField(field, index)
          : _buildTextField(field, index),
    );
  }

  Widget _buildDropdownField(Map<String, dynamic> field, int index) {
    return ResponsiveDropdown(
      focusNode: _formController.focusNodes[index],
      onFieldSubmitted: (_) => _focusNextField(index),
      items: (field['choices'] as List<dynamic>?)
              ?.map((e) => _formController.capitalize(e.toString()))
              .toList() ??
          [],
      labelText: _formController.capitalize(field['name']?.toString() ?? ''),
      onChanged: (value) => _formController.controllers[index].text = value,
    );
  }

  Widget _buildTextField(Map<String, dynamic> field, int index) {
    return MyTextBox(
      focusNode: _formController.focusNodes[index],
      onFieldSubmitted: (_) => _focusNextField(index),
      hint: _formController.capitalize(field['name']?.toString() ?? ''),
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: MyDivider(),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.1),
      child: ColoredButton(
        text: 'Continue',
        onPressed: _submitForm,
      ),
    );
  }
}

class MoreDetailsFormController {
  // State
  String token = '';
  Map<String, dynamic> textfields = {'fields': []};
  Map<String, dynamic> args = {};
  bool isLoading = true;
  bool isInitialized = false;

  // Form Controls
  final List<TextEditingController> controllers = [];
  final List<FocusNode> focusNodes = [];

  void initialize(Map<String, dynamic> initialArgs) {
    args = Map.from(initialArgs);
    isInitialized = true;
  }

  void handleSuccessResponse(String newToken, dynamic data) {
    token = newToken;
    textfields = data is Map<String, dynamic> ? data : {'fields': []};
    initializeControllers();
    isLoading = false;
  }

  void initializeControllers() {
    // Clear existing controllers
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }

    controllers.clear();
    focusNodes.clear();

    // Initialize new ones
    for (int i = 0; i < (textfields['fields']?.length ?? 0); i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
  }

  Future<bool> validateForm(BuildContext context) async {
    if (textfields['fields'] == null) return false;

    for (int i = 0; i < textfields['fields'].length; i++) {
      final field = textfields['fields'][i];
      final controller = controllers[i];

      if (controller.text.isEmpty) {
        MyScaffold(text: 'Please fill all fields').show(context);
        return false;
      }

      if (field['name'] == 'portfolioLink') {
        final validationResult =
            await Validations.validateLink(controller.text);
        if (validationResult != 'Ok') {
          MyScaffold(text: validationResult).show(context);
          return false;
        }
      }
    }
    return true;
  }

  Map<String, dynamic> prepareViewData() {
    final viewData = <String, dynamic>{};

    for (int i = 0; i < (textfields['fields']?.length ?? 0); i++) {
      final field = textfields['fields'][i];
      viewData[field['name']] = controllers[i].text;
    }
    // print(viewData);
    return viewData;
  }

  String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
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
