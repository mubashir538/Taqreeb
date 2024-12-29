import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/Components/my%20divider.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';
import 'package:taqreeb/theme/images.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String token = '';
  Map<String, dynamic> events = {}; // Initialize as empty map
  late int EventId;
  bool isLoading = true; // Add a loading flag

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      EventId = args;
    });
    fetchData();
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";

    final Event = await MyApi.getRequest(
      endpoint: 'eventdetails/${this.EventId}',
      headers: {'Authorization': 'Bearer $token'},
    );

    // Update the state
    setState(() {
      this.token = token;
      this.events = Event ?? {}; // Ensure no null data
        if (Event == null || Event['status'] == 'error') {
        print('$Event');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something Went Wrong!',
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: MyColors.white,
                  fontWeight: FontWeight.w400)),
          backgroundColor: MyColors.red,
        ));
        return;
      } else {
        isLoading = false;
      }
    });
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderObject? renderBox =
        _headerKey.currentContext?.findRenderObject();

    if (renderBox is RenderBox) {
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextStyle heading = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.017,
        fontWeight: FontWeight.w600,
        color: MyColors.Yellow);

    TextStyle text = GoogleFonts.montserrat(
        fontSize: MaximumThing * 0.017,
        fontWeight: FontWeight.w400,
        color: MyColors.white);
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: _headerHeight),
              SizedBox(height: screenHeight * 0.03),
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
                              fontSize: MaximumThing * 0.03,
                              fontWeight: FontWeight.w700,
                              color: MyColors.Yellow),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        SizedBox(
                          width: screenWidth * 0.9,
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
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Event Type', style: heading),
                                Text(events['EventDetail']['type'], style: text)
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Guests', style: heading),
                                Text(
                                    '${events['EventDetail']['guestsmin'].toString()} - ${events['EventDetail']['guestsmax'].toString()}',
                                    style: text)
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Date', style: heading),
                                Text(events['EventDetail']['date'], style: text)
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                          ]),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Function12(
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
                          margin: EdgeInsets.all(MaximumThing * 0.01),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.03),
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
                          width: screenWidth * 0.8,
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
                              child: Text("View GuestList")),
                        ),

                        Container(
                          margin: EdgeInsets.all(MaximumThing * 0.01),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.03),
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
                          width: screenWidth * 0.8,
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/CreateChecklistItems',
                                    arguments: {
                                      'eventId': EventId,
                                    });
                              },
                              child: Text("View CheckLlist")),
                        ),

                        // Container(
                        //   margin: EdgeInsets.all(MaximumThing * 0.01),
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: screenHeight * 0.01,
                        //       horizontal: screenWidth * 0.03),
                        //   decoration: BoxDecoration(
                        //       color: MyColors.DarkLighter,
                        //       borderRadius: BorderRadius.circular(10),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black.withOpacity(0.5),
                        //           spreadRadius: 5,
                        //           blurRadius: 4,
                        //           offset: Offset(2, 2),
                        //         ),
                        //       ]),
                        //   width: screenWidth * 0.8,
                        //   child: InkWell(
                        //       onTap: () {
                        //         Navigator.pushNamed(context, '/InvitationCardEdit');
                        //       },
                        //       child: Text("View Invitation Card")),
                        // ),

                        SizedBox(
                          height: screenHeight * 0.1,
                          child: Center(child: MyDivider()),
                        ),

                        //Colored Button
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
            child: Header(
              key: _headerKey,
              heading: "Your Event Details",
              image: MyImages.EventDetails,
            ),
          ),
        ],
      ),
    );
  }
}
