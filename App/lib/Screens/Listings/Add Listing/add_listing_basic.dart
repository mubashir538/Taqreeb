import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_location.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class AddcategoryList extends StatefulWidget {
  const AddcategoryList({super.key});

  @override
  State<AddcategoryList> createState() => _AddcategoryListState();
}

class _AddcategoryListState extends State<AddcategoryList> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int charactersleft = 1100;
  TextEditingController locationController =
      TextEditingController(text: ' fsd');
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
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
          headerKey: headerKey,
          callback: (renderbox) {
            changeHeight(renderbox);
          });
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
        MyScaffold(text: 'Something Went Wrong!').show(context);
        return;
      } else {
        isLoading = false;
      }
    });
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
          RefreshIndicator(
            color: MyColors.red,
            displacement: Screen.height(context) * 0.2,
            backgroundColor: MyColors.Dark,
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              setState(() {});
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: UI_Management.headerHeight),
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
                    width: Screen.width(context) * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${charactersleft} characters left",
                          style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontSize: Screen.max(context) * 0.015,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  LocationInputWidget(
                      locationController: locationController,
                      onLocationChanged: (value) {
                        locationController.text = value;
                      }),
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
                    hint: 'Screen.max(context) Price',
                    isNum: true,
                    isPrice: true,
                    valueController: pricemaxController,
                  ),
                  SizedBox(
                    height: Screen.height(context) * 0.1,
                    child: Center(child: MyDivider()),
                  ),
                  ColoredButton(
                    text: 'Continue',
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          locationController.text.isEmpty ||
                          typeController.text.isEmpty) {
                        MyScaffold(text: 'Please fill all the fields')
                            .show(context);
                        return;
                      }
                      if (charactersleft > 1050) {
                        MyScaffold(text: 'Description is too Short')
                            .show(context);
                        return;
                      }
                      if (charactersleft < 0) {
                        MyScaffold(text: 'Description is too Long')
                            .show(context);
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
              key: headerKey,
              heading: 'Add Service',
              para: 'Add your Services or Halls in the Application',
            ),
          ),
        ],
      ),
    );
  }
}
