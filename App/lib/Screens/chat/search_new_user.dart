import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/Messages/c_message_chat.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';

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
        MyApi.postRequest(
            endpoint: 'error/application',
            body: {'error': 'Error searching users: $e'});
      }
    }
  }

  void _navigateToChatbox(String userId) {
    Navigator.pushNamed(context, '/ChatBox', arguments: {'userId': userId});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.Dark,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Header(
            heading: "Search New User",
          ),
          SizedBox(height: Screen.height(context) * 0.02),
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
