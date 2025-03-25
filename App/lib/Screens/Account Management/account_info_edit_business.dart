import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/picture_options.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class BusinessInfoEditViewModel with ChangeNotifier {
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _token = '';
  Map<String, dynamic> _user = {};
  String _userId = '';
  bool _isLoading = true;
  String _image = '';
  String _type = '';

  File? get selectedImage => _selectedImage;
  TextEditingController get nameController => _nameController;
  TextEditingController get descriptionController => _descriptionController;
  bool get isLoading => _isLoading;
  String get image => _image;

  Future<void> fetchData(BuildContext context) async {
    _userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    _type = await MyTokens.getBusinessType();
    await ApiCall.fetchAPI(
      'businessowner/accountInfo/$_userId/$_type',
      onSuccess: (token, data) {
        if (Navigator.of(context).mounted) {
          _token = token;
          _user = data;
          _nameController.text = _user['businessInfo']['businessName'];
          _descriptionController.text = _user['businessInfo']['Description'];
          _image =
              "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_user['businessInfo']["profilepic"]}";
          _isLoading = false;
          notifyListeners();
        }
      },
      context: context,
    );
  }

  Future<void> pickImage(BuildContext context) async {
    Picture.pickImage(context, callback: (file) {
      _selectedImage = file;
      notifyListeners();
    });
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
    if (_selectedImage != null) {
      final response = await MyApi.postMultipartRequest(
        endpoint: 'editBusinessInfo/',
        body: {
          'userid': _userId,
          'name': _nameController.text,
          'description': _descriptionController.text,
          'type': _type,
        },
        files: {
          'profilePicture': _selectedImage!.path,
        },
      );

      if (response['status'] == 'success') {
        MyScaffold(text: 'Profile Updated Successfully').show(context);
        Navigator.pushNamed(context, '/AccountInfo');
      } else {
        MyScaffold(
                text: 'Failed to upload the profile picture. Please try again.')
            .show(context);
      }
    } else {
      final response2 = await MyApi.postRequest(
        endpoint: 'editBusinessInfo/',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        body: {
          'userid': _userId,
          'name': _nameController.text,
          'description': _descriptionController.text,
        },
      );

      if (response2['status'] == 'success') {
        MyScaffold(text: 'Profile Updated Successfully').show(context);
        Navigator.pushNamed(context, '/AccountInfo');
      } else {
        MyScaffold(text: 'Failed to Update Profile').show(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class BusinessInfoEdit extends StatefulWidget {
  const BusinessInfoEdit({super.key});

  @override
  State<BusinessInfoEdit> createState() => _BusinessInfoEditState();
}

class _BusinessInfoEditState extends State<BusinessInfoEdit> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          setState(() {
            UI_Management.headerHeight = renderbox.size.height;
          });
        },
      );
      Provider.of<BusinessInfoEditViewModel>(context, listen: false)
          .fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BusinessInfoEditViewModel>(context);

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: UI_Management.headerHeight),
                  viewModel.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(MyColors.white),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: Screen.max(context) * 0.04,
                                horizontal: Screen.max(context) * 0.02,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: viewModel.selectedImage !=
                                            null
                                        ? Image.file(viewModel.selectedImage!,
                                                fit: BoxFit.cover)
                                            .image
                                        : NetworkImage(viewModel.image),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: Screen.max(context) * 0.02),
                                    child: InkWell(
                                      onTap: () async {
                                        await viewModel.pickImage(context);
                                      },
                                      child: Text(
                                        "Change Profile Picture",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          decoration: TextDecoration.underline,
                                          fontSize: Screen.max(context) * 0.015,
                                          fontWeight: FontWeight.w400,
                                          color: MyColors.Yellow,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                MyTextBox(
                                  focusNode: FocusNode(),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  },
                                  hint: 'Business Name',
                                  valueController: viewModel.nameController,
                                ),
                                DescriptionBox(
                                  onChanged: (value) {},
                                  focusNode: FocusNode(),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  valueController:
                                      viewModel.descriptionController,
                                ),
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
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await viewModel
                                            .uploadProfilePicture(context);
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                ).showDialogBox(context);
                              },
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                ],
              ),
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
