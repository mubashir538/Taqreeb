import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
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
  GlobalKey _headerKey = GlobalKey();

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

  Future<void> _fetchData() async {
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    await ApiCall.fetchAPI('YourEvents/$userId', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          _events = data;
          _isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  void _changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _deleteEvent(int eventId, int index) async {
    final response = await MyApi.postRequest(
      endpoint: 'DeleteEvent/',
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      body: {'EventId': eventId.toString()},
    );

    if (response['status'] == 'success') {
      MyScaffold(text: 'Event Deleted Successfully').show(context);
      setState(() {
        _events["Event"].removeAt(index);
      });
    } else {
      MyScaffold(text: 'Something Went Wrong!').show(context);
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
      backgroundColor: MyColors.Dark,
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
        onChanged: (value) {},
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
      itemCount: _events["Event"].length,
      itemBuilder: (context, index) {
        final event = _events["Event"][index];
        return Function12(
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
