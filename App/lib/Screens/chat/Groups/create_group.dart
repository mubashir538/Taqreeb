import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/api_service.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  List<Map<String, dynamic>> selectedUsers = [];
  List<Map<String, dynamic>> availableUsers = [];
  File? _groupImage;
  String? _groupImageUrl;
  bool isChanged = false;
  GlobalKey headerKey = GlobalKey();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
    addUser();
  }

  void addUser() async {
    selectedUsers
        .add({'userId': await MyStorage.getToken(MyTokens.userId) ?? ""});
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  bool _isPicking = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isChanged) return;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    availableUsers = args['chats'] ?? [];
    isChanged = true;
  }

  void _toggleUserSelection(Map<String, dynamic> user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  Future<void> _pickGroupImage() async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 600, maxWidth: 600);
    if (pickedImage != null) {
      setState(() {
        _groupImage = File(pickedImage.path);
      });
    }

    setState(() {
      _isPicking = false;
    });
  }

  Future<void> _uploadGroupImage() async {
    if (_groupImage == null) {
      MyScaffold(text: 'Please select a Group Image to upload.').show(context);
    }
    ;

    final request = http.MultipartRequest(
        'POST', Uri.parse('${MyApi.baseUrl}saveGroupProfileImage/'));
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      _groupImage!.path,
    ));

    request.fields['userid'] = await MyStorage.getToken(MyTokens.userId) ?? "";

    request.headers.addAll({
      'Authorization':
          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(resBody);
      setState(() {
        _groupImageUrl = jsonResponse['path'];
      });
    } else {
      MyScaffold(text: 'Failed to upload image.').show(context);
    }
  }

  Future<void> _createGroup() async {
    if (groupNameController.text.isEmpty || selectedUsers.isEmpty) {
      MyScaffold(text: 'Group name and participants are required.')
          .show(context);
      return;
    }

    if (_groupImage != null) {
      await _uploadGroupImage();
      final groupData = {
        'groupName': groupNameController.text,
        'participants': selectedUsers.map((u) => u['userId']).toList(),
        'groupImageUrl': _groupImageUrl ?? '',
      };

      await FirebaseFirestore.instance.collection('groups').add(groupData);
      Navigator.pushReplacementNamed(context, '/ChatsScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: UI_Management.headerHeight),
              SizedBox(height: Screen.max(context) * 0.03),
              GestureDetector(
                onTap: _pickGroupImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _groupImage != null ? FileImage(_groupImage!) : null,
                  backgroundColor: MyColors.DarkLighter,
                  child: _groupImage == null
                      ? Icon(Icons.add_photo_alternate,
                          color: MyColors.white, size: 30)
                      : null,
                ),
              ),
              SizedBox(height: Screen.max(context) * 0.03),
              MyTextBox(
                  hint: 'Enter Group Name',
                  valueController: groupNameController),
              Expanded(
                child: ListView.builder(
                  itemCount: availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = availableUsers[index];
                    return GestureDetector(
                      onTap: () => _toggleUserSelection(user),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: Screen.width(context) * 0.06,
                            vertical: Screen.width(context) * 0.02),
                        padding: EdgeInsets.all(Screen.width(context) * 0.04),
                        decoration: BoxDecoration(
                          color: selectedUsers.contains(user)
                              ? MyColors.red.withOpacity(0.2)
                              : MyColors.DarkLighter,
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
                              selectedUsers.contains(user)
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: selectedUsers.contains(user)
                                  ? MyColors.red
                                  : MyColors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ColoredButton(
                text: 'Create Group',
                onPressed: _createGroup,
              ),
            ],
          ),
          Positioned(
              top: 0,
              child: Header(
                key: headerKey,
                heading: "Create Group",
                para: "Add participants, name your group, and upload an image.",
              )),
        ],
      ),
    );
  }
}
