import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/Messages/c_message_receive.dart';
import 'package:taqreeb/Components/Messages/c_message_send.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/encryption.dart';
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
  final EncryptionService _encryptionService = EncryptionService();
  final ScrollController _scrollController = ScrollController();

  String? _currentUserId;
  String _chatUserId = "";
  String? _chatUserName;
  String? _chatName;
  String? _chatUserImage;
  bool _isLoading = true;
  Map<String, dynamic> _listing = {};
  String _messageCollection = '';
  String _type = '';
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChatData();
    });
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

  Widget _buildListingPreview() {
    if (_listing.isEmpty) return const SizedBox.shrink();
    final colors = AppColors(context);

    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Listing Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                    '${_listing['pictures'][0]['picturePath'] ?? ''}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          // Listing Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listing['Listing']['name'] ?? '',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _listing['Listing']['description'] ?? '',
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: colors.white.withAlpha(179),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _listing['Listing']['type'] ??
                      '', // Replace with your actual domain
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: colors.yellow,
                  ),
                ),
              ],
            ),
          ),
          // Close button
          IconButton(
            icon: Icon(FontAwesomeIcons.xmark, size: 20, color: colors.white),
            onPressed: () {
              setState(() {
                _listing = {};
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeChatData() async {
    if (_isChanged) return;
    _isChanged = true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['userId'] == null) {
      _handleError('Missing chat user ID in route arguments');
      return;
    }

    setState(() {
      if (args.containsKey('type')) {
        _type = args['type'];
        _listing = args['listing'];
      }
      _messageCollection = _getMessageCollection();
      _chatUserId = args['userId'].toString();
      _isLoading = true;
    });

    await _fetchCurrentUserId();
    await _fetchChatUserDetails();
    _markMessagesAsRead();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _getMessageCollection() {
    if (_type.toLowerCase() == 'business') {
      return 'BusinessChats';
    } else if (_type.toLowerCase() == "freelancer") {
      return 'FreelancerChats';
    } else {
      return 'chats';
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
      String collectionName = _getUserCollection();
      final userDoc =
          await _firestore.collection(collectionName).doc(_chatUserId).get();

      if (!mounted) return;

      setState(() {
        _chatName = _type.isNotEmpty
            ? _capitalizeName(userDoc['businessName'])
            : _capitalizeName('${userDoc['firstName']} ${userDoc['lastName']}');
        _chatUserName = _type.isNotEmpty ? _type : userDoc['username'];
        _chatUserImage =
            '${userDoc[_type.isNotEmpty ? 'profile' : 'profilePicture']}';
      });
    } catch (e) {
      _handleError('Error fetching chat user details: $e');
    }
  }

  String _getUserCollection() {
    if (_type.toLowerCase() == 'business') {
      return 'businessUsers';
    } else if (_type.toLowerCase() == "freelancer") {
      return 'freelanceUsers';
    } else {
      return 'users';
    }
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final chatId = _getChatId();

      final docRef = _firestore.collection(_messageCollection).doc(chatId);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return;
      }
      await _firestore.collection(_messageCollection).doc(chatId).update({
        'unreadMessages.$_currentUserId': 0,
      });
    } catch (e) {
      _handleError('Error marking messages as read: $e');
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    try {
      final chatId = _getChatId();
      final encryptedMessage =   _encryptionService.encryptMessage(text);

      final messageData = {
        'senderId': _currentUserId,
        'receiverId': _chatUserId,
        'message': encryptedMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'mtype': 'text',
        'isEncrypted': true,
      };

      if (_listing.isNotEmpty) {
        messageData['listing'] = {
          'id': _listing['Listing']['id'],
          'name': _listing['Listing']['name'],
          'description': _listing['Listing']['description'],
          'picture': _listing['pictures'][0]['picturePath'],
          'type': _listing['Listing']['type']
        };
        messageData['mtype'] = 'listing';
      }

      // Optimistic UI update - add message immediately
      final newMessageRef = _firestore
          .collection(_messageCollection)
          .doc(chatId)
          .collection('messages')
          .doc();

      await _firestore.runTransaction((transaction) async {
        // Add the new message
        transaction.set(newMessageRef, messageData);

        // Update chat metadata
        transaction.set(
          _firestore.collection(_messageCollection).doc(chatId),
          {
            'chatId': chatId,
            'lastMessage': text,
            'lastMessageTime': FieldValue.serverTimestamp(),
            'unreadMessages': {
              _currentUserId: FieldValue.increment(0),
              _chatUserId: FieldValue.increment(1),
            },
          },
          SetOptions(merge: true),
        );
      });

      // Send push notification
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
      if (_listing.isNotEmpty) {
        setState(() => _listing = {});
      }

      // Scroll to bottom after sending
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      _handleError('Failed to send message: $e');
    }
  }

  Future<void> _sendImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (pickedFile == null) return;

      // // Show loading indicator
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Uploading image...')),
      // );

      final response = await MyApi.postMultipartRequest(
        endpoint: 'saveChatImage/',
        body: {'userid': _currentUserId ?? ""},
        files: {'image': pickedFile.path},
      );

      if (response['status'] != 'success') {
        throw Exception(response['message'] ?? 'Failed to upload image');
      }

      final encryptedPath = _encryptionService.encryptMessage(response['path']);
      final chatId = _getChatId();
      final newMessageRef = _firestore
          .collection(_messageCollection)
          .doc(chatId)
          .collection('messages')
          .doc();

      await _firestore.runTransaction((transaction) async {
        transaction.set(newMessageRef, {
          'senderId': _currentUserId,
          'receiverId': _chatUserId,
          'message': encryptedPath,
          'timestamp': FieldValue.serverTimestamp(),
          'mtype': 'image',
          'isEncrypted': true,
        });

        transaction.set(
          _firestore.collection(_messageCollection).doc(chatId),
          {
            'chatId': chatId,
            'lastMessage': 'Image sent',
            'lastMessageTime': FieldValue.serverTimestamp(),
            'unreadMessages': {
              _currentUserId: FieldValue.increment(0),
              _chatUserId: FieldValue.increment(1),
            },
          },
          SetOptions(merge: true),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send image: ${e.toString()}')),
        );
      }
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
    final messageType = doc['mtype'];
    var message = doc['message'];
    final isEncrypted = doc['isEncrypted'] ?? false;
    final timestamp = doc['timestamp'] as Timestamp?;
    final time = timestamp != null ? _formatTimestamp(timestamp) : '';

    if (isEncrypted && messageType == 'text') {
      try {
        message = _encryptionService.decryptMessage(message);
      } catch (e) {
        message = "Could not decrypt message";
      }
    }

    if (messageType == 'text') {
      return isSentByMe
          ? SendMessage(text: message, time: time)
          : RecieveMessage(text: message, time: time);
    } else if (messageType == 'image') {
      final imageUrl =
          '$message';
      
      return isSentByMe
          ? SendMessage(text: '', time: time, imageUrl: imageUrl)
          : RecieveMessage(text: '', time: time, imageUrl: imageUrl);
    } else if (messageType == 'listing') {
      final listing = doc['listing'] ?? {};
      return isSentByMe
          ? SendMessage(text: message, time: time, listing: listing)
          : RecieveMessage(text: message, time: time, listing: listing);
    }
    return const SizedBox.shrink();
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(_messageCollection)
          .doc(_getChatId())
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final colors = AppColors(context);

        final messages = snapshot.data!.docs;
        final messageWidgets = <Widget>[];
        DateTime? lastMessageDate;

        for (final message in messages) {
          messageWidgets.add(_buildMessageTile(message));
          final messageDate = message['timestamp']?.toDate() ?? DateTime.now();

          if (lastMessageDate == null ||
              _formatDate(lastMessageDate) != _formatDate(messageDate)) {
            messageWidgets.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.darkLighter,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDate(messageDate),
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          lastMessageDate = messageDate;
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemCount: messageWidgets.length,
          itemBuilder: (context, index) => messageWidgets[index],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Column(
        children: [
          const Header(),
          if (_isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colors.white),
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  // Chat header
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Screen.max(context) * 0.03),
                    decoration: BoxDecoration(color: colors.red),
                    child: Column(
                      children: [
                        SizedBox(height: Screen.max(context) * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: Screen.max(context) * 0.04,
                              backgroundImage:
                                  NetworkImage(_chatUserImage ?? ''),
                            ),
                            SizedBox(width: Screen.width(context) * 0.04),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Screen.width(context) * 0.6,
                                  child: Text(
                                    _chatName ?? '',
                                    style: GoogleFonts.roboto(
                                      fontSize: Screen.max(context) * 0.025,
                                      fontWeight: FontWeight.w600,
                                      color: colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  _chatUserName ?? '',
                                  style: GoogleFonts.roboto(
                                    fontSize: Screen.max(context) * 0.015,
                                    color: colors.whiteDarker,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Screen.max(context) * 0.02),
                      ],
                    ),
                  ),
                  // Messages list
                  Expanded(child: _buildMessagesList()),
                  // Chat input
                  _buildChatInput(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    final colors = AppColors(context);

    return Container(
      color: colors.lightDark,
      padding: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Column(
        children: [
          if (_listing.isNotEmpty) _buildListingPreview(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.image, color: colors.white),
                  onPressed: _sendImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: " Type a message",
                      fillColor: colors.darkLighter,
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
                  icon: Icon(FontAwesomeIcons.paperPlane, color: colors.white),
                  onPressed: () => _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(error)),
    // );
  }
}
