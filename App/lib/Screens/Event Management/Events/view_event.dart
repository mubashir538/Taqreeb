import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/icons.dart';
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
  bool _ischanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ischanged) return;
    _ischanged = true;
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
    ).then(
      (value) => _fetchEventDetails(),
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
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _buildContent(),
          const Positioned(top: 0, child: Header()),
          Positioned(
              bottom: Screen.max(context) * 0.02,
              right: Screen.max(context) * 0.02,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/CreateFunction',
                    arguments: {
                      'eventId': _eventData.eventId,
                      'type': _eventData.eventDetails['type'],
                    },
                  ).then(
                    (value) => _fetchEventDetails(),
                  );
                },
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Screen.max(context) * 0.015,
                        horizontal: Screen.max(context) * 0.03),
                    decoration: BoxDecoration(
                        color: MyColors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Screen.max(context) * 0.05),
                          topRight: Radius.circular(Screen.max(context) * 0.05),
                          bottomLeft:
                              Radius.circular(Screen.max(context) * 0.05),
                        )),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: Screen.max(context) * 0.02),
                        SizedBox(width: Screen.max(context) * 0.01),
                        Text('Add Function',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: Screen.max(context) * 0.02,
                            )),
                      ],
                    )),
              ))
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
            image: MyImages.eventDetails,
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
        SizedBox(
          width: Screen.width(context) * 0.8,
          child: _buildFunctionsList()),
        _buildActionButtons(),
        SizedBox(height: Screen.height(context) * 0.1),
      ],
    );
  }

  String _formatNumberWithCommas(String number) {
    return number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Widget _buildEventHeader() {
    return Text(
      _eventData.eventDetails['name'],
      style: GoogleFonts.roboto(
        fontSize: Screen.max(context) * 0.03,
        fontWeight: FontWeight.w700,
        color: MyColors.yellow,
      ),
    );
  }

  Widget _buildEventInfoSection() {
    final headingStyle = _buildTextStyle(fontWeight: FontWeight.w400);
    final textStyle = _buildTextStyle(fontWeight: FontWeight.w600);

    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              _buildInfoCard(
                  'Budget',
                  FontAwesomeIcons.wallet,
                  _formatNumberWithCommas(
                      _eventData.eventDetails['budget'].toString()),
                  headingStyle,
                  textStyle),
              _buildInfoCard('Event Type', FontAwesomeIcons.champagneGlasses,
                  _eventData.eventDetails['type'], headingStyle, textStyle),
            ],
          ),
          Row(
            children: [
              _buildInfoCard(
                'Guests',
                FontAwesomeIcons.userGroup,
                '${_eventData.eventDetails['guestsmin']} - ${_eventData.eventDetails['guestsmax']}',
                headingStyle,
                textStyle,
              ),
              _buildInfoCard(
                  'Date',
                  FontAwesomeIcons.calendarDays,
                  DateFormat('MMMM d, y')
                      .format(DateTime.parse(_eventData.eventDetails['date']))
                      .toString(),
                  headingStyle,
                  textStyle),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, IconData icon, String value,
      TextStyle headingStyle, TextStyle textStyle) {
    return Container(
      width: Screen.width(context) * 0.45,
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(icon,
                color: MyColors.yellow, size: Screen.max(context) * 0.02),
            SizedBox(width: Screen.max(context) * 0.01),
            Text(label, style: headingStyle),
          ]),
          Text(value, style: textStyle),
        ],
      ),
    );
  }

  Widget _buildFunctionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _eventData.functions.length,
      itemBuilder: (context, index) => FunctionCard(
        delete: () => _deleteFunction(index),
        color: MyColors.red,
        width: 0.8,
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
    ).then(
      (value) => _fetchEventDetails(),
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
    ).then(
      (value) => _fetchEventDetails(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          icon: FontAwesomeIcons.userGroup,
          text: "Event GuestList",
          onTap: _navigateToGuestList,
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.listCheck,
          text: "Event Checklist",
          onTap: () => _navigateToChecklist(),
        ),
        _buildActionButton(
          icon: FontAwesomeIcons.envelopeOpenText,
          text: "Create Invitation Card",
          onTap: () => Navigator.pushNamed(context, '/CreateInvitation',
              arguments: {'type': _eventData.eventDetails['type']}).then(
            (value) => _fetchEventDetails(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String text,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(Screen.max(context) * 0.01),
        padding: EdgeInsets.all(
          Screen.max(context) * 0.02,
        ),
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(10),
        ),
        width: Screen.width(context) * 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon,
                    color: MyColors.red, size: Screen.max(context) * 0.025),
                SizedBox(width: Screen.max(context) * 0.02),
                Text(
                  text,
                  style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      color: MyColors.white),
                ),
              ],
            ),
            Icon(FontAwesomeIcons.chevronRight,
                color: MyColors.whiteDarker, size: Screen.max(context) * 0.02),
          ],
        ),
      ),
    );
  }

  void _navigateToChecklist() {
    Navigator.pushNamed(
      context,
      '/CreateChecklistItems',
      arguments: {'eventId': _eventData.eventId},
    ).then(
      (value) => _fetchEventDetails(),
    );
  }

  TextStyle _buildTextStyle({required FontWeight fontWeight}) {
    return GoogleFonts.roboto(
      fontSize:
          Screen.max(context) * (fontWeight == FontWeight.w600 ? 0.02 : 0.015),
      fontWeight: fontWeight,
      color:
          fontWeight == FontWeight.w600 ? MyColors.white : MyColors.whiteDarker,
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
