import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/crop%20screen.dart';
import 'package:taqreeb/Components/warningDialog.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my divider.dart';
import 'package:taqreeb/Components/Colored Button.dart';
import 'package:taqreeb/Components/progressbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePictureUpload extends StatefulWidget {
  const ProfilePictureUpload({super.key});

  @override
  _ProfilePictureUploadState createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  File? _selectedImage;
  String type = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    setState(() {
      type = args['type'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
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
    try {
      final tempDir = Directory.systemTemp;
      final compressedPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        compressedPath,
        quality: 50,
      );

      if (compressedFile != null) {
        return compressedFile;
      } else {
        throw Exception("Failed to compress image.");
      }
    } catch (e) {
      throw Exception("Compression error: ${e.toString()}");
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage != null) {
      String apipath = 'userAccountSignup/';
      if (type == 'Business') {
        apipath = 'businessowner/signup/';
      } else if (type == 'Freelancer') {
        apipath = 'freelancer/signup/';
      }
      try {
        final request =
            http.MultipartRequest('POST', Uri.parse(MyApi.baseUrl + apipath));

        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture',
          _selectedImage!.path,
        ));

        if (type == 'Freelancer') {
          final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
          request.headers.addAll({
            'Authorization': 'Bearer $token', 
          });
          final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
          request.fields['UserId'] = userId;
          request.fields['BusinessName'] =
              await MyStorage.getToken(MyTokens.fsname) ?? "";
          request.fields['Portfoliolink'] =
              await MyStorage.getToken(MyTokens.fsportfolio) ?? "";
          request.fields['cnic'] =
              await MyStorage.getToken(MyTokens.fscnic) ?? "";
          request.fields['Description'] =
              await MyStorage.getToken(MyTokens.fsdescription) ?? "";
        } else if (type == 'Business') {
          final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
          request.headers.addAll({
            'Authorization': 'Bearer $token', 
          });

          request.files.add(await http.MultipartFile.fromPath(
            'cnicFront',
            await MyStorage.getToken(MyTokens.bsfront) ?? "",
          ));
          request.files.add(await http.MultipartFile.fromPath(
            'cnicBack',
            await MyStorage.getToken(MyTokens.bsback) ?? "",
          ));

          request.fields['id'] =
              await MyStorage.getToken(MyTokens.userId) ?? "";
          request.fields['businessName'] =
              await MyStorage.getToken(MyTokens.bsname) ?? "";
          request.fields['cnic'] =
              await MyStorage.getToken(MyTokens.bscnic) ?? "";
          request.fields['description'] =
              await MyStorage.getToken(MyTokens.bsdescription) ?? "";
        } else {
          request.fields['firstName'] =
              await MyStorage.getToken(MyTokens.sfname) ?? "";
          request.fields['lastName'] =
              await MyStorage.getToken(MyTokens.slname) ?? "";
          request.fields['password'] =
              await MyStorage.getToken(MyTokens.spassword) ?? "";
          request.fields['contactType'] =
              await MyStorage.exists(MyTokens.semail) ? 'email' : 'phone';
          if (request.fields['contactType'] == 'email') {
            request.fields['email'] =
                await MyStorage.getToken(MyTokens.semail) ?? "";
          } else {
            request.fields['contactNumber'] =
                await MyStorage.getToken(MyTokens.sphone) ?? "";
          }
          request.fields['city'] =
              await MyStorage.getToken(MyTokens.scity) ?? "";
          request.fields['gender'] =
              await MyStorage.getToken(MyTokens.sgender) ?? "";
        }
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
                      Navigator.pushNamedAndRemoveUntil(context,
                          '/Signup_EmailOTPSend', ModalRoute.withName('/'));
                    })
              ],
            ).showDialogBox(context);
          } else {

            if (type == 'Freelancer') {
              MyStorage.deleteToken(MyTokens.fscnic);
              MyStorage.deleteToken(MyTokens.fsname);
              MyStorage.deleteToken(MyTokens.fsportfolio);
              MyStorage.deleteToken(MyTokens.fsdescription);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/SubmissionSucessful', ModalRoute.withName('/'));
            } else if (type == 'Business') {
              MyStorage.deleteToken('bscnic');
              MyStorage.deleteToken('bsname');
              MyStorage.deleteToken('bsusername');
              MyStorage.deleteToken('bsfront');
              MyStorage.deleteToken('bsback');
              MyStorage.deleteToken('bsdescription');
              Navigator.pushNamedAndRemoveUntil(
                  context, '/SubmissionSucessful', ModalRoute.withName('/'));
            } else {
              MyStorage.saveToken(
                  jsonResponse['refresh'].toString(), 'refresh');
              MyStorage.saveToken(
                  jsonResponse['access'].toString(), MyTokens.accessToken);
              MyStorage.saveToken(jsonResponse['userId'].toString(), 'userId');
              MyStorage.saveToken(MyTokens.user, MyTokens.userType);
              MyStorage.deleteToken('spassword');
              MyStorage.deleteToken('sfname');
              MyStorage.deleteToken('slname');
              MyStorage.deleteToken('semail');
              MyStorage.deleteToken('scity');
              MyStorage.deleteToken('sgender');
              Navigator.pushNamedAndRemoveUntil(
                  context, '/HomePage', ModalRoute.withName('/'));
            }
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
      warningDialog(
              title: 'No Image Selected',
              message: 'Please select an image before uploading.')
          .showDialogBox(context);
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
              width: screenWidth,
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: _headerHeight,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          margin: EdgeInsets.all(MaximumThing * 0.04),
                          child: Stack(
                            children: [
                              ClipOval(
                                child: Container(
                                  color: Colors.white,
                                  child: _selectedImage != null
                                      ? Image.file(
                                          _selectedImage!,
                                          width: screenWidth * 0.5,
                                          height: screenWidth * 0.5,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          MyImages.UploadProfile,
                                          width: screenWidth * 0.5,
                                          height: screenWidth * 0.5,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: screenWidth * 0.03,
                                left: screenWidth * 0.03,
                                child: SvgPicture.asset(
                                  MyIcons.upload,
                                  width: MaximumThing * 0.03,
                                  height: MaximumThing * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MyDivider(),
                      ColoredButton(
                        text: 'Upload Profile',
                        onPressed: _uploadProfilePicture,
                      ),
                    ],
                  ),
                  ProgressBar(Progress: 4)
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Upload Your Profile',
              para:
                  'The Profile Picture or Business Logo will create the impression of your brand and will help people to visualize the Brand',
            ),
          ),
        ],
      ),
    );
  }
}
