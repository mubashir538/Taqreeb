import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Messages/c_message_chat.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/api_service.dart';

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
  bool isSearching = false;

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
          List<String> ids = chatDoc.id.split('-');

          final user = await usersCollection
              .doc(messagesSnapshot.docs.first['receiverId'])
              .get();
          if (user.id != loggedInUserId &&
              (loggedInUserId == ids[0] || loggedInUserId == ids[1])) {
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
        }

        return null;
      }).toList());

      final chats = filteredChats.where((chat) => chat != null).toList();

      final groupsSnapshot = await _firestore.collection('groups').get();

      final filteredGroups = groupsSnapshot.docs.where((groupDoc) {
        final participants = groupDoc['participants'] as List<dynamic>;
        return participants.contains(loggedInUserId);
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
        for (int i = 0; i < userChats.length; i++) {}
        groups = filteredGroups;
      });
    } catch (e) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Error fetching chats or groups: $e'});
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchedUsers = [];
      });
    } else {
      setState(() {
        isSearching = true;
        searchedUsers = userChats
            .where((chat) =>
                chat['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
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
    double max = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);
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
              SizedBox(height: Screen.height(context) * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SearchBox(
                    onChanged: (query) {
                      _searchUsers(query);
                    },
                    hint: 'Search Users',
                    controller: controller,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/search_new_user');
                    },
                    child: Container(
                      padding: EdgeInsets.all(max * 0.015),
                      decoration: BoxDecoration(
                        color: MyColors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.add,
                        color: MyColors.white,
                      ),
                    ),
                  )
                ],
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView(
                        children: isSearching
                            ? [
                                ...searchedUsers.map((user) =>
                                    MessageChatButton(
                                      image: user['chatimage'],
                                      onpressed: () =>
                                          _navigateToChatbox(user['userId']),
                                      name: user['name'],
                                      message: 'Start a conversation',
                                      newMessage: 0,
                                      time: '',
                                    ))
                              ]
                            : [
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
                                        Navigator.pushNamed(
                                            context, '/GroupChatBox',
                                            arguments: {
                                              'groupId': group['groupId'],
                                              'participants':
                                                  group['participants'],
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
            bottom: Screen.height(context) * 0.05,
            right: Screen.height(context) * 0.03,
            child: InkWell(
              onTap: _navigateToCreateGroup,
              child: Container(
                padding: EdgeInsets.all(Screen.width(context) * 0.05),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.Dark.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(max * 0.05),
                    topRight: Radius.circular(max * 0.05),
                    bottomLeft: Radius.circular(max * 0.05),
                  ),
                  color: MyColors.red,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: Screen.width(context) * 0.01),
                    Text(
                      'Create Group',
                      style: GoogleFonts.montserrat(
                          color: MyColors.white,
                          fontSize: max * 0.015,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
