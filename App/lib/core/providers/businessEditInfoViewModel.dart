import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/picture_options.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';

class BusinessInfoEditViewModel with ChangeNotifier {
  BusinessData businessData;
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _token = '';
  String _userId = '';
  bool _isLoading = true;
  String _type = '';
  bool _hasError = false;

  BusinessInfoEditViewModel(this.businessData) {
    initializeWithBusinessData();
    // Listen to changes in businessData
    businessData.addListener(_onBusinessDataChanged);
  }

  // Getters
  File? get selectedImage => _selectedImage;
  TextEditingController get nameController => _nameController;
  TextEditingController get descriptionController => _descriptionController;
  bool get isLoading => _isLoading;
  String get type => _type;

  void initializeWithBusinessData() {
    if (businessData.businessInfo.isNotEmpty) {
      _nameController.text = businessData.businessInfo['businessName'] ?? '';
      _descriptionController.text =
          businessData.businessInfo['Description'] ?? '';
    }
  }

  void _onBusinessDataChanged() {
    // Update controllers when businessData changes
    if (_nameController.text != businessData.businessInfo['businessName']) {
      _nameController.text = businessData.businessInfo['businessName'] ?? '';
    }
    if (_descriptionController.text !=
        businessData.businessInfo['Description']) {
      _descriptionController.text =
          businessData.businessInfo['Description'] ?? '';
    }

    // Clear selected image if it matches the current profile image
    if (_selectedImage != null &&
        businessData.profileImageUrl != null &&
        _selectedImage!.path
            .endsWith(businessData.profileImageUrl!.split('/').last)) {
      _selectedImage = null;
    }

    notifyListeners();
  }

  Future<void> fetchData(BuildContext context) async {
    if (!_isLoading) {
      _isLoading = true;
      _hasError = false;
      notifyListeners();
    }

    try {
      _userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      _type = await MyTokens.getBusinessType();

      await ApiCall.fetchAPI(
        'businessowner/accountInfo/$_userId/$_type',
        onSuccess: (token, data) {
          _token = token;
          if (data['businessInfo'] != null) {
            businessData.updateBusinessInfo(
              data['businessInfo'],
              imageUrl: data['businessInfo']["profilepic"] != null
                  ? "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${data['businessInfo']["profilepic"]}"
                  : null,
            );
            _nameController.text = data['businessInfo']['businessName'] ?? '';
            _descriptionController.text =
                data['businessInfo']['Description'] ?? '';
          }
          _isLoading = false;
          _hasError = false;
          notifyListeners();
        },
        onError: () {
          _isLoading = false;
          _hasError = true;
          notifyListeners();
          if (Navigator.of(context).mounted) {
            MyScaffold(text: 'Failed to load business info').show(context);
          }
        },
        context: context,
      );
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
      if (Navigator.of(context).mounted) {
        MyScaffold(text: 'Error: ${e.toString()}').show(context);
      }
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      await Picture.pickImage(
        context,
        callback: (File compressedFile) {
          _selectedImage = compressedFile;
          notifyListeners();
        },
      );
    } catch (e) {
      MyScaffold(text: 'Failed to pick image: ${e.toString()}').show(context);
    }
  }

  Future<void> uploadProfilePicture(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      _type = await MyTokens.getBusinessType();

      if (_selectedImage != null) {
        final response = await MyApi.postMultipartRequest(
          endpoint: 'editBusinessInfo/',
          body: {
            'userid': _userId,
            'name': _nameController.text,
            'description': _descriptionController.text,
            'type': _type,
          },
          files: {'profilePicture': _selectedImage!.path},
        );

        if (response['status'] == 'success') {
          final newImageUrl = response['profilepic'] != null
              ? "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${response['profilepic']}"
              : null;

          // Explicitly update the profile image
          businessData.updateBusinessInfo(
            {
              ...businessData.businessInfo,
              'businessName': _nameController.text,
              'Description': _descriptionController.text,
            },
            imageUrl: newImageUrl,
          );

          // Clear the selected image after successful upload
          _selectedImage = null;
          notifyListeners();

          MyScaffold(text: 'Profile Updated Successfully').show(context);
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
          }
        } else {
          MyScaffold(text: 'Failed to update profile').show(context);
        }
      } else {
        MyScaffold(text: 'Failed to update profile').show(context);
      }
    } catch (e) {
      MyScaffold(text: 'Error: ${e.toString()}').show(context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _selectedImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    businessData.removeListener(_onBusinessDataChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
