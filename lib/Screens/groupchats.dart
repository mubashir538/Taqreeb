import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/header.dart';
import 'dart:io';
import 'dart:convert';
import 'package:taqreeb/theme/color.dart';

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
  String groupId = "";
  String? groupName;
  String? groupImage;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    groupId = args['groupId'];
    fetchGroupData();
  }

  void fetchGroupData() async {
    _currentUserId = await MyStorage.getToken(MyTokens.userId);

    try {
      DocumentSnapshot groupDoc =
          await _firestore.collection('groups').doc(groupId).get();

      setState(() {
        groupName = groupDoc['groupName'];
        groupImage = groupDoc['groupImageUrl'];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching group data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add({
      'senderId': _currentUserId,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    _messageController.clear();
  }

  Future<void> _sendImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    try {
      String apiUrl = "${MyApi.baseUrl}saveChatImage/";
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

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
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .add({
          'senderId': _currentUserId,
          'message': imageUrl,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'image',
        });

        print('Image uploaded and message sent: $imageUrl');
      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('h:mm a').format(dateTime);
  }

  Widget _buildMessageTile(DocumentSnapshot doc) {
    String senderId = doc['senderId'];
    String messageType = doc['type'];

    bool isSentByMe = senderId == _currentUserId;
    String messageText = doc['message'];
    Timestamp timestamp = doc['timestamp'];

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(senderId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        var senderData = snapshot.data!;
        String senderName = senderData['name'];
        String senderImage = senderData['profilePicture'];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSentByMe)
              CircleAvatar(
                backgroundImage: NetworkImage(senderImage),
                radius: 20,
              ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: isSentByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: GoogleFonts.montserrat(
                        color: MyColors.Yellow,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  if (messageType == 'text')
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            isSentByMe ? MyColors.Yellow : MyColors.DarkLighter,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        messageText,
                        style: GoogleFonts.montserrat(color: MyColors.white),
                      ),
                    ),
                  if (messageType == 'image')
                    Image.network(
                      messageText,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  Text(
                    _formatTimestamp(timestamp),
                    style: GoogleFonts.montserrat(
                        color: MyColors.DarkLighter, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Header(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: MyColors.red,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}{groupImage!}'),
                        radius: 30,
                      ),
                      SizedBox(width: 15),
                      Text(
                        groupName!,
                        style: GoogleFonts.montserrat(
                            color: MyColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('groups')
                        .doc(groupId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var messages = snapshot.data!.docs;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageTile(messages[index]);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
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
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: MyColors.white),
                        onPressed: () => _sendMessage(_messageController.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
