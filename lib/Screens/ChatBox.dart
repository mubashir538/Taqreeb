import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'dart:io';
import 'dart:convert';
import 'package:taqreeb/Components/Recieve%20Message.dart';
import 'package:taqreeb/Components/Send%20Message.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

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
  String chatUserId = "";
  String? chatUserName;
  String? chatName;
  String? chatUserImage;
  bool isLoading = true;
  bool isMessageSent = true;
  bool isChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (!isChanged) {
      setState(() {
        chatUserId = args['userId'];
      });
      fetchdata();
    }
  }

  void fetchdata() async {
    _currentUserId = await MyStorage.getToken(MyTokens.userId);
    await _fetchChatUserDetails();
    isChanged = true;
    isLoading = false;
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Future<void> _fetchChatUserDetails() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(chatUserId).get();

      setState(() {
        chatName =
            '${_capitalize(userDoc['firstName'])} ${_capitalize(userDoc['lastName'])}';
        chatUserName = userDoc['username'] ?? 'Unknown User';
        chatUserImage =
            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${userDoc['profilePicture']}';
      });
    } catch (e) {
      print("Error fetching chat user details: $e");
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    var messageData = {
      'senderId': _currentUserId,
      'receiverId': chatUserId,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    };

    await _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .add(messageData);

    await _firestore.collection('chats').doc(_getChatId()).set({
      'chatId': _getChatId(),
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'newMessage': FieldValue.increment(1),
      'unreadMessages': {
        _currentUserId: FieldValue.increment(0),
        chatUserId: FieldValue.increment(1),
      },
    }, SetOptions(merge: true));

    _messageController.clear();
    setState(() {
      isMessageSent = true;
    });
  }

  Future<void> _sendImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    try {
      String apiUrl = "${MyApi.baseUrl}saveChatImage/";
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      request.headers.addAll({
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);

        String imageUrl = jsonResponse['path'];

        await _firestore
            .collection('chats')
            .doc(_getChatId())
            .collection('messages')
            .add({
          'senderId': _currentUserId,
          'receiverId': chatUserId,
          'message': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'image',
        });

        await _firestore.collection('chats').doc(_getChatId()).set({
          'chatId': _getChatId(),
          'lastMessage': 'Image sent',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'unreadMessages': {
            _currentUserId: FieldValue.increment(0),
            chatUserId: FieldValue.increment(1),
          },
        }, SetOptions(merge: true));

      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  String _getChatId() {
    return _currentUserId!.compareTo(chatUserId) > 0
        ? '$_currentUserId-${chatUserId}'
        : '${chatUserId}-$_currentUserId';
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    var format = DateFormat('h:mm a');
    return format.format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    var today = DateTime.now();
    var yesterday = today.subtract(Duration(days: 1));
    if (dateTime.day == today.day &&
        dateTime.month == today.month &&
        dateTime.year == today.year) {
      return 'Today';
    } else if (dateTime.day == yesterday.day &&
        dateTime.month == yesterday.month &&
        dateTime.year == yesterday.year) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  Widget _buildMessageTile(DocumentSnapshot doc, DateTime messageDate) {
    bool isSentByMe = doc['senderId'] == _currentUserId;
    String messageType = doc['type'];

    DateTime timestamp =
        doc['timestamp'] != null ? doc['timestamp'].toDate() : DateTime.now();

    if (messageType == 'text') {
      return isSentByMe
          ? SendMessage(
              text: doc['message'],
              time: _formatTimestamp(Timestamp.fromDate(timestamp)),
            )
          : RecieveMessage(
              text: doc['message'],
              time: _formatTimestamp(Timestamp.fromDate(timestamp)),
            );
    } else if (messageType == 'image') {
      String image =
          '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${doc['message']}';
      return isSentByMe
          ? SendMessage(
              text: '',
              time: _formatTimestamp(Timestamp.fromDate(timestamp)),
              imageUrl: image,
            )
          : RecieveMessage(
              text: '',
              time: _formatTimestamp(Timestamp.fromDate(timestamp)),
              imageUrl: image,
            );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                ))
              : Column(
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: MaximumThing * 0.03),
                      height: screenHeight * 0.16,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: MyColors.red,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.6,
                                child: Text(
                                  softWrap: true,
                                  maxLines: 2,
                                  chatName.toString(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: MaximumThing * 0.025,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(chatUserName.toString(),
                                      style: GoogleFonts.montserrat(
                                        fontSize: MaximumThing * 0.015,
                                        fontWeight: FontWeight.w400,
                                      ))
                                ],
                              )
                            ],
                          ),
                          CircleAvatar(
                            radius: MaximumThing * 0.05,
                            backgroundImage: NetworkImage(chatUserImage!),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: isMessageSent
                          ? StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('chats')
                                  .doc(_getChatId())
                                  .collection('messages')
                                  .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                var messages = snapshot.data!.docs;
                                List<Widget> messageWidgets = [];
                                DateTime? lastMessageDate;

                                for (var message in messages) {
                                  DateTime messageDate =
                                      message['timestamp'] != null
                                          ? message['timestamp'].toDate()
                                          : DateTime.now();

                                  if (lastMessageDate == null ||
                                      _formatDate(lastMessageDate) !=
                                          _formatDate(messageDate)) {
                                    messageWidgets.add(Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: MaximumThing * 0.012),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _formatDate(messageDate),
                                              style: GoogleFonts.montserrat(
                                                fontSize: MaximumThing * 0.01,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                                  }
                                  messageWidgets.add(
                                      _buildMessageTile(message, messageDate));
                                  lastMessageDate = messageDate;
                                }

                                return ListView(
                                  reverse: true,
                                  children: messageWidgets,
                                );
                              },
                            )
                          : SizedBox.shrink(),
                    ),
                    Row(
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
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.send, color: MyColors.white),
                            onPressed: () async {
                              await _sendMessage(_messageController.text);
                            }),
                      ],
                    ),
                  ],
                ),
          Positioned(top: 0, child: Header())
        ],
      ),
    );
  }
}
