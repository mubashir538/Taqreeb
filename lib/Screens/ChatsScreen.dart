import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController controller = TextEditingController();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupsCollection =
      FirebaseFirestore.instance.collection('groups');
  List<Map<String, dynamic>> userChats = [];
  List<Map<String, dynamic>> groups = [];
  bool isLoading = true;
  String loggedInUserId = "";

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    loggedInUserId = await MyStorage.getToken(MyTokens.userId) ?? "";
    _fetchChatsAndGroups();
  }

  Future<void> _fetchChatsAndGroups() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch user chats using contact numbers
      final userChatsSnapshot = await usersCollection.get();
      print(userChatsSnapshot.docs);
      final chats = userChatsSnapshot.docs
          .where((doc) => doc.id != loggedInUserId) // Exclude logged-in user
          .map((doc) {
        return {
          'userId': doc.id,
          'chatimage': '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${doc['profilePicture']}',
          'name': "${_capitalize(doc['firstName'])} ${_capitalize(doc['lastName'])}",
          'lastMessage': '${_capitalize(doc['firstName'])} is also using Taqreeb',
          'newMessages': 0
          // doc['newMessages'] ?? 0, // Example field for new messages
        };
      }).toList();

      // Fetch groups
      final groupsSnapshot = await groupsCollection.get();
      final fetchedGroups = groupsSnapshot.docs.map((doc) {
        return {
          'groupId': doc.id,
          'name': doc['groupName'],
          'participants': doc['participants'],
        };
      }).toList();

      setState(() {
        userChats.addAll(chats);
        groups = fetchedGroups;
      });
    } catch (e) {
      print("Error fetching chats or groups: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _navigateToChatbox(String userId) {
    Navigator.pushNamed(context, '/ChatBox', arguments: {'userId': userId});
  }

  void _navigateToCreateGroup() {
    Navigator.pushNamed(context, '/CreateGroup',
        arguments: {'chats': userChats});
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                heading: "Chats",
                para: "View your chats and groups below.",
              ),
              SizedBox(height: screenHeight * 0.02),
              SearchBox(
                onChanged: (query) {
                  setState(() {
                    userChats = userChats
                        .where((chat) => chat['name']
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                        .toList();
                  });
                },
                hint: 'Search New User',
                controller: controller,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView(
                        children: [
                          ...userChats.map((chat) => MessageChatButton(
                            image: chat['chatimage'],
                                onpressed: () =>
                                    _navigateToChatbox(chat['userId']),
                                name: chat['name'],
                                message: chat['lastMessage'],
                                newMessage:
                                    chat['newMessages'], // Show new messages
                                time: '11:30 AM',
                              )),
                          Divider(color: MyColors.white),
                          ...groups.map((group) => MessageChatButton(
                                onpressed:
                                    () {}, // Handle group chat navigation
                                name: group['name'],
                                message: 'Group Chat',
                                newMessage: 0,
                                time: '',
                              )),
                        ],
                      ),
                    ),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.03,
            right: screenHeight * 0.03,
            child: InkWell(
              onTap: _navigateToCreateGroup,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.red,
                ),
                child: Icon(Icons.add, color: MyColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
