import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/picture_options.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class AccountInfoEdit extends StatefulWidget {
  const AccountInfoEdit({super.key});

  @override
  State<AccountInfoEdit> createState() => _AccountInfoEditState();
}

class _AccountInfoEditState extends State<AccountInfoEdit> {
  File? _selectedImage;
  TextEditingController fnamecontroller = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController locationcontroller = TextEditingController();
  FocusNode fnameFocus = FocusNode();
  FocusNode lastnameFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  String token = '';
  Map<String, dynamic> user = {};
  String userId = '';
  bool isLoading = true;
  String image = '';
  bool ishchanged = false;
  get http => null;
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
    if (!ishchanged) {
      fetchData();
    }
  }

  void fetchData() async {
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    userId = userid;
    await ApiCall.fetchAPI('accountInfo/$userid/', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          this.token = token;
          user = user;
        });
      }
    }, context: mounted ? context : null);
    isLoading = false;
    ishchanged = true;
    fnamecontroller.text = user['firstName'];
    lastnameController.text = user['lastName'];
    genderController.text = user['gender'];
    locationcontroller.text = user['city'];
    genderController.text = user['gender'];
    image =
        "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage != null) {
      final response =
          await MyApi.postMultipartRequest(endpoint: 'editaccountinfo/', body: {
        'userid': userId,
        'firstName': fnamecontroller.text,
        'lastName': lastnameController.text,
        'city': locationcontroller.text,
        'gender': genderController.text
      }, files: {
        'profilePicture': _selectedImage
      });

      if (response['status'] == 'success') {
        MyScaffold(text: 'Profile Updated Successfully').show(context);
      } else {
        MyScaffold(text: 'Failed to update the profile. Please try again.')
            .show(context);
      }
    } else {
      ApiCall.fetchAPI('editaccountinfo/', type: 'post', body: {
        'userid': userId,
        'firstName': fnamecontroller.text,
        'lastName': lastnameController.text,
        'city': locationcontroller.text,
        'gender': genderController.text
      }, onSuccess: (token, data) {
        MyScaffold(text: 'Profile Updated Successfully').show(context);
        Navigator.pushNamed(context, '/AccountInfo');
      }, onError: () {
        MyScaffold(text: 'Failed to update the profile. Please try again.')
            .show(context);
      });
    }
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
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(children: [
                SizedBox(
                  height: UI_Management.headerHeight,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(MyColors.white),
                      ))
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Screen.max(context) * 0.04,
                                horizontal: Screen.max(context) * 0.02),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: _selectedImage != null
                                        ? Image.file(_selectedImage!,
                                                fit: BoxFit.cover)
                                            .image
                                        : NetworkImage(image),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: Screen.max(context) * 0.02),
                                    child: InkWell(
                                      onTap: () async {
                                        Picture.pickImage(context,
                                            callback: (file) {
                                          setState(() {
                                            _selectedImage = file;
                                          });
                                        });
                                      },
                                      child: Text(
                                        "Change Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize:
                                                Screen.max(context) * 0.015,
                                            fontWeight: FontWeight.w400,
                                            color: MyColors.yellow),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Column(
                            children: [
                              MyTextBox(
                                  focusNode: fnameFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(lastnameFocus);
                                  },
                                  hint: 'First Name',
                                  valueController: fnamecontroller),
                              MyTextBox(
                                  focusNode: lastnameFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(locationFocus);
                                  },
                                  hint: 'Last Name',
                                  valueController: lastnameController),
                              ResponsiveDropdown(
                                  items: ['Male', 'Female'],
                                  labelText: 'Gender',
                                  onChanged: (value) {
                                    genderController.text = value;
                                  }),
                              MyTextBox(
                                  focusNode: locationFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  hint: 'City',
                                  valueController: locationcontroller),
                            ],
                          ),
                          SizedBox(
                            height: Screen.height(context) * 0.1,
                            child: Center(child: MyDivider()),
                          ),
                          ColoredButton(
                            text: 'Save',
                            onPressed: () {
                              WarningDialog(
                                title: 'Save Changes',
                                message:
                                    'Are you sure you want to save the changes?',
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        _uploadProfilePicture();
                                        Navigator.pushNamed(
                                            context, '/AccountInfo');
                                      },
                                      child: Text('Save')),
                                ],
                              ).showDialogBox(context);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      )
              ]),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: "Edit Your Personal Info",
            ),
          ),
        ],
      ),
    );
  }
}
