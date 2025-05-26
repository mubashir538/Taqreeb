import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Messages/c_message_send.dart';
import 'package:taqreeb/Components/Messages/c_message_receive.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';

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
  final ScrollController _scrollController = ScrollController();

  void fetchUserId() async {
    userId = await MyStorage.getToken(MyTokens.userId) ?? '';
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
    _addBotMessage(
      "Hello! I'm your event planning assistant. Please describe the event you'd like to plan.",
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      _scrollToBottom();
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
      _scrollToBottom();
    });

    _sendMessageToChatbot(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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

      if ((response['response']
              ?.toString()
              .toLowerCase()
              .contains('booking_initiated') ??
          false)) {
        _handleBookingConfirmation(response['response']);
        return;
      }

      _addBotMessage(
        response['response'] ?? "I didn't understand that. Could you rephrase?",
        isBold: response['is_bold'] ?? false,
      );

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
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Column(
              children: [
                // Chat header
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Screen.max(context) * 0.03),
                  decoration: BoxDecoration(color: colors.red),
                  child: Column(
                    children: [
                      SizedBox(height: Screen.max(context) * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: Screen.max(context) * 0.05,
                            backgroundColor: colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                MyImages.aiIcon,
                              ),
                            ),
                          ),
                          SizedBox(width: Screen.width(context) * 0.04),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Screen.width(context) * 0.6,
                                child: Text(
                                  "Event Planning Assistant",
                                  style: GoogleFonts.roboto(
                                    fontSize: Screen.max(context) * 0.025,
                                    fontWeight: FontWeight.w600,
                                    color: colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "Always online",
                                style: GoogleFonts.roboto(
                                  fontSize: Screen.max(context) * 0.015,
                                  color: colors.whiteDarker,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: Screen.max(context) * 0.02),
                    ],
                  ),
                ),
                // Messages list
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(8.0),
                    itemCount: _messages.length +
                        (_showVenueCard ? 1 : 0) +
                        (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Loading indicator
                      if (_isLoading &&
                          index ==
                              _messages.length + (_showVenueCard ? 1 : 0)) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: colors.darkLighter,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colors.white),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Thinking...',
                                    style: GoogleFonts.roboto(
                                      color: colors.white,
                                    ),
                                  ),
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
                // Chat input
                _buildMessageInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventPlanCard() {
    final colors = AppColors(context);

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: colors.red.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Plan Summary',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.white,
            ),
          ),
          SizedBox(height: 10),
          _buildDetailRow('Event Type:', _currentEventPlan!['eventType']),
          _buildDetailRow('Date:', _currentEventPlan!['date']),
          _buildDetailRow('Guest Count:', _currentEventPlan!['guestCount']),
          Divider(color: colors.white.withAlpha(76)),
          _buildDetailRow('Venue:', _currentEventPlan!['venue']),
          _buildDetailRow('Venue Price:', _currentEventPlan!['venuePrice']),
          _buildDetailRow('Catering:', _currentEventPlan!['catering']),
          _buildDetailRow(
              'Catering Price:', _currentEventPlan!['cateringPrice']),
          Divider(color: colors.white.withAlpha(76)),
          _buildDetailRow('Total Budget:', _currentEventPlan!['totalBudget'],
              isBold: true),
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
    final colors = AppColors(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              color: colors.whiteDarker,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
                color: colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final colors = AppColors(context);

    return Container(
      color: colors.lightDark,
      padding: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.darkLighter,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _messageController,
                  style: GoogleFonts.roboto(color: colors.white),
                  decoration: InputDecoration(
                    hintText: " Type a message",
                    hintStyle: GoogleFonts.roboto(color: colors.whiteDarker),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(FontAwesomeIcons.paperPlane, color: colors.white),
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  _addUserMessage(_messageController.text);
                  _messageController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
