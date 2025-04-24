import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<Map<String, dynamic>> _selectedUsers = [];
  final List<Map<String, dynamic>> _availableUsers = [];
  final GlobalKey _headerKey = GlobalKey();
  final ImagePicker _imagePicker = ImagePicker();

  File? _groupImage;
  String? _groupImageUrl;
  bool _isPicking = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeaderHeight());
    _addCurrentUser();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _measureHeaderHeight() {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderBox) {
        if (mounted) {
          setState(() {
            UI_Management.headerHeight = renderBox.size.height;
          });
        }
      },
    );
  }

  void _addCurrentUser() async {
    final userId = await MyStorage.getToken(MyTokens.userId);
    if (userId != null) {
      _selectedUsers.add({'userId': userId});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_availableUsers.isNotEmpty) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['chats'] != null) {
      setState(() {
        _availableUsers.addAll(args['chats']);
      });
    }
  }

  void _toggleUserSelection(Map<String, dynamic> user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  Future<void> _pickGroupImage() async {
    if (_isPicking) return;

    setState(() => _isPicking = true);

    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 600,
        maxWidth: 600,
      );

      if (pickedImage != null && mounted) {
        setState(() => _groupImage = File(pickedImage.path));
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _uploadGroupImage() async {
    if (_groupImage == null) {
      _showError('Please select a Group Image to upload.');
      return;
    }

    final response = await MyApi.postMultipartRequest(
      endpoint: 'saveGroupProfileImage/',
      body: {'userid': await MyStorage.getToken(MyTokens.userId) ?? ""},
      files: {'image': _groupImage!.path},
    );

    if (response['status'] == 'success') {
      setState(() => _groupImageUrl = response['path']);
    } else {
      _showError('Failed to upload image.');
    }
  }

  Future<void> _createGroup() async {
    if (_groupNameController.text.isEmpty) {
      _showError('Group name is required');
      return;
    }

    if (_selectedUsers.length < 2) {
      _showError('Please select at least one other participant');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_groupImage != null) {
        await _uploadGroupImage();
      }

      await FirebaseFirestore.instance.collection('groups').add({
        'groupName': _groupNameController.text,
        'participants': _selectedUsers.map((u) => u['userId']).toList(),
        'groupImageUrl': _groupImageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/ChatsScreen');
      }
    } catch (e) {
      _showError('Failed to create group: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    MyScaffold(text: message).show(context);
  }

  Widget _buildGroupImagePicker() {
    return GestureDetector(
      onTap: _pickGroupImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _groupImage != null ? FileImage(_groupImage!) : null,
        backgroundColor: MyColors.darkLighter,
        child: _groupImage == null
            ? Icon(
                Icons.add_photo_alternate,
                color: MyColors.white,
                size: 30,
              )
            : null,
      ),
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> user) {
    final isSelected = _selectedUsers.contains(user);

    return GestureDetector(
      onTap: () => _toggleUserSelection(user),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Screen.width(context) * 0.06,
          vertical: Screen.width(context) * 0.02,
        ),
        padding: EdgeInsets.all(Screen.width(context) * 0.04),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.red.withAlpha(51) : MyColors.darkLighter,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user['name'],
              style: TextStyle(color: MyColors.white),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? MyColors.red : MyColors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: UI_Management.headerHeight),
              SizedBox(height: Screen.max(context) * 0.03),
              _buildGroupImagePicker(),
              SizedBox(height: Screen.max(context) * 0.03),
              MyTextBox(
                hint: 'Enter Group Name',
                valueController: _groupNameController,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _availableUsers.length,
                  itemBuilder: (context, index) =>
                      _buildUserListItem(_availableUsers[index]),
                ),
              ),
              ColoredButton(
                text: 'Create Group',
                onPressed: _isLoading ? null : _createGroup,
              ),
            ],
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Create Group",
              para: "Add participants, name your group, and upload an image.",
            ),
          ),
        ],
      ),
    );
  }
}
