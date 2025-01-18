import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/description.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';

class AddcategoryList extends StatefulWidget {
  const AddcategoryList({super.key});

  @override
  State<AddcategoryList> createState() => _AddcategoryListState();
}

class _AddcategoryListState extends State<AddcategoryList> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int charactersleft = 1100;
  TextEditingController locationController = TextEditingController();
  TextEditingController priceminController = TextEditingController();
  TextEditingController pricemaxController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  FocusNode typeFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode priceminFocus = FocusNode();
  FocusNode pricemaxFocus = FocusNode();

  String token = '';
  Map<String, dynamic> categories = {};
  bool isLoading = true;
  String type = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getHeaderHeight();
      // check(context);
    });
    fetchCategories();
  }

  void check(BuildContext context) async {
    if (await MyStorage.exists(MyTokens.acname)) {
      warningDialog(
        title: 'Fresh Start',
        message:
            'We noticed that you had lately attempted to Add a Listing Before Do you want to continue where you left or want a Fresh Start?',
        actions: [
          ColoredButton(
            text: 'Fresh Start',
            onPressed: () {
              MyStorage.deleteToken(MyTokens.acname);
              Navigator.pop(context);
            },
          ),
          ColoredButton(
            text: 'Continue',
            onPressed: () async {
              if (await MyStorage.exists(MyTokens.packages)) {
                Navigator.pushNamed(context, '/AddCategory_MoreDetails',
                    arguments: {'type': 'Business'});
              } else if (await MyStorage.exists(MyTokens.bsfront)) {
                Navigator.pushNamed(context, '/BusinessSignup_Description');
              } else {
                Navigator.pushNamed(context, '/AddCategory_MoreDetails');
              }
            },
          )
        ],
      ).showDialogBox(context);
    }
  }

  void fetchCategories() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? '';
    type = await MyTokens.getBusinessType();
    final categories = await MyApi.getRequest(
      endpoint: 'business/categories/$type',
      headers: {'Authorization': 'Bearer $token'},
    );
    setState(() {
      this.token = token;
      this.categories = categories ?? {};
      if (categories == null || categories['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something Went Wrong!',
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: MyColors.white,
                  fontWeight: FontWeight.w400)),
          backgroundColor: MyColors.red,
        ));
        return;
      } else {
        isLoading = false;
      }
    });
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
          RefreshIndicator(
            color: MyColors.red,
            displacement: screenHeight * 0.2,
            backgroundColor: MyColors.Dark,
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: _headerHeight),
                  MyTextBox(
                    focusNode: nameFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(descriptionFocus);
                    },
                    hint: 'Name',
                    valueController: nameController,
                  ),
                  DescriptionBox(
                    focusNode: descriptionFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(locationFocus);
                    },
                    valueController: descriptionController,
                    onChanged: (value) =>
                        setState(() => charactersleft = 1100 - value.length),
                  ),
                  SizedBox(
                    width: screenWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${charactersleft} characters left",
                          style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontSize: MaximumThing * 0.015,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyTextBox(
                    focusNode: locationFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(typeFocus);
                    },
                    hint: 'Location',
                    valueController: locationController,
                  ),
                  ResponsiveDropdown(
                      items: isLoading
                          ? []
                          : categories['categories']
                              .map((value) {
                                return value['name'].toString();
                              })
                              .cast<String>()
                              .toList(),
                      labelText: 'Category',
                      onChanged: (value) {
                        typeController.text = value;
                      }),
                  MyTextBox(
                    focusNode: priceminFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(pricemaxFocus);
                    },
                    hint: 'Minimum Price',
                    isNum: true,
                    isPrice: true,
                    valueController: priceminController,
                  ),
                  MyTextBox(
                    focusNode: pricemaxFocus,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    hint: 'Maximum Price',
                    isNum: true,
                    isPrice: true,
                    valueController: pricemaxController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                    child: Center(child: MyDivider()),
                  ),
                  ColoredButton(
                    text: 'Continue',
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          locationController.text.isEmpty ||
                          typeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please fill all the fields'),
                        ));
                        return;
                      }
                      if (charactersleft > 1050) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Description is too Short'),
                        ));
                        return;
                      }
                      if (charactersleft < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Description is too Long'),
                        ));
                        return;
                      }
                      Map<String, dynamic> args = {
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'location': locationController.text,
                        'category': typeController.text,
                        'pricemin': priceminController.text,
                        'pricemax': pricemaxController.text,
                      };
                      if (typeController.text == 'Salon' ||
                          typeController.text == 'Parlour' ||
                          typeController.text == 'Baker and Sweet') {
                        Navigator.pushNamed(context, '/AddCategory_Addons',
                            arguments: args);
                      } else {
                        Navigator.pushNamed(context, '/AddCategory_MoreDetails',
                            arguments: args);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Add Service',
              para: 'Add your Services or Halls in the Application',
            ),
          ),
        ],
      ),
    );
  }
}
