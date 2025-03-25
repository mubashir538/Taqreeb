import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/c_progress_bar.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/picture_options.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/icons.dart';
import 'package:taqreeb/core/utils/images.dart';

class ProfilePictureUpload extends StatefulWidget {
  const ProfilePictureUpload({super.key});

  @override
  State<ProfilePictureUpload> createState() => _ProfilePictureUploadState();
}

class _ProfilePictureUploadState extends State<ProfilePictureUpload> {
  File? _selectedImage;
  String _userType = '';
  final GlobalKey headerKey = GlobalKey();

  // Constants
  static const double _imageSizeFactor = 0.5;
  static const double _uploadIconSizeFactor = 0.03;
  static const int _progressStep = 4;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeUserType();
  }

  void _initializeUserType() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (args != null && args['type'] != null) {
      setState(() {
        _userType = args['type']!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
  }

  void _measureHeaderHeight() {
    UI_Management.getHeaderHeight(
      headerKey: headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  Future<void> _pickImage() async {
    await Picture.pickImage(context, callback: (file) {
      if (mounted) {
        setState(() => _selectedImage = file);
      }
    });
  }

  Future<void> _uploadProfilePicture() async {
    if (_selectedImage == null) {
      MyScaffold(text: 'Please select a profile picture').show(context);
      return;
    }

    try {
      final response = await _performUpload();
      await _handleUploadResponse(response);
    } catch (e) {
      MyScaffold(text: 'Upload failed: ${e.toString()}').show(context);
    }
  }

  Future<Map<String, dynamic>> _performUpload() async {
    final endpoint = _getEndpointForUserType();
    final body = await _getRequestBodyForUserType();
    Map<String, dynamic> files = {'profilePicture': _selectedImage!};

    if (_userType == 'Business') {
      files.addAll({
        'cnicFront': await MyStorage.getToken(MyTokens.bsfront) ?? "",
        'cnicBack': await MyStorage.getToken(MyTokens.bsback) ?? "",
      });
    }

    return await MyApi.postMultipartRequest(
      endpoint: endpoint,
      token: _userType == 'User',
      body: body,
      files: files,
    );
  }

  String _getEndpointForUserType() {
    switch (_userType) {
      case 'Business':
        return 'businessowner/signup/';
      case 'Freelancer':
        return 'freelancer/signup/';
      default:
        return 'userAccountSignup/';
    }
  }

  Future<Map<String, dynamic>> _getRequestBodyForUserType() async {
    switch (_userType) {
      case 'Freelancer':
        return {
          'UserId': await MyStorage.getToken(MyTokens.userId) ?? "",
          'BusinessName': await MyStorage.getToken(MyTokens.fsname) ?? "",
          'Portfoliolink': await MyStorage.getToken(MyTokens.fsportfolio) ?? "",
          'cnic': await MyStorage.getToken(MyTokens.fscnic) ?? "",
          'Description': await MyStorage.getToken(MyTokens.fsdescription) ?? "",
        };
      case 'Business':
        return {
          'id': await MyStorage.getToken(MyTokens.userId) ?? "",
          'businessName': await MyStorage.getToken(MyTokens.bsname) ?? "",
          'cnic': await MyStorage.getToken(MyTokens.bscnic) ?? "",
          'description': await MyStorage.getToken(MyTokens.bsdescription) ?? "",
        };
      default:
        return {
          'firstName': await MyStorage.getToken(MyTokens.sfname) ?? "",
          'lastName': await MyStorage.getToken(MyTokens.slname) ?? "",
          'password': await MyStorage.getToken(MyTokens.spassword) ?? "",
          'contactType':
              await MyStorage.exists(MyTokens.semail) ? 'email' : 'phone',
          'email': await MyStorage.getToken(MyTokens.semail),
          'contactNumber': await MyStorage.getToken(MyTokens.sphone),
          'city': await MyStorage.getToken(MyTokens.scity) ?? "",
          'gender': await MyStorage.getToken(MyTokens.sgender) ?? "",
          'age': await MyStorage.getToken(MyTokens.sage) ?? "",
        };
    }
  }

  Future<void> _handleUploadResponse(Map<String, dynamic> response) async {
    if (response['status'] == 'error') {
      MyScaffold(text: response['message']?.toString() ?? 'Unknown error')
          .show(context);
      return;
    }

    if (_userType == 'Freelancer' || _userType == 'Business') {
      MyTokens.DeleteSignupTokens(_userType);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/SubmissionSucessful',
        ModalRoute.withName('/'),
      );
    } else {
      await _handleUserRegistrationResponse(response);
    }
  }

  Future<void> _handleUserRegistrationResponse(
      Map<String, dynamic> response) async {
    await MyStorage.saveToken(response['refresh'].toString(), 'refresh');
    await MyStorage.saveToken(
        response['access'].toString(), MyTokens.accessToken);
    await MyStorage.saveToken(response['userId'].toString(), 'userId');
    await MyStorage.saveToken(MyTokens.user, MyTokens.userType);

    await MyApi.postRequest(
      endpoint: 'notification/saveFCM',
      body: {
        'token': await MyStorage.yourFCM(),
        'userId': await MyStorage.getToken(MyTokens.userId),
      },
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/HomePage',
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: Screen.width(context),
              constraints: BoxConstraints(minHeight: Screen.height(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: UI_Management.headerHeight),
                  _buildProfileImageSection(),
                  const ProgressBar(Progress: _progressStep),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Upload Your Profile',
              para:
                  'The Profile Picture or Business Logo will create the impression '
                  'of your brand and will help people to visualize the Brand',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            margin: EdgeInsets.all(Screen.max(context) * 0.04),
            child: Stack(
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            width: Screen.width(context) * _imageSizeFactor,
                            height: Screen.width(context) * _imageSizeFactor,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            MyImages.UploadProfile,
                            width: Screen.width(context) * _imageSizeFactor,
                            height: Screen.width(context) * _imageSizeFactor,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: Screen.width(context) * _uploadIconSizeFactor,
                  left: Screen.width(context) * _uploadIconSizeFactor,
                  child: SvgPicture.asset(
                    MyIcons.upload,
                    width: Screen.max(context) * _uploadIconSizeFactor,
                    height: Screen.max(context) * _uploadIconSizeFactor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const MyDivider(),
        ColoredButton(
          text: 'Upload Profile',
          onPressed: _uploadProfilePicture,
        ),
      ],
    );
  }
}
