import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Screens/chat/Groups/edit_group_screen.dart';
import 'package:taqreeb/Screens/chat/Groups/member_info_group.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  String? _currentUserId;
  String _groupId = "";
  String? _groupName;
  String? _groupImage;
  bool _isLoading = true;
  String? _adminId;
  bool _isAdmin = false;
  bool _isChanged = false;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isChanged) return;
    _isChanged = true;
    _initializeGroupData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 100 && !_showScrollToBottom) {
      setState(() => _showScrollToBottom = true);
    } else if (_scrollController.offset <= 100 && _showScrollToBottom) {
      setState(() => _showScrollToBottom = false);
    }
  }

  Future<void> _initializeGroupData() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['groupId'] == null) {
      _handleError('Missing group ID in route arguments');
      return;
    }

    setState(() {
      _groupId = args['groupId'];
      _isLoading = true;
    });

    await _fetchCurrentUserId();
    await _fetchGroupData();
  }

  Future<void> _fetchCurrentUserId() async {
    _currentUserId = await MyStorage.getToken(MyTokens.userId);
    if (_currentUserId == null) {
      _handleError('Failed to get current user ID');
    }
  }

  Future<void> _fetchGroupData() async {
    try {
      DocumentSnapshot groupDoc =
          await _firestore.collection('groups').doc(_groupId).get();

      if (!mounted) return;

      setState(() {
        _groupName = groupDoc['groupName'];
        _groupImage = groupDoc['groupImageUrl'];
        _adminId = groupDoc['adminId'];
        _isAdmin = _adminId == _currentUserId;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error fetching group data: $e');
    }
  }

  void _navigateToEditGroup() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditGroupScreen(
          groupId: _groupId,
          currentUserId: _currentUserId!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    ).then((updated) {
      if (updated == true) {
        _fetchGroupData(); // Refresh group data if updated
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    try {
      // First update last message in group document for faster retrieval
      await _firestore.collection('groups').doc(_groupId).update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // Then add the message
      await _firestore
          .collection('groups')
          .doc(_groupId)
          .collection('messages')
          .add({
        'senderId': _currentUserId,
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      _handleError('Failed to send message: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile == null || !mounted) return;

      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(
                'Uploading image...',
                style: GoogleFonts.roboto(color: MyColors.white),
              ),
            ],
          ),
          backgroundColor: MyColors.darkLighter,
        ),
      );

      final response = await MyApi.postMultipartRequest(
        endpoint: 'saveGroupImage/',
        body: {'userid': _currentUserId ?? ""},
        files: {'image': File(pickedFile.path)},
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        // Update last message in group document
        await _firestore.collection('groups').doc(_groupId).update({
          'lastMessage': '[Image]',
          'lastMessageTime': FieldValue.serverTimestamp(),
        });

        // Add the image message
        await _firestore
            .collection('groups')
            .doc(_groupId)
            .collection('messages')
            .add({
          'senderId': _currentUserId,
          'message': response['path'],
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'image',
        });

        _scrollToBottom();
      } else {
        _handleError('Failed to upload image: ${response['message']}');
      }
    } catch (e) {
      _handleError('Failed to send image: $e');
    } finally {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    }
  }

  void _handleError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('h:mm a').format(timestamp.toDate());
  }

  Widget _buildMessageTile(DocumentSnapshot doc) {
    final isSentByMe = doc['senderId'] == _currentUserId;
    final messageType = doc['type'];
    final messageText = doc['message'];
    final timestamp = doc['timestamp'] as Timestamp?;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(doc['senderId']).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final senderData = snapshot.data!;
        final senderName = senderData['firstName'];
        final senderImage =
            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${senderData['profilePicture']}';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSentByMe)
                InkWell(
                  onTap: () {
                    // Show user profile when avatar is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MembersScreen(
                          groupId: _groupId,
                          // initialMemberId: doc['senderId'],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(senderImage),
                    radius: 20,
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: isSentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (!isSentByMe)
                      Text(
                        senderName,
                        style: GoogleFonts.roboto(
                          color: MyColors.yellow,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (messageType == 'text')
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              isSentByMe ? MyColors.red : MyColors.darkLighter,
                          borderRadius: BorderRadius.only(
                            topLeft: isSentByMe
                                ? const Radius.circular(16)
                                : Radius.zero,
                            topRight: isSentByMe
                                ? Radius.zero
                                : const Radius.circular(16),
                            bottomLeft: const Radius.circular(16),
                            bottomRight: const Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          messageText,
                          style: GoogleFonts.roboto(color: MyColors.white),
                        ),
                      ),
                    if (messageType == 'image')
                      GestureDetector(
                        onTap: () {
                          // Show image in full screen
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(20),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$messageText',
                                    fit: BoxFit.contain,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: MyColors.red.withAlpha(100),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$messageText',
                              height: 200,
                              width: 250,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 200,
                                width: 250,
                                color: MyColors.darkLighter,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        MyColors.red),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 200,
                                width: 250,
                                color: MyColors.darkLighter,
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.exclamation,
                                    color: MyColors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (timestamp != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _formatTimestamp(timestamp),
                          style: GoogleFonts.roboto(
                            color: MyColors.whiteDarker,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: MyColors.ligthDark,
      child: Row(
        children: [
          IconButton(
            icon: Icon(FontAwesomeIcons.image, color: MyColors.yellow),
            onPressed: _sendImage,
            tooltip: 'Send Image',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.darkLighter,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.roboto(color: MyColors.white),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle:
                            GoogleFonts.roboto(color: MyColors.whiteDarker),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.red,
            ),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.paperPlane, color: MyColors.white),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  _sendMessage(_messageController.text);
                }
              },
              tooltip: 'Send Message',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: MyColors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembersScreen(groupId: _groupId),
                ),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: MyColors.white,
              child: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  _groupImage != null
                      ? '${MyApi.baseUrl}${_groupImage!}'
                      : 'https://via.placeholder.com/150',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _groupName ?? 'Group',
                  style: GoogleFonts.roboto(
                    color: MyColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_isAdmin)
                  Text(
                    'Admin',
                    style: GoogleFonts.roboto(
                      color: MyColors.white.withAlpha(200),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.users,
              color: MyColors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembersScreen(groupId: _groupId),
                ),
              );
            },
            tooltip: 'Group Members',
          ),
          if (_isAdmin)
            IconButton(
              icon: Icon(
                FontAwesomeIcons.gear,
                color: MyColors.white,
                size: 20,
              ),
              onPressed: _navigateToEditGroup,
              tooltip: 'Group Settings',
            ),
        ],
      ),
    );
  }

  Widget _buildMessageStream() {
    return Expanded(
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('groups')
                .doc(_groupId)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.red)),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return _buildMessageTile(snapshot.data!.docs[index]);
                },
              );
            },
          ),
          if (_showScrollToBottom)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: MyColors.red,
                child: Icon(
                  Icons.arrow_downward,
                  color: MyColors.white,
                ),
                onPressed: _scrollToBottom,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: MyColors.dark,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(MyColors.red),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: SafeArea(
        child: Column(
          children: [
            const Header(),
            _buildGroupHeader(),
            _buildMessageStream(),
            _buildChatInput(),
          ],
        ),
      ),
    );
  }
}
