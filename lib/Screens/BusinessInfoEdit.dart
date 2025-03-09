import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/crop%20screen.dart';
import 'package:taqreeb/Components/description.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:http/http.dart' as https;

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    if (!ishchanged) {
      fetchData();
    }
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final Userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    type = await MyTokens.getBusinessType();
    this.userId = Userid;
    final user = await MyApi.getRequest(
        endpoint: 'businessowner/accountInfo/$Userid/$type',
        headers: {'Authorization': 'Bearer $token'});

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.user = user ?? {};
          if (user == null || user['status'] == 'error') {
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
            ishchanged = true;
          }

          namecontroller.text = user['businessInfo']['businessName'];
          descriptioncontroller.text = user['businessInfo']['Description'];
          image =
              "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['businessInfo']["profilepic"]}";
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
      return result;
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Profile Updated Successfully'),
              backgroundColor: MyColors.Dark,
            ));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile Updated Successfully'),
          backgroundColor: MyColors.Dark,
        ));
        Navigator.pushNamed(context, '/AccountInfo');
      } else {
        warningDialog(
          title: 'Error',
          message: 'Failed to update the profile. Please try again.',
        ).showDialogBox(context);
      }
    }
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
            child: Container(
              child: Column(children: [
                SizedBox(
                  height: _headerHeight,
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
                                vertical: MaximumThing * 0.04,
                                horizontal: MaximumThing * 0.02),
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
                                        left: MaximumThing * 0.02),
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: Text(
                                        "Change Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: MaximumThing * 0.015,
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
                            height: screenHeight * 0.1,
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
              key: _headerKey,
              heading: "Edit Your Business Info",
            ),
          ),
        ],
      ),
    );
  }
}
