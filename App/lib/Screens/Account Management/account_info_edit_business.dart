import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/crop_dialog.dart';
import 'package:http/http.dart' as https;
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessInfoEdit extends StatefulWidget {
  const BusinessInfoEdit({super.key});

  @override
  State<BusinessInfoEdit> createState() => _BusinessInfoEditState();
}

class _BusinessInfoEditState extends State<BusinessInfoEdit> {
  File? _selectedImage;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  String token = '';
  Map<String, dynamic> user = {};
  String userId = '';
  bool isLoading = true;
  String image = '';
  bool ishchanged = false;
  get http => null;
  String type = '';
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
    type = await MyTokens.getBusinessType();
    userId = userid;
    await ApiCall.fetchAPI('businessowner/accountInfo/$userid/$type',
        onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          user = user;
          this.token = token;
        });
      }
    }, context: mounted ? context : null);
    namecontroller.text = user['businessInfo']['businessName'];
    descriptioncontroller.text = user['businessInfo']['Description'];
    image =
        "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']["profilepic"]}";
    ishchanged = true;
    isLoading = false;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await File(pickedFile.path).readAsBytes();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CropPopup(
              imageBytes: imageBytes,
              onCropped: (croppedBytes) async {
                final croppedFile = await _saveCroppedImage(croppedBytes);
                final compressedFile = await _compressImage(croppedFile);
                setState(() {
                  _selectedImage = compressedFile;
                });
              },
            );
          },
        );
      }
    } catch (e) {
      warningDialog(
        title: 'Error',
        message: 'Failed to pick or crop the image. Please try again.',
      ).showDialogBox(context);
    }
  }

  Future<File> _saveCroppedImage(Uint8List croppedBytes) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/cropped_image.png';
    final croppedFile = File(path);
    await croppedFile.writeAsBytes(croppedBytes);
    return croppedFile;
  }

  Future<File> _compressImage(File file) async {
    final originalPath = file.path;
    final compressedPath =
        originalPath.replaceFirst(RegExp(r'\.\w+$'), '_compressed.jpg');

    final result = await FlutterImageCompress.compressAndGetFile(
      originalPath,
      compressedPath,
      quality: 50,
    );

    if (result != null) {
      final FcompressedFile = File(result.path);
      return FcompressedFile;
    } else {
      throw Exception('Image compression failed.');
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage != null) {
      try {
        final request = https.MultipartRequest(
            'POST', Uri.parse(MyApi.baseUrl + 'editBusinessInfo/'));

        request.files.add(await https.MultipartFile.fromPath(
          'profilePicture',
          _selectedImage!.path,
        ));
        final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });

        request.fields['userid'] = userId;
        request.fields['name'] = namecontroller.text;
        request.fields['description'] = descriptioncontroller.text;
        request.fields['type'] = type;

        final response = await request.send();

        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        if (response.statusCode == 200) {
          if (jsonResponse['status'] == 'error') {
            warningDialog(
              title: 'Error',
              message: jsonResponse['message'] ?? "",
              actions: [
                ColoredButton(
                    text: 'Ok',
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ).showDialogBox(context);
          } else {
            MyScaffold(text: 'Profile Updated Successfully').show(context);
            Navigator.pushNamed(context, '/AccountInfo');
          }
        } else {
          warningDialog(
                  title: 'Error',
                  message:
                      'Failed to upload the profile picture. Please try again.')
              .showDialogBox(context);
        }
      } catch (e) {
        warningDialog(
                title: 'Error',
                message: 'An error occurred while uploading. Please try again.')
            .showDialogBox(context);
      }
    } else {
      final response2 =
          await MyApi.postRequest(endpoint: 'editBusinessInfo/', headers: {
        'Authorization': 'Bearer $token'
      }, body: {
        'userid': userId,
        'name': namecontroller.text,
        'description': descriptioncontroller.text,
      });

      if (response2['status'] == 'success') {
        MyScaffold(text: 'Profile Updated Successfully').show(context);
        Navigator.pushNamed(context, '/AccountInfo');
      } else {
        warningDialog(
          title: 'Error',
          message: 'Failed to update the profile. Please try again.',
        ).showDialogBox(context);
      }
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
      backgroundColor: MyColors.Dark,
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
                                      onTap: _pickImage,
                                      child: Text(
                                        "Change Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize:
                                                Screen.max(context) * 0.015,
                                            fontWeight: FontWeight.w400,
                                            color: MyColors.Yellow),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          Column(
                            children: [
                              MyTextBox(
                                  focusNode: nameFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(descriptionFocus);
                                  },
                                  hint: 'Business Name',
                                  valueController: namecontroller),
                              DescriptionBox(
                                  onChanged: (value) {},
                                  focusNode: descriptionFocus,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  valueController: descriptioncontroller),
                            ],
                          ),
                          SizedBox(
                            height: Screen.height(context) * 0.1,
                            child: Center(child: MyDivider()),
                          ),
                          ColoredButton(
                            text: 'Save',
                            onPressed: () {
                              warningDialog(
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
              heading: "Edit Your Business Info",
            ),
          ),
        ],
      ),
    );
  }
}
