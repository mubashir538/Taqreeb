import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Home%20Page/c_search_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class YourEvents extends StatefulWidget {
  const YourEvents({super.key});

  @override
  State<YourEvents> createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _events = {};
  bool _isLoading = true;
  final GlobalKey _headerKey = GlobalKey();
  List<dynamic> _filteredEvents = [];
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeHeaderHeight();
    _fetchData();
  }

  void _initializeHeaderHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: _headerKey,
        callback: (renderbox) {
          _changeHeight(renderbox);
        },
      );
    });
  }

  void _searchEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = List.from(_events["Event"]);
      } else {
        _filteredEvents = _events["Event"]
            .where((event) =>
                event["name"].toLowerCase().contains(query.toLowerCase()) ||
                event["type"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _fetchData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    await ApiCall.fetchAPI('YourEvents/$userId', refresh: true,
        onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          _events = data;
          _filteredEvents = List.from(data["Event"]);
          _isLoading = false;
        });
      }
    }, context: mounted ? context : null);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _deleteEvent(int eventId, int index) async {
    final response = await MyApi.postRequest(
      endpoint: 'DeleteEvent/',
      context: mounted ? context : null,
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      body: {'EventId': eventId.toString()},
    );

    if (response['status'] == 'success') {
      final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      await MyApi.deleteCache('YourEvents/$userId');
      _fetchData();
      if (mounted) {
        MyScaffold(text: 'Event Deleted Successfully').show(context);
      }
      setState(() {
        _events["Event"].removeAt(index);
      });
    } else {
      if (mounted) {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderbox) {
        _changeHeight(renderbox);
      },
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UI_Management.headerHeight),
                _buildSearchBox(),
                _isLoading ? _buildLoadingIndicator() : _buildEventList(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Your Events',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
      child: SearchBox(
        focusNode: searchFocus,
        onclick: () {
          searchFocus.requestFocus();
        },
        onChanged: (value) {
          _searchEvents(value); // Call the search method
        },
        controller: _searchController,
        hint: 'Search Typing to Search',
        width: Screen.width(context) * 0.9,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return FunctionCard(
          delete: () => _deleteEvent(event["id"], index),
          color: Color(int.parse(
              '0xff${event["themeColor"].substring(1, event["themeColor"].length)}')),
          name: event["name"],
          head: 'Budget',
          budget: event["budget"].toString(),
          headings: ['Event Type', 'Functions', 'Date'],
          values: [
            event["type"],
            _events["nofunctions"][index].toString(),
            event["date"],
          ],
          type: 'Event',
          seePressed: () {
            Navigator.pushNamed(
              context,
              '/EventDetails',
              arguments: event["id"],
            );
          },
          editPressed: () {
            Navigator.pushNamed(
              context,
              '/EditEvent',
              arguments: event["id"].toString(),
            );
          },
        );
      },
    );
  }
}
