import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddcategoryMoredetails extends StatefulWidget {
  const AddcategoryMoredetails({super.key});

  @override
  State<AddcategoryMoredetails> createState() => _AddcategoryMoredetailsState();
}

class _AddcategoryMoredetailsState extends State<AddcategoryMoredetails> {
  String token = '';
  Map<String, dynamic> textfields = {};
  Map<String, dynamic> args = {};
  bool isLoading = true;
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  bool ischange = false;
  GlobalKey headerKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
    if (!ischange) {
      fetchdata();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
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

  Timer? timer;
  void fetchdata() async {
    ApiCall.fetchAPI(
        'getListingDetails/${args['category'].toString().replaceAll(RegExp(r'\s+'), '')}',
        onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          token = token;
          textfields = data;
          for (int i = 0; i < textfields['fields'].length; i++) {
            controllers.add(TextEditingController());
            focusNodes.add(FocusNode());
          }
          isLoading = false;
          ischange = true;
        });
      }
    }, context: mounted ? context : null);
  }

  String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
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
            child: Column(
              children: [
                SizedBox(
                    height: (Screen.height(context) * 0.04) +
                        UI_Management.headerHeight),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
                      ))
                    : Column(
                        children: [
                          for (var field in textfields['fields'])
                            field['choices'] != null
                                ? ResponsiveDropdown(
                                    focusNode: focusNodes[
                                        textfields['fields'].indexOf(field)],
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                          focusNodes[textfields['fields']
                                                  .indexOf(field) +
                                              1]);
                                    },
                                    items: field['choices']
                                        .map((e) => capitalize(e))
                                        .cast<String>()
                                        .toList(),
                                    labelText: capitalize(field['name']),
                                    onChanged: (value) {
                                      controllers[textfields['fields']
                                              .indexOf(field)]
                                          .text = value;
                                    },
                                  )
                                : MyTextBox(
                                    focusNode: focusNodes[
                                        textfields['fields'].indexOf(field)],
                                    onFieldSubmitted: (_) {
                                      if (textfields['fields'].indexOf(field) +
                                              1 ==
                                          textfields['fields'].length) {
                                        FocusScope.of(context).unfocus();
                                      } else {
                                        FocusScope.of(context).requestFocus(
                                            focusNodes[textfields['fields']
                                                    .indexOf(field) +
                                                1]);
                                      }
                                    },
                                    hint: capitalize(field['name']),
                                    valueController: controllers[
                                        textfields['fields'].indexOf(field)],
                                  ),
                        ],
                      ),
                SizedBox(
                  height: Screen.height(context) * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Continue',
                  onPressed: () async {
                    bool allFieldsFilled = true;
                    for (int i = 0; i < textfields['fields'].length; i++) {
                      if (controllers[i].text.isEmpty) {
                        allFieldsFilled = false;
                        break;
                      }
                      if (textfields['fields'][i]['name'] == 'portfolioLink') {
                        final ans = await Validations.validatePortfolio(
                            controllers[i].text);
                        if (ans != 'Ok') {
                          MyScaffold(text: 'Invalid Portfolio Link')
                              .show(context);
                        }
                      }
                    }

                    if (!allFieldsFilled) {
                      MyScaffold(text: 'Please fill all the fields')
                          .show(context);
                      return;
                    }

                    Map<String, dynamic> fieldValues = {};
                    for (int i = 0; i < textfields['fields'].length; i++) {
                      fieldValues[textfields['fields'][i]['name']] =
                          controllers[i].text;
                    }
                    args.addAll(fieldValues.map((key, value) {
                      return MapEntry(key, value.toString());
                    }).cast<String, String>());

                    Navigator.pushNamed(context, '/AddCategory_Addons',
                        arguments: args);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Details of Service',
              para: 'Add the Specific Details for your Service',
            ),
          ),
        ],
      ),
    );
  }
}
