import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryAddPackage extends StatefulWidget {
  const AddCategoryAddPackage({super.key});

  @override
  State<AddCategoryAddPackage> createState() => _AddCategoryAddPackageState();
}

class _AddCategoryAddPackageState extends State<AddCategoryAddPackage> {
  final _formController = PackageFormController();
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
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  void _submitForm() {
    _formController.addPackage();
    Navigator.pushNamed(
      context,
      '/AddCategory_Packages',
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
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: (Screen.height(context) * 0.03) +
                        UI_Management.headerHeight,
                  ),
                  _buildNameField(),
                  _buildDetailsField(),
                  _buildPriceField(),
                  SizedBox(
                    height: Screen.height(context) * 0.1,
                    child: const Center(child: MyDivider()),
                  ),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Packages',
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
        FocusScope.of(context).requestFocus(_formController.detailsFocus);
      },
      hint: 'Name',
      valueController: _formController.nameController,
    );
  }

  Widget _buildDetailsField() {
    return DescriptionBox(
      valueController: _formController.detailsController,
      focusNode: _formController.detailsFocus,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_formController.priceFocus);
      },
    );
  }

  Widget _buildPriceField() {
    return MyTextBox(
      focusNode: _formController.priceFocus,
      onFieldSubmitted: (_) => _formController.priceFocus.unfocus(),
      hint: 'Price',
      isNum: true,
      isPrice: true,
      valueController: _formController.priceController,
    );
  }

  Widget _buildSubmitButton() {
    return ColoredButton(
      text: 'Add Package',
      onPressed: _submitForm,
    );
  }
}

class PackageFormController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FocusNode nameFocus = FocusNode();
  final FocusNode detailsFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();

  Map<String, dynamic> args = {};

  void addPackage() {
    if (!args.containsKey('packages')) {
      args['packages'] = [];
    }

    args['packages'].add({
      'name': _capitalize(nameController.text),
      'details': _capitalize(detailsController.text),
      'price': _capitalize(priceController.text),
    });
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    priceController.dispose();
    nameFocus.dispose();
    detailsFocus.dispose();
    priceFocus.dispose();
  }
}
