import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Messages/c_message_send.dart';
import 'package:taqreeb/Components/Messages/c_message_receive.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class EventPlanningChatbot extends StatefulWidget {
  @override
  _EventPlanningChatbotState createState() => _EventPlanningChatbotState();
}

class _EventPlanningChatbotState extends State<EventPlanningChatbot> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  
  List<Map<String, dynamic>> _messages = [];
  bool _showVenueCard = false;
  bool _isLoading = true;
  bool _isMessageSent = true;
  Map<String, dynamic>? _currentEventPlan;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _fetchCurrentUserId();
    _addBotMessage(
      "Hello! I'm your event planning assistant. Please describe the event you'd like to plan.",
    );
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchCurrentUserId() async {
    _currentUserId = await MyStorage.getToken(MyTokens.userId);
    if (_currentUserId == null) {
      _handleError('Failed to get current user ID');
    }
  }

  void _addBotMessage(String text, {String? imageUrl}) {
    setState(() {
      _messages.add({
        'text': text,
        'time': _formatTime(DateTime.now()),
        'isUser': false,
        'imageUrl': imageUrl,
        'timestamp': DateTime.now(),
      });
    });
  }

  Future<void> _addUserMessage(String text) async {
    if (_currentUserId == null || text.isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'time': _formatTime(DateTime.now()),
        'isUser': true,
        'timestamp': DateTime.now(),
      });
      _isMessageSent = false;
    });

    await _processUserInput(text);
    
    if (mounted) {
      setState(() => _isMessageSent = true);
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  Future<void> _processUserInput(String text) async {
    // Simulate processing delay
    await Future.delayed(Duration(seconds: 1));

    if (text.toLowerCase().contains('anniversary')) {
      await _handleAnniversaryEvent();
    } else if (text.toLowerCase().contains('venue') && _currentEventPlan != null) {
      await _show360VenuePreview();
    } else {
      _addBotMessage(
        "Great! Let me help you plan your event. Could you specify the venue type (indoor/outdoor) and budget range?",
      );
    }
  }

  Future<void> _handleAnniversaryEvent() async {
    try {
      // Fetch event data from Firestore or API
      final eventData = await _fetchEventData();
      
      setState(() {
        _currentEventPlan = {
          'eventType': 'Wedding Anniversary',
          'date': eventData['date'] ?? 'February 2024',
          'guestCount': eventData['guestCount'] ?? '50 people',
          'venue': eventData['venue'] ?? 'Grand Ballroom at The Riverside Hotel',
          'venuePrice': eventData['venuePrice'] ?? '\$2,500',
          'catering': eventData['catering'] ?? 'Chapter Three Catering',
          'cateringPrice': eventData['cateringPrice'] ?? '\$65 per person',
          'totalBudget': eventData['totalBudget'] ?? '\$6,050',
          'venueImage': eventData['venueImage'] ?? 'https://example.com/venue_image.jpg',
          'venue360': eventData['venue360'] ?? 'https://example.com/360_view.jpg',
        };
      });

      _addBotMessage(
        "Great! I'll help you plan this perfect anniversary celebration. Could you specify the venue type (indoor/outdoor) and budget range?",
      );
    } catch (e) {
      _handleError('Failed to load event data: $e');
      _addBotMessage("Sorry, I couldn't load the event details. Please try again.");
    }
  }

  Future<Map<String, dynamic>> _fetchEventData() async {
    // Implement your Firestore/API data fetching here
    return {};
  }

  Future<void> _show360VenuePreview() async {
    try {
      setState(() => _showVenueCard = true);
      _addBotMessage(
        "Here's the venue preview with 360° view:",
        imageUrl: _currentEventPlan!['venue360'],
      );
    } catch (e) {
      _handleError('Failed to show venue preview: $e');
    }
  }

  Future<void> _saveEventPlan() async {
    try {
      if (_currentUserId == null || _currentEventPlan == null) return;
      
      await _firestore.collection('eventPlans').add({
        ..._currentEventPlan!,
        'userId': _currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _addBotMessage("Your event plan has been saved successfully!");
      setState(() => _showVenueCard = false);
    } catch (e) {
      _handleError('Failed to save event plan: $e');
      _addBotMessage("Failed to save your event plan. Please try again.");
    }
  }

  Future<void> _modifyDetails() async {
    _addBotMessage("What would you like to change about your event plan?");
    setState(() => _showVenueCard = false);
  }

  void _handleError(String error) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': error},
    );
  }

  Widget _buildEventPlanCard() {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Plan Summary',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(height: 10),
          _buildDetailRow('Event Type:', _currentEventPlan!['eventType']),
          _buildDetailRow('Date:', _currentEventPlan!['date']),
          _buildDetailRow('Guest Count:', _currentEventPlan!['guestCount']),
          Divider(),
          _buildDetailRow('Venue:', _currentEventPlan!['venue']),
          _buildDetailRow('Venue Price:', _currentEventPlan!['venuePrice']),
          _buildDetailRow('Catering:', _currentEventPlan!['catering']),
          _buildDetailRow('Catering Price:', _currentEventPlan!['cateringPrice']),
          Divider(),
          _buildDetailRow('Total Budget:', _currentEventPlan!['totalBudget'], isBold: true),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ColoredButton(
                text: 'Save Event Plan',
                onPressed: _saveEventPlan,
              ),
              SizedBox(width: 10),
              BorderButton(
                text: 'Modify Details',
                onPressed: _modifyDetails,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  _addUserMessage(text);
                  _messageController.clear();
                }
              },
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send, color: Colors.deepPurple),
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                _addUserMessage(_messageController.text);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Planning Assistant'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    reverse: true,
                    itemCount: _messages.length + (_showVenueCard ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_showVenueCard && index == 0) {
                        return _buildEventPlanCard();
                      }
                      final messageIndex = _showVenueCard ? index - 1 : index;
                      final message = _messages[messageIndex];
                      return message['isUser']
                          ? SendMessage(
                              text: message['text'],
                              time: message['time'],
                            )
                          : RecieveMessage(
                              text: message['text'],
                              time: message['time'],
                              imageUrl: message['imageUrl'],
                            );
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
    );
  }
}