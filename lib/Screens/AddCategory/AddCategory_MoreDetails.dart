import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/package%20box.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }

  void fetchdata() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? '';
    final fields = await MyApi.getRequest(
      endpoint:
          'getListingDetails/${args['category'].toString().replaceAll(RegExp(r'\s+'), '')}',
      headers: {'Authorization': 'Bearer $token'},
      // headers: {'Authorization': 'Bearer $token'}
    );
    setState(() {
      this.token = token;
      textfields = fields ?? {}; // Ensure no null data
    });
    for (int i = 0; i < textfields['fields'].length; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
      print(i);
    }
    isLoading = false; // Data has been fetched, so stop loading
    ischange = true;
  }

  String capitalize(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1);
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
            child: Column(
              children: [
                SizedBox(height: (screenHeight * 0.04) + _headerHeight),
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
                  height: screenHeight * 0.1,
                  child: Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Continue',
                  onPressed: () {
                    // Validate if all fields are filled
                    bool allFieldsFilled = true;
                    for (var controller in controllers) {
                      print(controller.text);
                      if (controller.text.isEmpty) {
                        allFieldsFilled = false;
                        break;
                      }
                    }

                    if (!allFieldsFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill all the fields'),
                        ),
                      );
                      return;
                    }

                    // Collect all values from fields
                    Map<String, dynamic> fieldValues = {};
                    for (int i = 0; i < textfields['fields'].length; i++) {
                      fieldValues[textfields['fields'][i]['name']] =
                          controllers[i].text;
                    }
                    // Add the values to args map
                    args.addAll(fieldValues.map((key, value) {
                      return MapEntry(key, value.toString());
                    }).cast<String, String>());
                    print('args: $args');
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
              key: _headerKey,
              heading: 'Details of Service',
              para: 'Add the Specific Details for your Service',
            ),
          ),
        ],
      ),
    );
  }
}
