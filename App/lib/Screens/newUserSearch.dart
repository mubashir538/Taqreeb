import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

class NewUserSearch extends StatefulWidget {
  const NewUserSearch({super.key});

  @override
  State<NewUserSearch> createState() => _NewUserSearchState();
}

class _NewUserSearchState extends State<NewUserSearch> {
  final TextEditingController controller = TextEditingController();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  List<Map<String, dynamic>> searchedUsers = [];

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchedUsers = [];
      });
    } else {
      try {
        QuerySnapshot userSnapshot = await usersCollection
            .where('username', isGreaterThanOrEqualTo: query)
            .where('username', isLessThanOrEqualTo: query + '\uf8ff')
            .get();

        setState(() {
          searchedUsers = userSnapshot.docs.map((userDoc) {
            return {
              'userId': userDoc.id,
              'chatimage':
                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${userDoc['profilePicture'] ?? ''}',
              'name': '${userDoc['firstName']} ${userDoc['lastName']}',
            };
          }).toList();
        });
      } catch (e) {
        print("Error searching users: $e");
      }
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    var format = DateFormat('h:mm a');
    return format.format(dateTime);
  }

  void _navigateToChatbox(String userId) {
    Navigator.pushNamed(context, '/ChatBox', arguments: {'userId': userId});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double max = screenWidth > screenHeight ? screenWidth : screenHeight;

    return Scaffold(
        backgroundColor: MyColors.Dark,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Header(
            heading: "Search New User",
          ),
          SizedBox(height: screenHeight * 0.02),
          SearchBox(
            onChanged: (query) {
              _searchUsers(query);
            },
            hint: 'Search by Username',
            controller: controller,
          ),
          Expanded(
            child: ListView(
              children: [
                ...searchedUsers.map((user) => MessageChatButton(
                      image: user['chatimage'],
                      onpressed: () => _navigateToChatbox(user['userId']),
                      name: user['name'],
                      message: 'Start a conversation',
                      newMessage: 0,
                      time: '',
                    )),
              ],
            ),
          ),
        ]));
  }
}
