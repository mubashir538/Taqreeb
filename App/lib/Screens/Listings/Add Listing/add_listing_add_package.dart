import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddcategoryAddpackage extends StatefulWidget {
  const AddcategoryAddpackage({super.key});

  @override
  State<AddcategoryAddpackage> createState() => _AddcategoryAddpackageState();
}

class _AddcategoryAddpackageState extends State<AddcategoryAddpackage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode detailsFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  Map<String, dynamic> args = {};
  GlobalKey headerKey = GlobalKey();

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                      height: (Screen.height(context) * 0.03) +
                          UI_Management.headerHeight),
                  MyTextBox(
                    focusNode: nameFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(detailsFocus);
                    },
                    hint: 'Name',
                    valueController: nameController,
                  ),
                  DescriptionBox(
                    valueController: detailsController,
                    focusNode: detailsFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(priceFocus);
                    },
                  ),
                  MyTextBox(
                    focusNode: priceFocus,
                    onFieldSubmitted: (_) {
                      priceFocus.unfocus();
                    },
                    hint: 'Price',
                    isNum: true,
                    isPrice: true,
                    valueController: priceController,
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.1,
                    child: Center(child: MyDivider()),
                  ),
                  ColoredButton(
                      text: 'Add Package',
                      onPressed: () {
                        args['packages'].add({
                          'name': _capitalize(nameController.text),
                          'details': _capitalize(detailsController.text),
                          'price': _capitalize(priceController.text),
                        });
                        Navigator.pushNamed(context, '/AddCategory_Packages',
                            arguments: args);
                      })
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Add Packages',
            ),
          ),
        ],
      ),
    );
  }
}
