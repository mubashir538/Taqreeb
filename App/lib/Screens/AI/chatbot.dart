import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/Messages/c_message_send.dart';
import 'package:taqreeb/Components/Messages/c_message_receive.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';

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
  bool _isLoading = false;
  String userId = '';

  void fetchUserId() async {
    userId = await MyStorage.getToken(MyTokens.userId) ?? '';
  }

  @override
  void initState() {
    super.initState();
    // Initial bot greeting
    fetchUserId();
    _addBotMessage(
      "Hello! I'm your event planning assistant. Please describe the event you'd like to plan.",
    );
  }

  void _addBotMessage(String text, {String? imageUrl, bool isBold = false}) {
    setState(() {
      _messages.add({
        'text': text,
        'time': _formatTime(DateTime.now()),
        'isUser': false,
        'imageUrl': imageUrl,
        'isBold': isBold,
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
      _isLoading = true;
    });

    _sendMessageToChatbot(text);
  }

  Future<void> _sendMessageToChatbot(String message) async {
    try {
      final response = await MyApi.sendChatbotMessage(
        userId: userId,
        message: message,
        context: context,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['status'] == 'error') {
        _addBotMessage(response['message'] ?? "Sorry, I encountered an error.");
        return;
      }

      // Check if this is a booking confirmation
      if ((response['response']
              ?.toString()
              .toLowerCase()
              .contains('booking_initiated') ??
          false)) {
        _handleBookingConfirmation(response['response']);
        return;
      }

      // Regular message
      _addBotMessage(
        response['response'] ?? "I didn't understand that. Could you rephrase?",
        isBold: response['is_bold'] ?? false,
      );

      // Check if we should show venue card
      if (message.toLowerCase().contains('venue') &&
          _currentEventPlan != null) {
        _show360VenuePreview();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _addBotMessage("Sorry, I encountered an error. Please try again.");
    }
  }

  void _handleBookingConfirmation(String message) {
    _addBotMessage(message);

    // Show booking confirmation
    setState(() {
      _currentEventPlan = {
        'status': 'confirmed',
        'confirmation_message': message,
      };
      _showVenueCard = true;
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
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
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: Screen.height(context) * 0.2,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: _messages.length +
                      (_showVenueCard ? 1 : 0) +
                      (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator
                    if (_isLoading &&
                        index == _messages.length + (_showVenueCard ? 1 : 0)) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 8.0),
                                Text('Thinking...'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

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
                        : RecieveMessage(
                            text: message['text'],
                            time: message['time'],
                            imageUrl: message['imageUrl'],
                            isBold: message['isBold'] ?? false,
                          );
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
          Positioned(top: 0, child: Header(heading: 'Event Planning Chatbot'))
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
            style: GoogleFonts.roboto(
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
          _buildDetailRow(
              'Catering Price:', _currentEventPlan!['cateringPrice']),
          Divider(),
          _buildDetailRow('Total Budget:', _currentEventPlan!['totalBudget'],
              isBold: true),
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
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
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
              child: MyTextBox(
            valueController: _messageController,
            hint: 'Type your message here...',
          )),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send, color: Colors.red),
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
