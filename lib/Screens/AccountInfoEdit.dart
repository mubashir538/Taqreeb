import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/crop%20screen.dart';
import 'package:taqreeb/Components/dropdown.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:http/http.dart' as https;

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

  get http => null;

  @override
  void dispose() {
    super.dispose();
    fnamecontroller.dispose();
    lastnameController.dispose();
    genderController.dispose();
    locationcontroller.dispose();
    fnameFocus.dispose();
    lastnameFocus.dispose();
    genderFocus.dispose();
    locationFocus.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());

    fetchData();
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    this.userId = userid;
    final user = await MyApi.getRequest(
        endpoint: 'accountInfo/$userid',
        headers: {'Authorization': 'Bearer $token'}
        //  headers: {
        //   'Authorization': 'Bearer $token',
        // }
        );

    // Update the state
    setState(() {
      this.token = token;
      this.user = user ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading

      fnamecontroller.text = user['firstName'];
      lastnameController.text = user['lastName'];
      genderController.text = user['gender'];
      locationcontroller.text = user['city'];
      genderController.text = user['gender'];
      image =
          "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}";
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageBytes = await File(pickedFile.path).readAsBytes();

        // Show the cropping popup
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

// Save the cropped image to a file
  Future<File> _saveCroppedImage(Uint8List croppedBytes) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/cropped_image.png';
    final croppedFile = File(path);
    await croppedFile.writeAsBytes(croppedBytes);
    return croppedFile;
  }

  Future<File> _compressImage(File file) async {
    // Ensure the file has a valid extension for compression
    final originalPath = file.path;
    final compressedPath =
        originalPath.replaceFirst(RegExp(r'\.\w+$'), '_compressed.jpg');

    // Compress the image using FlutterImageCompress
    final result = await FlutterImageCompress.compressAndGetFile(
      originalPath,
      compressedPath,
      quality:
          50, // Adjust quality as needed (higher is better quality, lower is more compression)
    );

    // Return the compressed file or the original if compression fails
    if (result != null) {
      return result;
    } else {
      throw Exception('Image compression failed.');
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage != null) {
      try {
        // Create a multipart request to upload the image
        final request = https.MultipartRequest(
            'POST', Uri.parse(MyApi.baseUrl + 'editaccountinfo/'));

        // Add the image file
        request.files.add(await https.MultipartFile.fromPath(
          'profilePicture',
          _selectedImage!.path,
        ));
        print('Profile Picture: ${_selectedImage!.path}');

        // Add additional fields
        request.fields['userid'] = userId;
        request.fields['firstName'] = fnamecontroller.text;
        request.fields['lastName'] = lastnameController.text;
        request.fields['city'] = locationcontroller.text;
        request.fields['gender'] = genderController.text;

        // Send the request
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
          // Failure
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
          await MyApi.postRequest(endpoint: 'editaccountinfo/', headers: {
        'Authorization': 'Bearer $token'
      }, body: {
        'userid': userId,
        'firstName': fnamecontroller.text,
        'lastName': lastnameController.text,
        'city': locationcontroller.text,
        'gender': genderController.text
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
                                  focusNode: fnameFocus,
                                  onFieldSubmitted: (_){
                                    FocusScope.of(context).requestFocus(lastnameFocus);
                                  },
                                  hint: 'First Name',
                                  valueController: fnamecontroller),
                              MyTextBox(
                                focusNode: lastnameFocus,
                                onFieldSubmitted: (_){
                                  FocusScope.of(context).requestFocus(locationFocus);
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
                                onFieldSubmitted: (_){
                                  FocusScope.of(context).unfocus();
                                },
                                  hint: 'City',
                                  valueController: locationcontroller),
                            ],
                          ),

                          //Divider
                          SizedBox(
                            height: screenHeight * 0.1,
                            child: Center(child: MyDivider()),
                          ),
                          //Colored Button
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
              heading: "Edit Your Personal Info",
            ),
          ),
        ],
      ),
    );
  }
}
