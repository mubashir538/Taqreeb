import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/radio%20button%20question.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddcategoryAddaddons extends StatefulWidget {
  AddcategoryAddaddons({super.key});

  @override
  State<AddcategoryAddaddons> createState() => _AddcategoryAddaddonsState();
}

class _AddcategoryAddaddonsState extends State<AddcategoryAddaddons> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController perheadController = TextEditingController();
  TextEditingController headtypeController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode perheadFocus = FocusNode();
  FocusNode headtypeFocus = FocusNode();

  bool isPerhead = false;
  Map<String, dynamic> args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
  }

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
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: _headerHeight,
                ),
                MyTextBox(
                  focusNode: nameFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(priceFocus);
                  },
                  hint: 'Name',
                  valueController: nameController,
                ),
                MyTextBox(
                  focusNode: priceFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(perheadFocus);
                  },
                  hint: 'Price',
                  isNum: true,
                  isPrice: true,
                  valueController: priceController,
                ),
                RadioButtonQuestion(
                    options: ['Yes', 'No'],
                    question: '',
                    myValue: perheadController.text,
                    onChanged: (value) {
                      setState(() {
                        perheadController.text = value.toString();
                        if (value == 'Yes') {
                          isPerhead = true;
                        } else {
                          isPerhead = false;
                        }
                      });
                    }),
                isPerhead
                    ? MyTextBox(
                        focusNode: headtypeFocus,
                        onFieldSubmitted: (_) {
                          headtypeFocus.unfocus();
                        },
                        hint: 'PerHead Type',
                        valueController: headtypeController)
                    : Container(),
                SizedBox(
                  height: Screen.height(context) * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                    text: 'Add',
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          perheadController.text.isEmpty) {
                        MyScaffold(text: 'Please fill all the fields')
                            .show(context);
                        return;
                      }
                      if (isPerhead && headtypeController.text.isEmpty) {
                        MyScaffold(text: 'Please fill all the fields')
                            .show(context);
                        return;
                      }
                      args['addons'].add({
                        'name': _capitalize(nameController.text),
                        'price': _capitalize(priceController.text),
                        'perhead': _capitalize(perheadController.text),
                        'headtype': isPerhead
                            ? _capitalize(headtypeController.text)
                            : '',
                      });
                      Navigator.popAndPushNamed(context, '/AddCategory_Addons',
                          arguments: args);
                    })
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
}
