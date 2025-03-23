import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/api_service.dart';

class MembersScreen extends StatelessWidget {
  final String groupId;

  const MembersScreen({Key? key, required this.groupId}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchMembers() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot groupDoc =
          await _firestore.collection('groups').doc(groupId).get();
      List<dynamic> participantIds = groupDoc['participants'];

      List<Map<String, dynamic>> members = [];
      for (String userId in participantIds) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        members.add({
          'name': userDoc['firstName'] + ' ' + userDoc['lastName'],
          'profilePicture': userDoc['profilePicture'],
        });
      }

      return members;
    } catch (e) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'Error fetching members: $e'});
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Column(
        children: [
          Header(
            heading: 'Group Members',
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchMembers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                      "Failed to load members",
                      style: GoogleFonts.montserrat(
                          color: MyColors.red, fontSize: 16),
                    ),
                  );
                }

                List<Map<String, dynamic>> members = snapshot.data!;
                return SizedBox(
                  width: Screen.width(context) * 0.9,
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      var member = members[index];
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyColors.DarkLighter,
                          ),
                          width: Screen.width(context) * 0.9,
                          padding: EdgeInsets.symmetric(
                              vertical: Screen.max(context) * 0.02,
                              horizontal: Screen.max(context) * 0.02),
                          margin: EdgeInsets.symmetric(
                              vertical: Screen.max(context) * 0.01),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${member['profilePicture']}',
                                ),
                                radius: Screen.max(context) * 0.03,
                              ),
                              Container(
                                width: Screen.width(context) * 0.65,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Screen.max(context) * 0.02),
                                  child: Text(
                                    member['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      color: MyColors.white,
                                      fontSize: Screen.max(context) * 0.02,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
