// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late CollectionReference _usersCollection;
  late CollectionReference _groupsCollection;
  late CollectionReference _chatsCollection;
  FocusNode searchFocus = FocusNode();

  List<Map<String, dynamic>> _userChats = [];
  List<Map<String, dynamic>> _groups = [];
  List<Map<String, dynamic>> _searchedUsers = [];
  List<Map<String, dynamic>> _searchedGroups = [];
  bool _isLoading = true;
  String _loggedInUserId = "";
  bool _isSearching = false;
  String _type = 'businessowner';

  // Stream subscriptions
  StreamSubscription? _chatsSubscription;
  StreamSubscription? _groupsSubscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFocus.dispose();
    _chatsSubscription?.cancel();
    _groupsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    _loggedInUserId = await MyStorage.getToken(MyTokens.userId) ?? "";
    _type = await MyTokens.getBusinessType();

    // Initialize collections based on user type
    if (_type == 'businessowner') {
      _chatsCollection = FirebaseFirestore.instance.collection('BusinessChats');
      _usersCollection = FirebaseFirestore.instance.collection('businessUsers');
    } else if (_type == 'freelancer') {
      _chatsCollection =
          FirebaseFirestore.instance.collection('FreelancerChats');
      _usersCollection =
          FirebaseFirestore.instance.collection('freelanceUsers');
    } else {
      _chatsCollection = FirebaseFirestore.instance.collection('chats');
      _usersCollection = FirebaseFirestore.instance.collection('users');
    }

    _groupsCollection = FirebaseFirestore.instance.collection('groups');

    // Load cached data first for quick display
    await _loadCachedData();

    // Set up real-time listeners
    _setupChatListeners();

    if (_type == 'user') {
      _setupGroupListeners();
    }
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedChats = prefs.getString('cached_chats');
    final cachedGroups =
        _type == 'user' ? prefs.getString('cached_groups') : null;

    if (cachedChats != null) {
      setState(() {
        _userChats = _parseCachedChats(cachedChats);
      });
    }

    if (cachedGroups != null && _type == 'user') {
      setState(() {
        _groups = _parseCachedChats(cachedGroups);
      });
    }
  }

  List<Map<String, dynamic>> _parseCachedChats(String jsonString) {
    try {
      final decoded = json.decode(jsonString) as List;
      return decoded.map((chat) {
        final map = Map<String, dynamic>.from(chat);
        if (map['time'] is String) {
          map['time'] = Timestamp.fromDate(DateTime.parse(map['time']));
        }
        return map;
      }).toList();
    } catch (e) {
      MyApi.postRequest(
        endpoint: 'error/application',
        body: {'error': 'Error parsing cached chats: $e'},
      );
      return [];
    }
  }

  void _setupChatListeners() {
    _chatsSubscription = _chatsCollection.snapshots().listen((snapshot) async {
      final updatedChats = await _processChats(snapshot.docs);

      // Sort by last message time (newest first)
      updatedChats.sort(
          (a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));

      // Update cache
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'cached_chats', json.encode(_prepareForCache(updatedChats)));

      if (mounted) {
        setState(() {
          _userChats = updatedChats;
          _isLoading = false;
        });
      }
    }, onError: (error) {
      MyApi.postRequest(
        endpoint: 'error/application',
        body: {'error': 'Chats stream error: $error'},
      );
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  void _setupGroupListeners() {
    if (_type != 'user') return;

    _groupsSubscription = _groupsCollection
        .where('participants', arrayContains: _loggedInUserId)
        .snapshots()
        .listen((snapshot) async {
      final updatedGroups = await _processGroups(snapshot.docs);

      // Sort by last message time (newest first)
      updatedGroups.sort(
          (a, b) => (b['time'] as Timestamp).compareTo(a['time'] as Timestamp));

      // Update cache
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'cached_groups', json.encode(_prepareForCache(updatedGroups)));

      if (mounted) {
        setState(() {
          _groups = updatedGroups;
        });
      }
    }, onError: (error) {
      MyApi.postRequest(
        endpoint: 'error/application',
        body: {'error': 'Groups stream error: $error'},
      );
    });
  }

  Future<List<Map<String, dynamic>>> _processChats(
      List<QueryDocumentSnapshot> chatDocs) async {
    final List<Map<String, dynamic>> processedChats = [];

    for (final chatDoc in chatDocs) {
      try {
        // Get last message
        final lastMessage = await _chatsCollection
            .doc(chatDoc.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (lastMessage.docs.isEmpty) continue;

        final lastMsgData = lastMessage.docs.first.data();
        final List<String> ids = chatDoc.id.split('-');

        if (!ids.contains(_loggedInUserId)) continue;

        final otherUserId = lastMsgData['senderId'] == _loggedInUserId
            ? lastMsgData['receiverId']
            : lastMsgData['senderId'];

        final userDoc = await _usersCollection.doc(otherUserId).get();
        if (!userDoc.exists) continue;

        processedChats.add({
          'userId': otherUserId,
          'chatId': chatDoc.id,
          'chatimage':
              '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${userDoc['profilePicture'] ?? ''}',
          'name': _type == 'user'
              ? '${userDoc['firstName'] ?? ''} ${userDoc['lastName'] ?? ''}'
              : userDoc['businessName'] ?? 'Unknown',
          'lastMessage': chatDoc['lastMessage'] ?? '',
          'newMessages': chatDoc['unreadMessages']?[_loggedInUserId] ?? 0,
          'time': chatDoc['lastMessageTime'] ?? Timestamp.now(),
          'isGroup': false,
        });
      } catch (e) {
        MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Error processing chat ${chatDoc.id}: $e'},
        );
      }
    }

    return processedChats;
  }

  Future<List<Map<String, dynamic>>> _processGroups(
      List<QueryDocumentSnapshot> groupDocs) async {
    final List<Map<String, dynamic>> processedGroups = [];

    for (final groupDoc in groupDocs) {
      try {
        // Get last message
        final lastMessage = await _groupsCollection
            .doc(groupDoc.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        Timestamp lastMessageTime = Timestamp.now();
        String lastMessageText = 'No messages yet';

        if (lastMessage.docs.isNotEmpty) {
          lastMessageTime = lastMessage.docs.first['timestamp'] as Timestamp;
          lastMessageText =
              lastMessage.docs.first['message'] ?? lastMessageText;
        }

        processedGroups.add({
          'groupId': groupDoc.id,
          'chatimage':
              '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${groupDoc['groupImageUrl'] ?? ''}',
          'name': groupDoc['groupName'],
          'participants': groupDoc['participants'],
          'lastMessage': lastMessageText,
          'time': lastMessageTime,
          'newMessages': 0, // You can implement group unread counts if needed
          'isGroup': true,
        });
      } catch (e) {
        MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Error processing group ${groupDoc.id}: $e'},
        );
      }
    }

    return processedGroups;
  }

  List<Map<String, dynamic>> _prepareForCache(
      List<Map<String, dynamic>> chats) {
    return chats.map((chat) {
      return {
        ...chat,
        'time': (chat['time'] as Timestamp).toDate().toIso8601String(),
      };
    }).toList();
  }

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchedUsers = [];
        _searchedGroups = [];
      });
      return;
    }

    final lowerQuery = query.toLowerCase();

    setState(() {
      _isSearching = true;
      _searchedUsers = _userChats
          .where((chat) => chat['name'].toLowerCase().contains(lowerQuery))
          .toList();

      if (_type == 'user') {
        _searchedGroups = _groups
            .where((group) => group['name'].toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }

  void _navigateToChatbox(String userId) async {
    // Mark messages as read when opening chat
    final chat =
        _userChats.firstWhere((c) => c['userId'] == userId, orElse: () => {});
    if (chat.isNotEmpty && chat['newMessages'] > 0) {
      await _chatsCollection.doc(chat['chatId']).update({
        'unreadMessages.$_loggedInUserId': 0,
      });
    }

    Navigator.pushNamed(context, '/ChatBox', arguments: {'userId': userId});
  }

  void _navigateToCreateGroup() {
    Navigator.pushNamed(context, '/CreateGroup',
        arguments: {'chats': _userChats});
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final messageTime = timestamp.toDate();
    final diff = now.difference(messageTime);

    if (diff.inDays > 7) {
      return DateFormat('MM/dd/yy').format(messageTime); // Older than 1 week
    } else if (diff.inDays > 1) {
      return '${diff.inDays}d ago'; // 2-7 days ago
    } else if (diff.inDays == 1) {
      return 'Yesterday'; // Yesterday
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago'; // Hours ago
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago'; // Minutes ago
    } else {
      return 'Just now'; // Less than a minute
    }
  }

  List<Widget> _buildChatList() {
    // Combine all conversations into one list
    final List<Map<String, dynamic>> allConversations = [
      ..._userChats,
      if (_type == 'user') ..._groups,
    ];

    // Sort by timestamp (newest first)
    allConversations.sort((a, b) {
      final aTime = a['time'] as Timestamp;
      final bTime = b['time'] as Timestamp;
      return bTime.compareTo(aTime); // Descending order (newest first)
    });

    // If searching, filter the combined list
    final displayConversations = _isSearching
        ? allConversations.where((convo) => convo['name']
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        : allConversations;

    return displayConversations.map((convo) {
      return MessageChatButton(
        key: ValueKey(convo['isGroup']
            ? 'group_${convo['groupId']}'
            : 'chat_${convo['userId']}'),
        image: convo['chatimage'] ?? convo['groupImageUrl'],
        onpressed: () {
          if (convo['isGroup'] ?? false) {
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
        newMessage: convo['newMessages'] ?? 0,
        time: _formatTimestamp(convo['time'] as Timestamp),
      );
    }).toList();
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
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: _initialize,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: _buildChatList(),
                        ),
                      ),
                    ),
            ],
          ),
          if (_type == 'user') _buildCreateGroupButton(max),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double max) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: max * 0.03),
      child: Row(
        children: [
          Expanded(
            child: SearchBox(
              focusNode: searchFocus,
              onclick: () => searchFocus.requestFocus(),
              onChanged: _searchUsers,
              hint: 'Search ${_type == 'user' ? 'Users/Groups' : 'Users'}',
              controller: _searchController,
            ),
          ),
          if (_type == 'user')
            Padding(
              padding: EdgeInsets.only(left: max * 0.02),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/search_new_user');
                },
                child: Container(
                  padding: EdgeInsets.all(max * 0.015),
                  decoration: BoxDecoration(
                    color: MyColors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(FontAwesomeIcons.plus, color: MyColors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCreateGroupButton(double max) {
    return Positioned(
      bottom: Screen.height(context) * 0.05,
      right: Screen.height(context) * 0.03,
      child: InkWell(
        onTap: _navigateToCreateGroup,
        child: Container(
          padding: EdgeInsets.all(Screen.width(context) * 0.04),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyColors.dark.withAlpha(51),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
            borderRadius: BorderRadius.circular(max * 0.05),
            color: MyColors.red,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(FontAwesomeIcons.plus, color: Colors.white),
              SizedBox(width: Screen.width(context) * 0.02),
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
