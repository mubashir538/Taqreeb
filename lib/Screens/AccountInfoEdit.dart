import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
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
  String token = '';
  Map<String, dynamic> user = {};
  String userId = '';
  bool isLoading = true;
  String image = '';

  get http => null;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken('accessToken') ?? "";
    final userid = await MyStorage.getToken('userId') ?? "";
    this.userId = userid;
    final user = await MyApi.getRequest(
      endpoint: 'accountInfo/$userid',
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
        final compressedFile = await _compressImage(File(pickedFile.path));
        setState(() {
          _selectedImage = compressedFile;
        });
      }
    } catch (e) {
      warningDialog(
              title: 'Error',
              message: 'Failed to pick an image. Please try again.')
          .showDialogBox(context);
    }
  }

  Future<File> _compressImage(File file) async {
    final compressedPath = file.path.replaceFirst('.jpg', '_compressed.jpg');
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      compressedPath,
      quality: 50,
    );
    return compressedFile ?? file;
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
          await MyApi.postRequest(endpoint: 'editaccountinfo/', body: {
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Header(
              heading: "Edit Your Personal Info",
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
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
                                margin:
                                    EdgeInsets.only(left: MaximumThing * 0.02),
                                child: InkWell(
                                  onTap: _pickImage,
                                  child: Text(
                                    "Change Profile Picture",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        decoration: TextDecoration.underline,
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
                              hint: 'First Name',
                              valueController: fnamecontroller),
                          MyTextBox(
                              hint: 'Last Name',
                              valueController: lastnameController),
                          ResponsiveDropdown(
                              items: ['Male', 'Female'],
                              labelText: 'Gender',
                              onChanged: (value) {
                                genderController.text = value;
                              }),
                          MyTextBox(
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
    );
  }
}
