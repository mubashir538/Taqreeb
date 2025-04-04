import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/Messages/c_message_receive.dart';
import 'package:taqreeb/Components/Messages/c_message_send.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _currentUserId;
  String _chatUserId = "";
  String? _chatUserName;
  String? _chatName;
  String? _chatUserImage;
  bool _isLoading = true;
  bool _isMessageSent = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeChatData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initializeChatData() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['userId'] == null) {
      _handleError('Missing chat user ID in route arguments');
      return;
    }

    setState(() {
      _chatUserId = args['userId'];
      _isLoading = true;
    });

    await _fetchCurrentUserId();
    await _fetchChatUserDetails();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCurrentUserId() async {
    _currentUserId = await MyStorage.getToken(MyTokens.userId);
    if (_currentUserId == null) {
      _handleError('Failed to get current user ID');
    }
  }

  Future<void> _fetchChatUserDetails() async {
    try {
      final userDoc =
          await _firestore.collection('users').doc(_chatUserId).get();

      if (!mounted) return;

      setState(() {
        _chatName =
            _capitalizeName('${userDoc['firstName']} ${userDoc['lastName']}');
        _chatUserName = userDoc['username'] ?? 'Unknown User';
        _chatUserImage =
            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${userDoc['profilePicture']}';
      });
    } catch (e) {
      _handleError('Error fetching chat user details: $e');
    }
  }

  String _capitalizeName(String name) {
    if (name.isEmpty) return name;
    return name
        .split(' ')
        .map((part) => part.isNotEmpty
            ? part[0].toUpperCase() + part.substring(1).toLowerCase()
            : '')
        .join(' ');
  }

  Future<void> _sendMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    setState(() => _isMessageSent = false);

    try {
      final chatId = _getChatId();
      final messageData = {
        'senderId': _currentUserId,
        'receiverId': _chatUserId,
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'text',
      };

      // Add message to chat collection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      // Update chat metadata
      await _firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadMessages': {
          _currentUserId: FieldValue.increment(0),
          _chatUserId: FieldValue.increment(1),
        },
      }, SetOptions(merge: true));

      // Send notification
      await MyApi.postRequest(
        endpoint: 'notification/sendNotification',
        body: {
          'recv': _chatUserId,
          'send': _currentUserId,
          'message': text,
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
        },
      );

      _messageController.clear();
    } catch (e) {
      _handleError('Failed to send message: $e');
    } finally {
      if (mounted) {
        setState(() => _isMessageSent = true);
      }
    }
  }

  Future<void> _sendImage() async {
    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final response = await MyApi.postMultipartRequest(
        endpoint: 'saveChatImage/',
        body: {'userid': _currentUserId ?? ""},
        files: {'image': File(pickedFile.path)},
      );

      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to upload image');
      }

      final chatId = _getChatId();
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': _currentUserId,
        'receiverId': _chatUserId,
        'message': response['path'],
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'image',
      });

      await _firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'lastMessage': 'Image sent',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadMessages': {
          _currentUserId: FieldValue.increment(0),
          _chatUserId: FieldValue.increment(1),
        },
      }, SetOptions(merge: true));
    } catch (e) {
      _handleError('Failed to send image: $e');
    }
  }

  String _getChatId() {
    if (_currentUserId == null) return '';
    return _currentUserId!.compareTo(_chatUserId) > 0
        ? '$_currentUserId-$_chatUserId'
        : '$_chatUserId-$_currentUserId';
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('h:mm a').format(timestamp.toDate());
  }

  String _formatDate(DateTime dateTime) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return 'Today';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  Widget _buildMessageTile(DocumentSnapshot doc) {
    final isSentByMe = doc['senderId'] == _currentUserId;
    final messageType = doc['type'];
    final message = doc['message'];
    final timestamp = doc['timestamp'] as Timestamp?;
    final time = timestamp != null ? _formatTimestamp(timestamp) : '';

    if (messageType == 'text') {
      return isSentByMe
          ? SendMessage(text: message, time: time)
          : RecieveMessage(text: message, time: time);
    } else if (messageType == 'image') {
      final imageUrl =
          '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$message';
      return isSentByMe
          ? SendMessage(text: '', time: time, imageUrl: imageUrl)
          : RecieveMessage(text: '', time: time, imageUrl: imageUrl);
    }
    return const SizedBox.shrink();
  }

  Widget _buildChatHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.03),
      height: Screen.height(context) * 0.16,
      width: Screen.width(context),
      decoration: BoxDecoration(color: MyColors.red),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Screen.width(context) * 0.6,
                child: Text(
                  _chatName ?? '',
                  softWrap: true,
                  maxLines: 2,
                  style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _chatUserName ?? '',
                style: GoogleFonts.montserrat(
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: Screen.max(context) * 0.05,
            backgroundImage: NetworkImage(_chatUserImage ?? ''),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Row(
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
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chats')
          .doc(_getChatId())
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;
        final messageWidgets = <Widget>[];
        DateTime? lastMessageDate;

        for (final message in messages) {
          final messageDate = message['timestamp']?.toDate() ?? DateTime.now();

          // Add date header if needed
          if (lastMessageDate == null ||
              _formatDate(lastMessageDate) != _formatDate(messageDate)) {
            messageWidgets.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: Screen.max(context) * 0.012,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDate(messageDate),
                        style: GoogleFonts.montserrat(
                          fontSize: Screen.max(context) * 0.01,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          messageWidgets.add(_buildMessageTile(message));
          lastMessageDate = messageDate;
        }

        return ListView(
          reverse: true,
          children: messageWidgets,
        );
      },
    );
  }

  void _handleError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
              ),
            )
          else
            Column(
              children: [
                SizedBox(height: Screen.height(context) * 0.1),
                _buildChatHeader(),
                Expanded(
                  child: _isMessageSent
                      ? _buildMessagesList()
                      : const SizedBox.shrink(),
                ),
                _buildChatInput(),
              ],
            ),
          const Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }
}
