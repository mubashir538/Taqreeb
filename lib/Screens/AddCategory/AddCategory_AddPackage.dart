import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/description.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

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

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: screenWidth,
              child: Column(
                children: [
                  SizedBox(height: (screenHeight * 0.03) + _headerHeight),
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
                    height: screenHeight * 0.1,
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
                        print(args);
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
              key: _headerKey,
              heading: 'Add Packages',
            ),
          ),
        ],
      ),
    );
  }
}
