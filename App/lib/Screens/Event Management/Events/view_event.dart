import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/Components/global/header_secondary.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/images.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String token = '';
  Map<String, dynamic> events = {};
  late int EventId;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      EventId = args;
    });
    fetchData();
  }

  Timer? timer;
  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";

    final Event = await MyApi.getRequest(
      endpoint: 'eventdetails/${this.EventId}',
      headers: {'Authorization': 'Bearer $token'},
    );

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          this.token = token;
          this.events = Event ?? {};
          if (Event == null || Event['status'] == 'error') {
            MyScaffold(text: 'Something Went Wrong!').show(context);
            return;
          } else {
            isLoading = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
     
    
    TextStyle heading = GoogleFonts.montserrat(
        fontSize: Screen.max(context) * 0.017,
        fontWeight: FontWeight.w600,
        color: MyColors.Yellow);

    TextStyle text = GoogleFonts.montserrat(
        fontSize: Screen.max(context) * 0.017,
        fontWeight: FontWeight.w400,
        color: MyColors.white);
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Headersecondary(
                heading: "Your Event Details",
                image: MyImages.EventDetails,
              ),
              SizedBox(height: Screen.height(context) * 0.03),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                    ))
                  : Column(
                      children: [
                        Text(
                          events['EventDetail']['name'],
                          style: GoogleFonts.montserrat(
                              fontSize: Screen.max(context) * 0.03,
                              fontWeight: FontWeight.w700,
                              color: MyColors.Yellow),
                        ),
                        SizedBox(height: Screen.height(context) * 0.02),
                        SizedBox(
                          width: Screen.width(context) * 0.9,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Budget',
                                  style: heading,
                                ),
                                Text(events['EventDetail']['budget'].toString(),
                                    style: text)
                              ],
                            ),
                            SizedBox(height: Screen.height(context) * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Event Type', style: heading),
                                Text(events['EventDetail']['type'], style: text)
                              ],
                            ),
                            SizedBox(height: Screen.height(context) * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Guests', style: heading),
                                Text(
                                    '${events['EventDetail']['guestsmin'].toString()} - ${events['EventDetail']['guestsmax'].toString()}',
                                    style: text)
                              ],
                            ),
                            SizedBox(height: Screen.height(context) * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Date', style: heading),
                                Text(events['EventDetail']['date'], style: text)
                              ],
                            ),
                            SizedBox(height: Screen.height(context) * 0.01),
                          ]),
                        ),
                        SizedBox(height: Screen.height(context) * 0.02),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Function12(
                              delete: () async {
                                final response = await MyApi.postRequest(
                                    endpoint: 'DeleteFunction/',
                                    headers: {
                                      'Authorization': 'Bearer $token'
                                    },
                                    body: {
                                      'FunctionId': events['Functions'][index]
                                              ['id']
                                          .toString(),
                                    });
                                if (response['status'] == 'success') {
                                  MyScaffold(
                                          text: 'Function Deleted Successfully')
                                      .show(context);
                                  setState(() {
                                    events["Functions"].removeAt(index);
                                  });
                                } else {
                                  MyScaffold(text: 'Something Went Wrong!')
                                      .show(context);
                                }
                              },
                              color: Color(int.parse(
                                  '0xff${events["EventDetail"]["themeColor"].substring(1, events["EventDetail"]["themeColor"].length)}')),
                              name: events['Functions'][index]['name'],
                              type: events['Functions'][index]['type'],
                              head: 'Budget',
                              budget: events['Functions'][index]['budget']
                                  .toString(),
                              headings: ['Date'],
                              values: [events['Functions'][index]['date']],
                              editPressed: () {
                                Navigator.pushNamed(context, '/EditFunction',
                                    arguments: {
                                      'functionId': events['Functions'][index]
                                              ['id']
                                          .toString(),
                                      'eventId': EventId,
                                      'type': events['EventDetail']['type']
                                    });
                              },
                              seePressed: () {
                                Navigator.pushNamed(context, '/FunctionDetail',
                                    arguments: {
                                      'eventid': EventId,
                                      'event': events['EventDetail']['name'],
                                      'fid': events['Functions'][index]['id']
                                    });
                              },
                            );
                          },
                          itemCount: events['Functions'] != null
                              ? events['Functions'].length
                              : 0,
                        ),
                        Container(
                          margin: EdgeInsets.all(Screen.max(context) * 0.01),
                          padding: EdgeInsets.symmetric(
                              vertical: Screen.height(context) * 0.01,
                              horizontal: Screen.width(context) * 0.03),
                          decoration: BoxDecoration(
                              color: MyColors.DarkLighter,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ]),
                          width: Screen.width(context) * 0.8,
                          child: InkWell(
                              onTap: () async {
                                final response = await MyApi.postRequest(
                                    endpoint: 'show/guest/',
                                    headers: {
                                      'Authorization': 'Bearer $token'
                                    },
                                    body: {
                                      'EventId': EventId,
                                      'FunctionID': "None"
                                    });
                                if (response["Guests"].length == 0) {
                                  Navigator.pushNamed(
                                      context, '/CreateGuestList',
                                      arguments: {
                                        'eventId': EventId,
                                      });
                                } else {
                                  Navigator.pushNamed(
                                      context, '/CreateGuestList_List',
                                      arguments: {
                                        'eventId': EventId,
                                      });
                                }
                              },
                              child: Text("Event GuestList")),
                        ),
                        Container(
                          margin: EdgeInsets.all(Screen.max(context) * 0.01),
                          padding: EdgeInsets.symmetric(
                              vertical: Screen.height(context) * 0.01,
                              horizontal: Screen.width(context) * 0.03),
                          decoration: BoxDecoration(
                              color: MyColors.DarkLighter,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ]),
                          width: Screen.width(context) * 0.8,
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/CreateChecklistItems',
                                    arguments: {
                                      'eventId': EventId,
                                    });
                              },
                              child: Text("Event CheckLlist")),
                        ),
                        Container(
                          margin: EdgeInsets.all(Screen.max(context) * 0.01),
                          padding: EdgeInsets.symmetric(
                              vertical: Screen.height(context) * 0.01,
                              horizontal: Screen.width(context) * 0.03),
                          decoration: BoxDecoration(
                              color: MyColors.DarkLighter,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ]),
                          width: Screen.width(context) * 0.8,
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/InvitationCardEdit');
                              },
                              child: Text("View Invitation Card")),
                        ),
                        SizedBox(
                          height: Screen.height(context) * 0.1,
                          child: Center(child: MyDivider()),
                        ),
                        ColoredButton(
                          text: 'Create New Function',
                          onPressed: () {
                            Navigator.pushNamed(context, '/CreateFunction',
                                arguments: {
                                  'eventId': EventId,
                                  'type': events['EventDetail']['type']
                                });
                          },
                        ),
                      ],
                    )
            ]),
          ),
          Positioned(
            top: 0,
            child: Header(),
          ),
        ],
      ),
    );
  }
}
