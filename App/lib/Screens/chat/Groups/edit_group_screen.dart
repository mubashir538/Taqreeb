import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/tokens.dart';

class EditGroupScreen extends StatefulWidget {
  final String groupId;
  final String currentUserId;

  const EditGroupScreen({
    super.key,
    required this.groupId,
    required this.currentUserId,
  });

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _newGroupImage;
  String? _newGroupImageUrl;
  String? _adminId;
  List<String> _participants = [];
  List<Map<String, dynamic>> _availableUsers = [];
  bool _isAdmin = false;
  bool _isLoading = true;
  bool _showAddParticipants = false;
  final TextEditingController _searchController = TextEditingController();
  String _userType = 'user';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getUserType();
    await _fetchGroupData();
    await _fetchAvailableUsers();
  }

  Future<void> _getUserType() async {
    _userType = await MyTokens.getBusinessType() ;
  }

  Future<void> _fetchGroupData() async {
    try {
      final groupDoc =
          await _firestore.collection('groups').doc(widget.groupId).get();

      if (mounted) {
        setState(() {
          _groupNameController.text = groupDoc['groupName'];
          _newGroupImageUrl = groupDoc['groupImageUrl'];
          _adminId = groupDoc['adminId'];
          _participants = List<String>.from(groupDoc['participants']);
          _isAdmin = _adminId == widget.currentUserId;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchAvailableUsers() async {
    try {
      // First get all users the current user has chatted with
      final chatCollection = _getChatCollection();
      final userChats = await chatCollection
          .where('participants', arrayContains: widget.currentUserId)
          .get();

      // Extract all unique user IDs from chats
      final Set<String> chatUserIds = {};
      for (final chat in userChats.docs) {
        final participants = List<String>.from(chat['participants']);
        participants.remove(widget.currentUserId);
        chatUserIds.addAll(participants);
      }

      // Now fetch user details for these users
      final usersCollection = _getUsersCollection();
      final usersSnapshot = await usersCollection
          .where(FieldPath.documentId, whereIn: chatUserIds.toList())
          .get();

      // Filter out users already in the group
      setState(() {
        _availableUsers = usersSnapshot.docs
            .where((doc) => !_participants.contains(doc.id))
            .map((doc) => {
                  'userId': doc.id,
                  'name': _userType == 'user'
                      ? '${doc['firstName']} ${doc['lastName']}'
                      : doc['businessName'] ?? 'Unknown',
                  'profilePicture': doc['profilePicture'],
                })
            .toList();
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  CollectionReference _getChatCollection() {
    switch (_userType) {
      case 'businessowner':
        return _firestore.collection('BusinessChats');
      case 'freelancer':
        return _firestore.collection('FreelancerChats');
      default:
        return _firestore.collection('chats');
    }
  }

  CollectionReference _getUsersCollection() {
    switch (_userType) {
      case 'businessowner':
        return _firestore.collection('businessUsers');
      case 'freelancer':
        return _firestore.collection('freelanceUsers');
      default:
        return _firestore.collection('users');
    }
  }

  Future<void> _pickNewImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() => _newGroupImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadNewImage() async {
    if (_newGroupImage == null) return;

    final response = await MyApi.postMultipartRequest(
      endpoint: 'saveGroupProfileImage/',
      body: {'userid': widget.currentUserId},
      files: {'image': _newGroupImage!.path},
    );

    if (response['status'] == 'success' && mounted) {
      setState(() => _newGroupImageUrl = response['path']);
    }
  }

  Future<void> _updateGroupInfo() async {
    if (!_isAdmin) return;

    await _uploadNewImage();

    try {
      final updateData = {
        'groupName': _groupNameController.text,
        if (_newGroupImageUrl != null) 'groupImageUrl': _newGroupImageUrl,
        'participants': _participants,
      };

      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .update(updateData);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _addParticipant(String userId) async {
    if (!_isAdmin || !mounted) return;

    setState(() {
      _participants.add(userId);
      _availableUsers.removeWhere((user) => user['userId'] == userId);
      _showAddParticipants = false;
    });
  }

  Future<void> _removeParticipant(String userId) async {
    if ((!_isAdmin && userId != widget.currentUserId) || !mounted) return;

    setState(() {
      _participants.remove(userId);
      // Add back to available users if we have their data
      final userToAddBack = _availableUsers.firstWhere(
        (user) => user['userId'] == userId,
        orElse: () => {},
      );
      if (userToAddBack.isNotEmpty) {
        _availableUsers.add(userToAddBack);
      }
    });

    // If non-admin is removing themselves (leaving group)
    if (userId == widget.currentUserId && !_isAdmin) {
      await _leaveGroup();
    }
  }

  Future<void> _deleteGroup() async {
    if (!_isAdmin) return;

    try {
      // First delete all messages
      final messages = await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages')
          .get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Then delete the group
      await _firestore.collection('groups').doc(widget.groupId).delete();

      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _leaveGroup() async {
    try {
      await _firestore.collection('groups').doc(widget.groupId).update({
        'participants': FieldValue.arrayRemove([widget.currentUserId])
      });

      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildParticipantList() {
    return Column(
      children: [
        ListTile(
          title: Text('Participants', style: GoogleFonts.roboto(fontSize: 18)),
          trailing: _isAdmin
              ? IconButton(
                  icon: const Icon(FontAwesomeIcons.plus),
                  onPressed: () => setState(() => _showAddParticipants = true),
                )
              : null,
        ),
        ..._participants.map((userId) => FutureBuilder<DocumentSnapshot>(
              future: _getUsersCollection().doc(userId).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final user = snapshot.data!;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}'),
                  ),
                  title: Text(_userType == 'user'
                      ? '${user['firstName']} ${user['lastName']}'
                      : user['businessName'] ?? 'Unknown'),
                  subtitle: userId == _adminId
                      ? Text('Admin',
                          style: GoogleFonts.roboto(color: Colors.green))
                      : null,
                  trailing: _isAdmin
                      ? userId == _adminId
                          ? null // Can't remove admin
                          : IconButton(
                              icon: const Icon(FontAwesomeIcons.circleMinus,
                                  color: Colors.red),
                              onPressed: () => _removeParticipant(userId),
                            )
                      : userId == widget.currentUserId
                          ? IconButton(
                              icon: const Icon(
                                  FontAwesomeIcons.arrowRightFromBracket,
                                  color: Colors.red),
                              onPressed: () => _removeParticipant(userId),
                            )
                          : null,
                );
              },
            ))
      ],
    );
  }

  Widget _buildAddParticipantsPanel() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search users',
              suffixIcon: IconButton(
                icon: const Icon(FontAwesomeIcons.xmark),
                onPressed: () => setState(() => _showAddParticipants = false),
              ),
            ),
            onChanged: (value) {
              // Implement search filtering if needed
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _availableUsers.length,
            itemBuilder: (context, index) {
              final user = _availableUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${user['profilePicture']}'),
                ),
                title: Text(user['name']),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.plus, color: Colors.green),
                  onPressed: () => _addParticipant(user['userId']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Group'),
        actions: [
          if (_isAdmin)
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete Group'),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteGroup();
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_showAddParticipants) ...[
            GestureDetector(
              onTap: _isAdmin ? _pickNewImage : null,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _newGroupImage != null
                    ? FileImage(_newGroupImage!)
                    : NetworkImage(
                            '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}$_newGroupImageUrl')
                        as ImageProvider,
                child: _isAdmin
                    ? const Icon(FontAwesomeIcons.pen, size: 30)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _groupNameController,
                enabled: _isAdmin,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildParticipantList()),
          ] else ...[
            Expanded(child: _buildAddParticipantsPanel()),
          ],
          if (!_showAddParticipants && _isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _updateGroupInfo,
                child: const Text('Save Changes'),
              ),
            ),
        ],
      ),
    );
  }
}
