import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taqreeb/core/services/screen_size.dart';
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
  final TextEditingController _searchController = TextEditingController();
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _groupsCollection =
      FirebaseFirestore.instance.collection('groups');
  CollectionReference _chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  FocusNode searchFocus = FocusNode();

  List<Map<String, dynamic>> _userChats = [];
  List<Map<String, dynamic>> _groups = [];
  List<Map<String, dynamic>> _searchedUsers = [];
  List<Map<String, dynamic>> _searchedGroups = [];
  bool _isLoading = true;
  String _loggedInUserId = "";
  bool _isSearching = false;
  bool _isChanged = false;
  String _type = 'user';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isChanged) return;
    _initialize();
  }

  Future<void> _initialize() async {
    _isChanged = true;
    _loggedInUserId = await MyStorage.getToken(MyTokens.userId) ?? "";
    _fetchChatsAndGroups();
    String type = await MyTokens.getBusinessType();
    _type = type;
    if (type == 'businessowner') {
      _chatsCollection = FirebaseFirestore.instance.collection('BusinessChats');
      _usersCollection = FirebaseFirestore.instance.collection('businessUsers');
    } else if (type == 'freelancer') {
      _chatsCollection =
          FirebaseFirestore.instance.collection('FreelancerChats');
      _usersCollection =
          FirebaseFirestore.instance.collection('freelanceUsers');
    }
  }

  List<Map<String, dynamic>> convertChatsForJson(
      List<Map<String, dynamic>> chats) {
    return chats.map((chat) {
      return chat.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(
              key, value.toDate().toIso8601String()); // Convert to String
          // return MapEntry(key, value.millisecondsSinceEpoch); // Convert to int (epoch time)
        }
        return MapEntry(key, value);
      });
    }).toList();
  }

  List<Map<String, dynamic>> convertJsonToChats(String jsonString) {
    List<dynamic> decodedList = json.decode(jsonString);

    return decodedList.map<Map<String, dynamic>>((chat) {
      return chat.map((key, value) {
        if (key == 'time' && value is String) {
          return MapEntry(
              key,
              Timestamp.fromDate(
                  DateTime.parse(value))); // Convert back to Timestamp
        }
        return MapEntry(key, value);
      });
    }).toList();
  }

  Future<void> _fetchChatsAndGroups() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String cachedData = prefs.getString('cached_chats') ?? "";

      if (cachedData != "") {
        setState(() {
          _userChats = (json.decode(cachedData) as List)
              .map((chat) => Map<String, dynamic>.from(chat).map((key, value) {
                    if (key == 'time' && value is String) {
                      return MapEntry(
                          key, Timestamp.fromDate(DateTime.parse(value)));
                    }
                    return MapEntry(key, value);
                  }))
              .toList();
          // Sort cached chats by time
          _userChats.sort((a, b) =>
              (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));
          _isLoading = false;
        });
      }

      if (_type == 'user') {
        cachedData = prefs.getString('cached_groups') ?? "";
        if (cachedData != "") {
          if (mounted) {
            setState(() {
              _groups = (json.decode(cachedData) as List)
                  .map((chat) =>
                      Map<String, dynamic>.from(chat).map((key, value) {
                        if (key == 'time' && value is String) {
                          return MapEntry(
                              key, Timestamp.fromDate(DateTime.parse(value)));
                        }
                        return MapEntry(key, value);
                      }))
                  .toList();
              // Sort cached groups by time
              _groups.sort((a, b) =>
                  (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));
            });
          }
        }
      }

      final chatsSnapshot = await _chatsCollection.get();

      final filteredChats =
          await Future.wait(chatsSnapshot.docs.map((chatDoc) async {
        final messagesSnapshot = await _chatsCollection
            .doc(chatDoc.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          final List<String> ids = chatDoc.id.split('-');
          String otherUserId =
              messagesSnapshot.docs.first['senderId'] == _loggedInUserId
                  ? messagesSnapshot.docs.first['receiverId']
                  : messagesSnapshot.docs.first['senderId'];

          final user = await _usersCollection.doc(otherUserId).get();
          if (user.exists &&
              (_loggedInUserId == ids[0] || _loggedInUserId == ids[1])) {
            return {
              'userId': user.id,
              'chatimage':
                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture'] ?? ''}',
              'name': _type == 'user'
                  ? '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'
                  : user['businessName'] ?? 'Unknown',
              'lastMessage': chatDoc['lastMessage'] ?? '',
              'newMessages': chatDoc['unreadMessages'][_loggedInUserId] ?? 0,
              'time': chatDoc['lastMessageTime'] ?? Timestamp.now()
            };
          }
        }
        return null;
      }).toList());

      // Remove nulls and sort by timestamp
      var chats = filteredChats
          .where((chat) => chat != null)
          .cast<Map<String, dynamic>>()
          .toList();
      chats.sort((a, b) {
        final aTime = a['time'] as Timestamp? ?? Timestamp.now();
        final bTime = b['time'] as Timestamp? ?? Timestamp.now();
        return bTime.compareTo(aTime);
      });
      if (_type == 'user') {
        final groupsSnapshot = await _groupsCollection.get();
        var filteredGroups =
            await Future.wait(groupsSnapshot.docs.where((groupDoc) {
          final participants = groupDoc['participants'] as List<dynamic>;
          return participants.contains(_loggedInUserId);
        }).map((groupDoc) async {
          // Get last message for the group
          final messagesSnapshot = await _groupsCollection
              .doc(groupDoc.id)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          Timestamp lastMessageTime = Timestamp.now();
          String lastMessage = 'No messages yet';

          if (messagesSnapshot.docs.isNotEmpty) {
            lastMessageTime =
                messagesSnapshot.docs.first['timestamp'] as Timestamp;
            lastMessage = messagesSnapshot.docs.first['message'] ?? lastMessage;
          }

          return {
            'groupId': groupDoc.id,
            'groupImageUrl': groupDoc['groupImageUrl'],
            'name': groupDoc['groupName'],
            'participants': groupDoc['participants'],
            'lastMessage': lastMessage,
            'time': lastMessageTime,
          };
        }).toList());

        // Sort groups by last message time
        filteredGroups.sort((a, b) {
          final aTime = a['time'] as Timestamp? ?? Timestamp.now();
          final bTime = b['time'] as Timestamp? ?? Timestamp.now();
          return bTime.compareTo(aTime);
        });
        if (mounted) {
          setState(() {
            _userChats = chats;
            _groups = filteredGroups;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _userChats = chats;
          });
        }
      }

      // Save sorted chats to cache
      prefs.setString(
          'cached_chats', json.encode(convertChatsForJson(_userChats)));
      if (_type == 'user') {
        prefs.setString(
            'cached_groups', json.encode(convertChatsForJson(_groups)));
      }
    } catch (e) {
      MyApi.postRequest(
        endpoint: 'error/application',
        body: {'error': 'Error fetching chats or groups: $e'},
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Widget> _buildCombinedChatList() {
    if (_type != 'user') return _buildChatsAndGroupsList();

    // Combine all conversations
    List<Map<String, dynamic>> allConversations = [];

    // Add individual chats
    for (var chat in _userChats) {
      allConversations.add({
        ...chat,
        'isGroup': false,
        'time': chat['time'] ?? Timestamp.now(), // Ensure time exists
      });
    }

    // Add group chats
    for (var group in _groups) {
      allConversations.add({
        ...group,
        'isGroup': true,
        'time': group['time'] ?? Timestamp.now(), // Ensure time exists
      });
    }

    // Sort by timestamp (most recent first)
    allConversations.sort((a, b) {
      final aTime = a['time'] as Timestamp;
      final bTime = b['time'] as Timestamp;
      return bTime.compareTo(aTime);
    });

    return allConversations.map((convo) {
      // Handle image URL
      final imageUrl = convo['isGroup']
          ? '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${convo['groupImageUrl'] ?? ''}'
          : convo['chatimage'] ?? '';

      // Handle time display
      final timeText = convo['time'] != null
          ? _formatTimestamp(convo['time'] as Timestamp)
          : '';

      return MessageChatButton(
        image: imageUrl,
        onpressed: () {
          if (convo['isGroup']) {
            Navigator.pushNamed(context, '/GroupChatBox', arguments: {
              'groupId': convo['groupId'],
              'participants': convo['participants'],
            });
          } else {
            _navigateToChatbox(convo['userId']);
          }
        },
        name: convo['name'] ?? 'Unknown',
        message: convo['lastMessage'] ?? '',
        newMessage: convo['isGroup'] ? 0 : (convo['newMessages'] ?? 0),
        time: timeText,
      );
    }).toList();
  }

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchedUsers = [];
        _searchedGroups = [];
      });
    } else {
      setState(() {
        _isSearching = true;
        _searchedUsers = _userChats
            .where((chat) =>
                chat['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
        if (_type == 'user') {
          _searchedGroups = _groups
              .where((chat) =>
                  chat['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    }
  }

  void _navigateToChatbox(String userId) {
    Navigator.pushNamed(context, '/ChatBox', arguments: {'userId': userId});
  }

  void _navigateToCreateGroup() {
    Navigator.pushNamed(context, '/CreateGroup',
        arguments: {'chats': _userChats});
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat format = DateFormat('h:mm a');
    return format.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final double max = Screen.max(context);

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Header(
                heading: "Chats",
                para: _type == 'user'
                    ? "View your chats and groups below."
                    : "View Your Customer Chats Below.",
              ),
              SizedBox(height: Screen.height(context) * 0.02),
              _buildSearchBar(max),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView(
                        children: _isSearching
                            ? _buildSearchedUsersandGroupsList()
                            : _buildCombinedChatList(),
                      ),
                    ),
            ],
          ),
          _type == 'user' ? _buildCreateGroupButton(max) : Container(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SearchBox(
          focusNode: searchFocus,
          onclick: () {
            searchFocus.requestFocus();
          },
          onChanged: _searchUsers,
          hint: 'Search Users',
          controller: _searchController,
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
        ),
      ],
    );
  }

  List<Widget> _buildSearchedUsersandGroupsList() {
    return [
      ..._searchedUsers.map((user) => MessageChatButton(
            image: user['chatimage'],
            onpressed: () => _navigateToChatbox(user['userId']),
            name: user['name'],
            message: 'Start a conversation',
            newMessage: 0,
            time: '',
          )),
      if (_type == 'user')
        ..._searchedGroups.map((user) => MessageChatButton(
              image: user['groupImageUrl'],
              onpressed: () => _navigateToChatbox(user['groupId']),
              name: user['name'],
              message: 'Group Chat',
              newMessage: 0,
              time: '',
            ))
    ];
  }

  List<Widget> _buildChatsAndGroupsList() {
    return [
      ..._userChats.map((chat) => MessageChatButton(
            image: chat['chatimage'],
            onpressed: () => _navigateToChatbox(chat['userId']),
            name: chat['name'],
            message: chat['lastMessage'],
            newMessage: chat['newMessages'],
            time: _formatTimestamp(chat['time']),
          )),
      if (_type == 'user')
        ..._groups.map((group) => MessageChatButton(
              image:
                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${group['groupImageUrl']}',
              onpressed: () {
                Navigator.pushNamed(context, '/GroupChatBox', arguments: {
                  'groupId': group['groupId'],
                  'participants': group['participants'],
                });
              },
              name: group['name'],
              message: 'Group Chat',
              newMessage: 0,
              time: '',
            )),
    ];
  }

  Widget _buildCreateGroupButton(double max) {
    return Positioned(
      bottom: Screen.height(context) * 0.05,
      right: Screen.height(context) * 0.03,
      child: InkWell(
        onTap: _navigateToCreateGroup,
        child: Container(
          padding: EdgeInsets.all(Screen.width(context) * 0.05),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyColors.dark.withAlpha(51),
                blurRadius: 10,
                offset: const Offset(0, 5),
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
              const Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(width: Screen.width(context) * 0.01),
              Text(
                'Create Group',
                style: GoogleFonts.roboto(
                  color: MyColors.white,
                  fontSize: max * 0.015,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
