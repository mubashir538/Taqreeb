import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> searchedUsers = []; 
  bool isLoading = true;
  String loggedInUserId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      QuerySnapshot chatsSnapshot = await _firestore.collection('chats').get();

      final filteredChats =
          await Future.wait(chatsSnapshot.docs.map((chatDoc) async {
        final messagesSnapshot = await _firestore
            .collection('chats')
            .doc(chatDoc.id)
            .collection('messages')
            .limit(1) 
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          final user = await usersCollection
              .doc(messagesSnapshot.docs.first['receiverId'])
              .get();
          return {
            'userId': user.id, 
            'chatimage':
                '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture'] ?? ''}',
            'name': user['firstName'] ?? 'Unknown', 
            'lastMessage': chatDoc['lastMessage'] ?? '',
            'newMessages': chatDoc['unreadMessages'][loggedInUserId] ?? 0,
            'time': chatDoc['lastMessageTime'] ?? ''
          };
        }

        return null; 
      }).toList());

      final chats = filteredChats.where((chat) => chat != null).toList();

      final groupsSnapshot = await _firestore.collection('groups').get();

      final filteredGroups = groupsSnapshot.docs.where((groupDoc) {
        final participants = groupDoc['participants'] as List<dynamic>;
        return participants
            .contains(loggedInUserId); 
      }).map((groupDoc) {
        return {
          'groupId': groupDoc.id,
          'groupImageUrl': groupDoc['groupImageUrl'],
          'name': groupDoc['groupName'],
          'participants': groupDoc['participants'],
        };
      }).toList();

      setState(() {
        userChats.addAll(chats.cast<Map<String, dynamic>>());
        groups = filteredGroups;
      });
    } catch (e) {
      print("Error fetching chats or groups: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchedUsers = [];
      });
    } else {
      try {
        QuerySnapshot userSnapshot = await usersCollection
            .where('username', isGreaterThanOrEqualTo: query)
            .where('username',
                isLessThanOrEqualTo:
                    query + '\uf8ff') 
            .get();

        setState(() {
          searchedUsers = userSnapshot.docs.map((userDoc) {
            return {
              'userId': userDoc.id,
              'chatimage':
                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${userDoc['profilePicture'] ?? ''}',
              'name': '${userDoc['firstName']} ${userDoc['lastName']}',
            };
          }).toList();
        });
      } catch (e) {
        print("Error searching users: $e");
      }
    }
  }

  void _navigateToChatbox(String userId) {
    Navigator.pushNamed(context, '/ChatBox', arguments: {'userId': userId});
  }

  void _navigateToCreateGroup() {
    Navigator.pushNamed(context, '/CreateGroup',
        arguments: {'chats': userChats});
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    var format = DateFormat('h:mm a'); 
    return format.format(dateTime);
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
                  _searchUsers(query); 
                },
                hint: 'Search Users',
                controller: controller,
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView(
                        children: [
                          ...searchedUsers.map((user) => MessageChatButton(
                                image: user['chatimage'],
                                onpressed: () =>
                                    _navigateToChatbox(user['userId']),
                                name: user['name'],
                                message: 'Start a conversation',
                                newMessage: 0,
                                time: '',
                              )),

                          ...userChats.map((chat) => MessageChatButton(
                                image: chat['chatimage'],
                                onpressed: () =>
                                    _navigateToChatbox(chat['userId']),
                                name: chat['name'],
                                message: chat['lastMessage'],
                                newMessage: chat['newMessages'],
                                time: _formatTimestamp(chat['time']),
                              )),

                          ...groups.map((group) => MessageChatButton(
                                image:
                                    '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${group['groupImageUrl']}',
                                onpressed: () {
                                  Navigator.pushNamed(context, '/GroupChatBox',
                                      arguments: {
                                        'groupId': group['groupId'],
                                        'participants': group['participants'],
                                      });
                                }, 
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
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.Dark.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
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
