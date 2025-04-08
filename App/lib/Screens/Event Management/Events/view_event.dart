import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/images.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final _eventData = _EventDetailsData();
  Timer? _refreshTimer;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeEvent();
  }

  void _initializeEvent() {
    final eventId = ModalRoute.of(context)!.settings.arguments as int;
    _eventData.eventId = eventId;
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    await ApiCall.fetchAPI(
      'eventdetails/${_eventData.eventId}',
      refresh: true,
      onSuccess: (token, data) {
        if (!mounted) return;

        setState(() {
          _eventData.token = token;
          _eventData.eventDetails = data['EventDetail'];
          _eventData.functions = data['Functions'] ?? [];
          _isLoading = false;
        });
      },
      context: mounted ? context : null,
    );
  }

  Future<void> _deleteFunction(int index) async {
    final functionId = _eventData.functions[index]['id'].toString();

    final response = await MyApi.postRequest(
      endpoint: 'DeleteFunction/',
      headers: {'Authorization': 'Bearer ${_eventData.token}'},
      body: {'FunctionId': functionId},
    );

    if (!mounted) return;

    if (response['status'] == 'success') {
      MyScaffold(text: 'Function Deleted Successfully').show(context);
      setState(() => _eventData.functions.removeAt(index));
    } else {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }
  }

  void _navigateToGuestList() async {
    final response = await MyApi.postRequest(
      endpoint: 'show/guest/',
      headers: {'Authorization': 'Bearer ${_eventData.token}'},
      body: {'EventId': _eventData.eventId, 'FunctionID': "None"},
    );

    if (!mounted) return;

    final routeName = response["Guests"].isEmpty
        ? '/CreateGuestList'
        : '/CreateGuestList_List';

    Navigator.pushNamed(
      context,
      routeName,
      arguments: {'eventId': _eventData.eventId},
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          _buildContent(),
          const Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Headersecondary(
            heading: "Your Event Details",
            image: MyImages.EventDetails,
          ),
          SizedBox(height: Screen.height(context) * 0.03),
          _isLoading ? _buildLoadingIndicator() : _buildEventContent(),
        ],
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

  Widget _buildEventContent() {
    return Column(
      children: [
        _buildEventHeader(),
        SizedBox(height: Screen.height(context) * 0.02),
        _buildEventInfoSection(),
        SizedBox(height: Screen.height(context) * 0.02),
        _buildFunctionsList(),
        _buildActionButtons(),
        SizedBox(height: Screen.height(context) * 0.1),
        Center(child: MyDivider()),
        _buildCreateFunctionButton(),
      ],
    );
  }

  Widget _buildEventHeader() {
    return Text(
      _eventData.eventDetails['name'],
      style: GoogleFonts.montserrat(
        fontSize: Screen.max(context) * 0.03,
        fontWeight: FontWeight.w700,
        color: MyColors.Yellow,
      ),
    );
  }

  Widget _buildEventInfoSection() {
    final headingStyle = _buildTextStyle(fontWeight: FontWeight.w600);
    final textStyle = _buildTextStyle(fontWeight: FontWeight.w400);

    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: Column(
        children: [
          _buildInfoRow('Budget', _eventData.eventDetails['budget'].toString(),
              headingStyle, textStyle),
          SizedBox(height: Screen.height(context) * 0.01),
          _buildInfoRow('Event Type', _eventData.eventDetails['type'],
              headingStyle, textStyle),
          SizedBox(height: Screen.height(context) * 0.01),
          _buildInfoRow(
            'Guests',
            '${_eventData.eventDetails['guestsmin']} - ${_eventData.eventDetails['guestsmax']}',
            headingStyle,
            textStyle,
          ),
          SizedBox(height: Screen.height(context) * 0.01),
          _buildInfoRow(
              'Date', _eventData.eventDetails['date'], headingStyle, textStyle),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label, String value, TextStyle headingStyle, TextStyle textStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: headingStyle),
        Text(value, style: textStyle),
      ],
    );
  }

  Widget _buildFunctionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _eventData.functions.length,
      itemBuilder: (context, index) => Function12(
        delete: () => _deleteFunction(index),
        color: Color(int.parse(
          '0xff${_eventData.eventDetails["themeColor"].substring(1)}',
        )),
        name: _eventData.functions[index]['name'],
        type: _eventData.functions[index]['type'],
        head: 'Budget',
        budget: _eventData.functions[index]['budget'].toString(),
        headings: const ['Date'],
        values: [_eventData.functions[index]['date']],
        editPressed: () => _navigateToEditFunction(index),
        seePressed: () => _navigateToFunctionDetail(index),
      ),
    );
  }

  void _navigateToEditFunction(int index) {
    Navigator.pushNamed(
      context,
      '/EditFunction',
      arguments: {
        'functionId': _eventData.functions[index]['id'].toString(),
        'eventId': _eventData.eventId,
        'type': _eventData.eventDetails['type'],
      },
    );
  }

  void _navigateToFunctionDetail(int index) {
    Navigator.pushNamed(
      context,
      '/FunctionDetail',
      arguments: {
        'eventid': _eventData.eventId,
        'event': _eventData.eventDetails['name'],
        'fid': _eventData.functions[index]['id'],
        'type': _eventData.eventDetails['type']
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          text: "Event GuestList",
          onTap: _navigateToGuestList,
        ),
        _buildActionButton(
          text: "Event CheckLlist",
          onTap: () => _navigateToChecklist(),
        ),
        _buildActionButton(
          text: "Create Invitation Card",
          onTap: () => Navigator.pushNamed(context, '/CreateInvitation',
              arguments: {'type': _eventData.eventDetails['type']}),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String text, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      padding: EdgeInsets.symmetric(
        vertical: Screen.height(context) * 0.01,
        horizontal: Screen.width(context) * 0.03,
      ),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(127),
            spreadRadius: 5,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      width: Screen.width(context) * 0.8,
      child: InkWell(
        onTap: onTap,
        child: Text(text),
      ),
    );
  }

  void _navigateToChecklist() {
    Navigator.pushNamed(
      context,
      '/CreateChecklistItems',
      arguments: {'eventId': _eventData.eventId},
    );
  }

  Widget _buildCreateFunctionButton() {
    return ColoredButton(
      text: 'Create New Function',
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/CreateFunction',
          arguments: {
            'eventId': _eventData.eventId,
            'type': _eventData.eventDetails['type'],
          },
        );
      },
    );
  }

  TextStyle _buildTextStyle({required FontWeight fontWeight}) {
    return GoogleFonts.montserrat(
      fontSize: Screen.max(context) * 0.017,
      fontWeight: fontWeight,
      color: fontWeight == FontWeight.w600 ? MyColors.Yellow : MyColors.white,
    );
  }
}

// Encapsulates all event-related data
class _EventDetailsData {
  String token = '';
  int eventId = 0;
  Map<String, dynamic> eventDetails = {};
  List<dynamic> functions = [];
}
