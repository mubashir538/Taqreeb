import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/picture_options.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
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
        .addPostFrameCallback((_) => UImanagement.getHeaderHeight(
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
          user = data;
        });
      }
    }, context: mounted ? context : null);
    if (user.isEmpty) return;
    isLoading = false;
    ishchanged = true;
    fnamecontroller.text = user['firstName'];
    lastnameController.text = user['lastName'];
    genderController.text = user['gender'];
    locationcontroller.text = user['city'];
    genderController.text = user['gender'];
    image =
        "${user['profilePicture']}";
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
        'profilePicture': _selectedImage!.path
      });

      if (response['status'] == 'success') {
        MyScaffold(text: 'Profile Updated Successfully').show(context);
        MyApi.getRequest(
            endpoint: 'accountInfo/$userId/',
            refresh: true,
            headers: {'Authorization': 'Bearer $token'});
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
        MyApi.getRequest(
            endpoint: 'accountInfo/$userId/',
            refresh: true,
            headers: {'Authorization': 'Bearer $token'});

        context.pushNamedTransition(
            routeName: '/AccountInfo',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }, onError: () {
        MyScaffold(text: 'Failed to update the profile. Please try again.')
            .show(context);
      });
    }
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              child: Column(children: [
                SizedBox(
                  height: UImanagement.headerHeight,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colors.white),
                      ))
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Screen.max(context) * 0.04,
                                horizontal: Screen.max(context) * 0.02),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Picture.pickImage(context,
                                              callback: (file) {
                                            setState(() {
                                              _selectedImage = file;
                                            });
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: Screen.max(context) * 0.1,
                                          backgroundImage:
                                              _selectedImage != null
                                                  ? Image.file(_selectedImage!,
                                                          fit: BoxFit.cover)
                                                      .image
                                                  : NetworkImage(image),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () async {
                                            Picture.pickImage(context,
                                                callback: (file) {
                                              setState(() {
                                                _selectedImage = file;
                                              });
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                Screen.max(context) * 0.02),
                                            decoration: BoxDecoration(
                                              color: colors.whiteDarker,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.pen,
                                              size: Screen.max(context) * 0.025,
                                              color: colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Column(
                            children: [
                              MyTextBox(
                                  prefixIcon: FontAwesomeIcons.user,
                                  focusNode: fnameFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(lastnameFocus);
                                  },
                                  hint: 'First Name',
                                  valueController: fnamecontroller),
                              MyTextBox(
                                  prefixIcon: FontAwesomeIcons.user,
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
                                  prefixIcon: FontAwesomeIcons.locationDot,
                                  focusNode: locationFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  hint: 'City',
                                  valueController: locationcontroller),
                            ],
                          ),
                          SizedBox(
                            height: Screen.max(context) * 0.02,
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
                                        context.pushNamedTransition(
                                            routeName: '/AccountInfo',
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                            duration:
                                                Duration(milliseconds: 300));
                                      },
                                      child: Text('Save')),
                                ],
                              ).showDialogBox(context);
                            },
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
