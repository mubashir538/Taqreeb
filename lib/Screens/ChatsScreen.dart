import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final TextEditingController controller = TextEditingController();
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> userChats = []; // User's chat list
  bool isCheckingContacts = false;

  @override
  void initState() {
    super.initState();
    _fetchUserChats();
  }

  // Fetch user's chat list from Firebase
  Future<void> _fetchUserChats() async {
    setState(() {
      isCheckingContacts = true;
    });

    try {
      final userId = 'currentUserId'; // Replace with actual user ID
      final snapshot = await database.child('users/$userId/chats').get();

      if (snapshot.exists) {
        setState(() {
          userChats = List<Map<String, dynamic>>.from(snapshot.value as List);
        });
      }
    } catch (e) {
      print("Error fetching user chats: $e");
    }

    setState(() {
      isCheckingContacts = false;
    });
  }

  // Check phone contacts and add matching users to chats
  Future<void> _checkPhoneContacts() async {
    final status = await Permission.contacts.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission to access contacts denied")),
      );
      return;
    }

    setState(() {
      isCheckingContacts = true;
    });

    try {
      final contacts = await ContactsService.getContacts();
      final List<String> phoneNumbers = contacts
          .where((contact) => contact.phones != null)
          .expand(
              (contact) => contact.phones!.map((phone) => phone.value ?? ''))
          .toList();

      final snapshot = await database.child('users').get();
      if (snapshot.exists) {
        final Map<String, dynamic> users =
            Map<String, dynamic>.from(snapshot.value as Map);

        for (var user in users.entries) {
          final userPhone = user.value['phone'] as String;
          if (phoneNumbers.contains(userPhone)) {
            final chatData = {
              'userId': user.key,
              'name': user.value['name'],
              'lastMessage': '',
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            };

            setState(() {
              userChats.add(chatData);
            });

            await database
                .child(
                    'users/currentUserId/chats') // Replace with current user ID
                .push()
                .set(chatData);
          }
        }
      }
    } catch (e) {
      print("Error checking contacts: $e");
    }

    setState(() {
      isCheckingContacts = false;
    });
  }

  // Navigate to new user search screen
  void _navigateToSearchUsers() {
    Navigator.pushNamed(context, '/SearchUsers');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSearchUsers,
        child: Icon(Icons.add, color: MyColors.white),
        backgroundColor: MyColors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Header(
              heading: "Chats",
              para:
                  "This password should be different from the previous password",
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.03),
              child: SearchBox(
                onChanged: (value){

                },
                hint: 'Search Typing to Search',
                controller: controller,
                width: screenWidth * 0.9,
              ),
            ),
            isCheckingContacts
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userChats.length,
                    itemBuilder: (context, index) {
                      final chat = userChats[index];
                      return MessageChatButton(
                        onpressed: () {
                          Navigator.pushNamed(context, '/ChatBox');
                        },
                        name: chat['name'],
                        message: chat['lastMessage'] ?? '',
                        newMessage: 0,
                        time: '11:30 AM',
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
