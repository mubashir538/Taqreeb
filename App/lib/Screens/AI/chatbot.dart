import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
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
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String userId = '';
  String _chatbotSessionKey = '';
  Map<String, dynamic>? _finalEventPlan;
  bool _showFinalPlan = false;

  Future<void> fetchUserId() async {
    userId = await MyStorage.getToken(MyTokens.userId) ?? '';
    _chatbotSessionKey = 'chatbot_session_$userId';
  }

  @override
  void initState() {
    super.initState();
    fetchUserId().then((_) {
      _loadChatHistory();
    });
  }

  Future<void> _loadChatHistory() async {
    final savedHistory = await MyStorage.getChatHistory(_chatbotSessionKey);
    if (savedHistory != null) {
      final savedPlan = await MyStorage.getPendingEventPlan(_chatbotSessionKey);
      setState(() {
        _messages = List<Map<String, dynamic>>.from(jsonDecode(savedHistory));
        // Check if we have a pending event plan
        _finalEventPlan = savedPlan;
        _showFinalPlan = _finalEventPlan != null;
      });
    } else {
      _addBotMessage(
        "Hello! I'm your event planning assistant. Please describe the event you'd like to plan.",
      );
    }
  }

  Future<void> _saveChatHistory() async {
    await MyStorage.saveChatHistory(
      _chatbotSessionKey,
      jsonEncode(_messages),
    );
    if (_finalEventPlan != null) {
      await MyStorage.savePendingEventPlan(
        _chatbotSessionKey,
        _finalEventPlan!,
      );
    }
  }

  Future<void> _clearPersistedData() async {
    await MyStorage.clearChatHistory(_chatbotSessionKey);
    await MyStorage.clearPendingEventPlan(_chatbotSessionKey);
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

  dispose() {
    _messageController.dispose();
    _clearPersistedData();
    super.dispose();
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

      // Check if this is the final event plan
      if (response['is_final_plan'] ?? false) {
        _handleFinalPlan(response['event_data']);
        return;
      }
      _saveChatHistory();
      // Regular message
      _addBotMessage(
        response['response'] ?? "I didn't understand that. Could you rephrase?",
        isBold: response['is_bold'] ?? false,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _addBotMessage("Sorry, I encountered an error. Please try again.");
    }
  }

  void _handleFinalPlan(Map<String, dynamic> eventData) {
    setState(() {
      _finalEventPlan = eventData;
      _showFinalPlan = true;
    });

    _addBotMessage(
      "Here's your complete event plan. Review it and click 'Add Event' to save it.",
      isBold: true,
    );
  }

  Future<void> _saveEvent() async {
    if (_finalEventPlan == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call your API to save the event
      final response = await MyApi.postRequest(
        endpoint: 'chatbot/saveEvent',
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        body: {
          'user_id': userId,
          'event_data': _finalEventPlan!,
        },
        context: context,
      );

      if (response['status'] == 'success') {
        // Clear chat history and reset
        await _clearPersistedData();
        setState(() {
          _messages.clear();
          _finalEventPlan = null;
          _showFinalPlan = false;
          _isLoading = false;
        });

        // Show success message
        _addBotMessage("Your event has been saved successfully!");

        // Initial bot greeting again
        _addBotMessage(
          "Hello! I'm your event planning assistant. Would you like to plan another event?",
        );
      } else {
        _addBotMessage(
            response['message'] ?? "Failed to save event. Please try again.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _addBotMessage("Failed to save event. Please try again.");
    }
  }

  void _clearChatHistory() {
    setState(() {
      _messages.clear();
      _finalEventPlan = null;
      _showFinalPlan = false;
    });

    // Initial bot greeting again
    _addBotMessage(
      "Hello! I'm your event planning assistant. Would you like to plan another event?",
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
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
                      (_showFinalPlan ? 1 : 0) +
                      (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator
                    if (_isLoading &&
                        index == _messages.length + (_showFinalPlan ? 1 : 0)) {
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

                    // Final event plan card
                    if (_showFinalPlan && index == _messages.length) {
                      return _buildFinalPlanCard();
                    }

                    final message = _messages[_showFinalPlan
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

  Widget _buildFinalPlanCard() {
    if (_finalEventPlan == null) return SizedBox.shrink();

    return FunctionCard(
      name: _finalEventPlan!['eventName'] ?? 'Event',
      head: 'Event Details',
      budget: 'Total Budget: ${_finalEventPlan!['totalBudget'] ?? 'N/A'}',
      headings: [
        'Event Type',
        'Date',
        'Total Guests',
        'Venue',
        'Catering',
        'Decorations',
      ],
      values: [
        _finalEventPlan!['eventType'] ?? 'N/A',
        _finalEventPlan!['date'] ?? 'N/A',
        _finalEventPlan!['totalGuests']?.toString() ?? '0',
        _finalEventPlan!['venueName'] ?? 'N/A',
        _finalEventPlan!['cateringName'] ?? 'N/A',
        _finalEventPlan!['decorationsName'] ?? 'N/A',
      ],
      type: 'event',
      color: Colors.deepPurple,
      delete: () {
        // Option to discard the plan
        _clearChatHistory();
      },
      editPressed: () {
        _saveEvent();
      },
      editText: 'Save Event',
      seePressed: () {
        // Option to see more details
        // You could implement a detailed view here
      },
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
            ),
          ),
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
