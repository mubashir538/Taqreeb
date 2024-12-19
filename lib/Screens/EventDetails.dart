import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
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
  void initState() {
    super.initState();
  }

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
    final token = await MyStorage.getToken('accessToken') ?? "";

    final Event =
        await MyApi.getRequest(endpoint: 'eventdetails/${this.EventId}');

    // Update the state
    setState(() {
      this.token = token;
      this.events = Event ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
    });
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Header(
            heading: "Your Event Details",
            image: MyImages.EventDetails,
          ),
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
                        events = events['EventDetail']['Functions'];
                        return Function12(
                          name: events[index]['name'],
                          type: events[index]['type'],
                          head: 'Budget',
                          budget: events[index]['budget'].toString(),
                          headings: ['Date'],
                          values: [events[index]['date']],
                          editPressed: () {
                            Navigator.pushNamed(context, '/EditFunction',
                                arguments: events[index]['id']);
                          },
                          seePressed: () {
                            Navigator.pushNamed(context, '/FunctionDetails',
                                arguments: events[index]['id']);
                          },
                        );
                      },
                      itemCount: events['EventDetail']['Functions'] != null
                          ? events['EventDetail']['Functions'].length
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
                          onTap: () {
                            Navigator.pushNamed(context, '/CreateGuestList');
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
                                context, '/CreateChecklistItems');
                          },
                          child: Text("View CheckLlist")),
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
                            Navigator.pushNamed(context, '/InvitationCardEdit');
                          },
                          child: Text("View Invitation Card")),
                    ),

                    //icon (yh call ni horha)
                    Container(
                      margin: EdgeInsets.all(MaximumThing * 0.02),
                      width: screenWidth * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            MyIcons.add,
                            color: MyColors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.1,
                      child: Center(child: MyDivider()),
                    ),

                    //Colored Button
                    ColoredButton(
                      text: 'Create Function',
                      onPressed: () {
                        Navigator.pushNamed(context, '/CreateFunction');
                      },
                    ),
                  ],
                )
        ]),
      ),
    );
  }
}
