import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/text_box.dart';
import 'package:taqreeb/theme/color.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  List<Map<String, dynamic>> selectedUsers = [];
  List<Map<String, dynamic>> availableUsers = [];
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
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

  Future<void> _createGroup() async {
    if (groupNameController.text.isEmpty || selectedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Group name and participants are required.',
          style: TextStyle(color: MyColors.white),
        ),
        backgroundColor: MyColors.red,
      ));
      return;
    }

    final groupData = {
      'groupName': groupNameController.text,
      'participants': selectedUsers.map((u) => u['userId']).toList(),
    };

    await FirebaseFirestore.instance.collection('groups').add(groupData);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: _headerHeight),
              SizedBox(height: MaximumThing * 0.03),
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
                            horizontal: screenWidth * 0.06,
                            vertical: screenWidth * 0.02),
                        padding: EdgeInsets.all(screenWidth * 0.04),
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                child: ElevatedButton(
                  onPressed: _createGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.red,
                    padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.03,
                        horizontal: screenWidth * 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Create Group',
                    style: TextStyle(color: MyColors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
              top: 0,
              child: Header(
                key: _headerKey,
                heading: "Create Group",
                para: "Add participants and name your group.",
              )),
        ],
      ),
    );
  }
}
