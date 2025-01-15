import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';

class MembersScreen extends StatelessWidget {
  final String groupId;

  const MembersScreen({Key? key, required this.groupId}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchMembers() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Fetch the group document to get participant IDs
      DocumentSnapshot groupDoc =
          await _firestore.collection('groups').doc(groupId).get();
      List<dynamic> participantIds = groupDoc['participants'];

      // Fetch user details for each participant ID
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
      print("Error fetching members: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

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
                  width: screenWidth * 0.9,
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      var member = members[index];
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: MyColors.DarkLighter,
                          ),
                          width: screenWidth * 0.9,
                          padding: EdgeInsets.symmetric(
                              vertical: MaximumThing * 0.02,
                              horizontal: MaximumThing * 0.02),
                          margin:
                              EdgeInsets.symmetric(vertical: MaximumThing * 0.01),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${member['profilePicture']}',
                                ),
                                radius: MaximumThing * 0.03,
                              ),
                              Container(
                                width: screenWidth*0.65,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MaximumThing * 0.02),
                                  child: Text(
                                    member['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      color: MyColors.white,
                                      fontSize: MaximumThing * 0.02,
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
