import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Messages/c_message_send.dart';
import 'package:taqreeb/Components/Messages/c_message_receive.dart';

class EventPlanningChatbot extends StatefulWidget {
  const EventPlanningChatbot({super.key});

  @override
  EventPlanningChatbotState createState() => EventPlanningChatbotState();
}

class EventPlanningChatbotState extends State<EventPlanningChatbot> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _showVenueCard = false;
  Map<String, dynamic>? _currentEventPlan;

  @override
  void initState() {
    super.initState();
    // Initial bot greeting
    _addBotMessage(
      "Hello! I'm your event planning assistant. Please describe the event you'd like to plan.",
    );
  }

  void _addBotMessage(String text, {String? imageUrl}) {
    setState(() {
      _messages.add({
        'text': text,
        'time': _formatTime(DateTime.now()),
        'isUser': false,
        'imageUrl': imageUrl,
      });
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'time': _formatTime(DateTime.now()),
        'isUser': true,
      });
    });
    _processUserInput(text);
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _processUserInput(String text) {
    // Simulate bot processing
    Future.delayed(Duration(seconds: 1), () {
      if (text.toLowerCase().contains('anniversary')) {
        _handleAnniversaryEvent();
      } else if (text.toLowerCase().contains('venue') && _currentEventPlan != null) {
        _show360VenuePreview();
      } else {
        _addBotMessage(
          "Great! Let me help you plan your event. Could you specify the venue type (indoor/outdoor) and budget range?",
        );
      }
    });
  }

  void _handleAnniversaryEvent() {
    _currentEventPlan = {
      'eventType': 'Wedding Anniversary',
      'date': 'February 2024',
      'guestCount': '50 people',
      'venue': 'Grand Ballroom at The Riverside Hotel',
      'venuePrice': '\$2,500',
      'catering': 'Chapter Three Catering',
      'cateringPrice': '\$65 per person',
      'totalBudget': '\$6,050',
      'venueImage': 'https://example.com/venue_image.jpg',
      'venue360': 'https://example.com/360_view.jpg',
    };

    _addBotMessage(
      "Great! I'll help you plan this perfect anniversary celebration. Could you specify the venue type (indoor/outdoor) and budget range?",
    );
  }

  void _show360VenuePreview() {
    setState(() {
      _showVenueCard = true;
    });
    _addBotMessage(
      "Here's the venue preview with 360° view:",
      imageUrl: _currentEventPlan!['venue360'],
    );
  }

  void _saveEventPlan() {
    _addBotMessage("Your event plan has been saved successfully!");
    setState(() {
      _showVenueCard = false;
    });
  }

  void _modifyDetails() {
    _addBotMessage("What would you like to change about your event plan?");
    setState(() {
      _showVenueCard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Planning Assistant'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length + (_showVenueCard ? 1 : 0),
              itemBuilder: (context, index) {
                if (_showVenueCard && index == _messages.length) {
                  return _buildEventPlanCard();
                }
                final message = _messages[_showVenueCard 
                    ? (index >= _messages.length ? index - 1 : index)
                    : index];
                return message['isUser']
                    ? SendMessage(
                        text: message['text'],
                        time: message['time'],
                      )
                  : RecieveMessage(  // Corrected spelling
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

  Widget _buildEventPlanCard() {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(76),
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
              ColoredButton(text: 'Save Event Plan', onPressed: _saveEventPlan),
            
              SizedBox(width: 10),
              BorderButton(text: 'Modify Details', onPressed: _modifyDetails),
             
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
}