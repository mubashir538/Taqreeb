import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchChatsAndGroups();
  }

  Future<void> _fetchChatsAndGroups() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch user chats
      final userChatsSnapshot = await usersCollection.get();
      final chats = userChatsSnapshot.docs.map((doc) {
        return {
          'userId': doc.id,
          'name': "${doc['firstName']} ${doc['lastName']}",
          'lastMessage': '${doc['firstName']} is also using Taqreeb',
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
        userChats = chats;
        groups = fetchedGroups;
      });
    } catch (e) {
      print("Error fetching chats or groups: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _navigateToCreateGroup() {
    Navigator.pushNamed(context, '/CreateGroup',
        arguments: {'chats': userChats});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(
                  heading: "Chats",
                  para: "View your chats and groups below.",
                ),
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
                  hint: 'Search by name',
                  controller: controller,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: ListView(
                          children: [
                            ...userChats.map((chat) => MessageChatButton(
                                  onpressed: () => {}, // Navigate to chat
                                  name: chat['name'],
                                  message: chat['lastMessage'],
                                  newMessage: 0,
                                  time: '11:30 AM',
                                )),
                            Divider(color: MyColors.white),
                            ...groups.map((group) => MessageChatButton(
                                  onpressed: () => {}, // Navigate to group chat
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
