import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/Inputs/c_radio_button_question.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryAddAddons extends StatefulWidget {
  const AddCategoryAddAddons({super.key});

  @override
  State<AddCategoryAddAddons> createState() => _AddCategoryAddAddonsState();
}

class _AddCategoryAddAddonsState extends State<AddCategoryAddAddons> {
  final _formController = AddonsFormController();
  final GlobalKey _headerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      _formController.args = args as Map<String, dynamic>;
    }
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
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  void _handlePerHeadChange(String? value) {
    setState(() {
      _formController.perheadController.text = value ?? '';
      _formController.isPerhead = value == 'Yes';
    });
  }

  void _submitForm(BuildContext context) {
    if (!_formController.validateForm()) {
      MyScaffold(text: 'Please fill all the fields').show(context);
      return;
    }

    _formController.addAddonToArgs();
    Navigator.popAndPushNamed(
      context,
      '/AddCategory_Addons',
      arguments: _formController.args,
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
            child: Column(
              children: [
                SizedBox(height: UImanagement.headerHeight),
                _buildNameField(),
                _buildPriceField(),
                _buildPerHeadQuestion(),
                if (_formController.isPerhead) _buildHeadTypeField(),
                SizedBox(
                  height: Screen.height(context) * 0.1,
                  child: const Center(child: MyDivider()),
                ),
                _buildSubmitButton(context),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add AddOns',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return MyTextBox(
      focusNode: _formController.nameFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.priceFocus);
      },
      hint: 'Name',
      valueController: _formController.nameController,
    );
  }

  Widget _buildPriceField() {
    return MyTextBox(
      focusNode: _formController.priceFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.perheadFocus);
      },
      hint: 'Price',
      isNum: true,
      isPrice: true,
      valueController: _formController.priceController,
    );
  }

  Widget _buildPerHeadQuestion() {
    return RadioButtonQuestion(
      options: const ['Yes', 'No'],
      question: '',
      myValue: _formController.perheadController.text,
      onChanged: _handlePerHeadChange,
    );
  }

  Widget _buildHeadTypeField() {
    return MyTextBox(
      focusNode: _formController.headtypeFocus,
      onFieldSubmitted: (_) => _formController.headtypeFocus.unfocus(),
      hint: 'PerHead Type',
      valueController: _formController.headtypeController,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ColoredButton(
      text: 'Add',
      onPressed: () => _submitForm(context),
    );
  }
}

class AddonsFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController perheadController = TextEditingController();
  final TextEditingController headtypeController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode perheadFocus = FocusNode();
  final FocusNode headtypeFocus = FocusNode();

  Map<String, dynamic> args = {};
  bool isPerhead = false;

  bool validateForm() {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        perheadController.text.isEmpty) {
      return false;
    }
    if (isPerhead && headtypeController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void addAddonToArgs() {
    if (!args.containsKey('addons')) {
      args['addons'] = [];
    }

    args['addons'].add({
      'name': _capitalize(nameController.text),
      'price': _capitalize(priceController.text),
      'perhead': _capitalize(perheadController.text),
      'headtype': isPerhead ? _capitalize(headtypeController.text) : '',
    });
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    perheadController.dispose();
    headtypeController.dispose();
    nameFocus.dispose();
    priceFocus.dispose();
    perheadFocus.dispose();
    headtypeFocus.dispose();
  }
}
