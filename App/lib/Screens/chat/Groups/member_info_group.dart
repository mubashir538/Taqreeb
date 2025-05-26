import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class MembersScreen extends StatelessWidget {
  final String groupId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MembersScreen({super.key, required this.groupId});

  Future<List<Map<String, dynamic>>> _fetchMembers() async {
    try {
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();
      final participantIds = List<String>.from(groupDoc['participants'] ?? []);

      final members = await Future.wait(
        participantIds.map((userId) => _fetchUserData(userId)),
      );

      return members
          .where((member) => member != null)
          .cast<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      _reportError('Error fetching members: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _fetchUserData(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return {
        'name': '${userDoc['firstName']} ${userDoc['lastName']}',
        'profilePicture': userDoc['profilePicture'],
        'userId': userId,
      };
    } catch (e) {
      _reportError('Error fetching user $userId: $e');
      return null;
    }
  }

  void _reportError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );
  }

  Widget _buildMemberItem(BuildContext context, Map<String, dynamic> member) {
    final avatarRadius = Screen.max(context) * 0.03;
    final textSize = Screen.max(context) * 0.02;
    final padding = Screen.max(context) * 0.02;
    final colors = AppColors(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colors.darkLighter,
      ),
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${member['profilePicture']}',
            ),
            radius: avatarRadius,
          ),
          SizedBox(width: padding),
          Expanded(
            child: Text(
              member['name'],
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                color: colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(AppColors colors) {
    return Center(
      child: Text(
        "Failed to load members",
        style: GoogleFonts.roboto(
          color: colors.red,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildMembersList(
      List<Map<String, dynamic>> members, BuildContext context) {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) =>
            _buildMemberItem(context, members[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Column(
        children: [
          const Header(heading: 'Group Members'),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return _buildErrorState(colors);
                }

                return _buildMembersList(snapshot.data!, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
