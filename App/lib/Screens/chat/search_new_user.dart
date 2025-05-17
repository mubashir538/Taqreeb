import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Messages/c_message_chat.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class NewUserSearch extends StatefulWidget {
  const NewUserSearch({super.key});

  @override
  State<NewUserSearch> createState() => _NewUserSearchState();
}

class _NewUserSearchState extends State<NewUserSearch> {
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  FocusNode searchFocus = FocusNode();

  List<Map<String, dynamic>> _searchedUsers = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchedUsers = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final userSnapshot = await _usersCollection
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      if (!mounted) return;

      setState(() {
        _searchedUsers = userSnapshot.docs.map((userDoc) {
          return {
            'userId': userDoc.id,
            'chatimage':
                '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${userDoc['profilePicture'] ?? ''}',
            'name': '${userDoc['firstName']} ${userDoc['lastName']}',
          };
        }).toList();
        _isSearching = false;
      });
    } catch (e) {
      _handleError('Error searching users: $e');
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _navigateToChatbox(String userId) {
    context.pushNamedTransition(
        routeName: '/ChatBox',
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 300),arguments: {'userId': userId});
  }

  void _handleError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchedUsers.isEmpty) {
      return Center(
        child: Text(
          'No users found',
          style: GoogleFonts.roboto(color: Colors.white),
        ),
      );
    }

    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _searchedUsers.length,
        itemBuilder: (context, index) {
          final user = _searchedUsers[index];
          return MessageChatButton(
            image: user['chatimage'],
            onpressed: () => _navigateToChatbox(user['userId']),
            name: user['name'],
            message: 'Start a conversation',
            newMessage: 0,
            time: '',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Header(heading: "Search New User"),
            SizedBox(height: Screen.height(context) * 0.02),
            SearchBox(
              focusNode: searchFocus,
              onclick: () {
                searchFocus.requestFocus();
              },
              onChanged: _searchUsers,
              hint: 'Search by Username',
              controller: _searchController,
            ),
            SizedBox(height: Screen.height(context) * 0.02),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }
}
