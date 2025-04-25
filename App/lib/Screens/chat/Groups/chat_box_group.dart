import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Screens/chat/Groups/member_info_group.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
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

  String? _currentUserId;
  String _groupId = "";
  String? _groupName;
  String? _groupImage;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeGroupData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error fetching group data: $e');
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    try {
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
    } catch (e) {
      _handleError('Failed to send message: $e');
    }
  }

  Future<void> _sendImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final response = await MyApi.postMultipartRequest(
        endpoint: 'saveGroupImage/',
        body: {'userid': _currentUserId ?? ""},
        files: {'image': File(pickedFile.path)},
      );

      if (response['status'] == 'success') {
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
      } else {
        _handleError('Failed to upload image: ${response['message']}');
      }
    } catch (e) {
      _handleError('Failed to send image: $e');
    }
  }

  void _handleError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );

    if (mounted) {
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
        if (!snapshot.hasData) return const SizedBox.shrink();

        final senderData = snapshot.data!;
        final senderName = senderData['firstName'];
        final senderImage =
            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${senderData['profilePicture']}';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSentByMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(senderImage),
                  radius: 20,
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: isSentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style: GoogleFonts.montserrat(
                        color: MyColors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (messageType == 'text')
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              isSentByMe ? MyColors.red : MyColors.DarkLighter,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messageText,
                          style: GoogleFonts.montserrat(color: MyColors.white),
                        ),
                      ),
                    if (messageType == 'image')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$messageText',
                          height: 150,
                          width: 200,
                          fit: BoxFit.cover,
                          imageBuilder: (context, image) {
                            return Container(
                              height: 150,
                              width: 200,
                              color: MyColors.DarkLighter,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          },
                          errorWidget: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: 200,
                              color: MyColors.DarkLighter,
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                    if (timestamp != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _formatTimestamp(timestamp),
                          style: GoogleFonts.montserrat(
                            color: MyColors.DarkLighter,
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image, color: MyColors.Yellow),
            onPressed: _sendImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                fillColor: MyColors.DarkLighter,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: MyColors.white),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: MyColors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${_groupImage!}',
                ),
                radius: 30,
              ),
              const SizedBox(width: 15),
              Text(
                _groupName!,
                style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.people, color: MyColors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MembersScreen(groupId: _groupId),
                ),
              );
            },
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
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Column(
        children: [
          const Header(),
          _buildGroupHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('groups')
                  .doc(_groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return _buildMessageTile(snapshot.data!.docs[index]);
                  },
                );
              },
            ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }
}
