import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Classes/tokens.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/theme/color.dart';

class YourEvents extends StatefulWidget {
  const YourEvents({super.key});

  @override
  State<YourEvents> createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  String token = '';
  Map<String, dynamic> events = {};
  Timer? _timer;
  bool isLoading = true;
  bool fetched = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
    fetchData();
  }

  void fetchData() async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";

    final fetchedEvents = await MyApi.getRequest(
      endpoint: 'YourEvents/$id',
      headers: {'Authorization': 'Bearer $token'},
    );

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (fetchedEvents == null || fetchedEvents['status'] == 'error') {
            fetched = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Something Went Wrong!',
                style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: 15,
                ),
              ),
              backgroundColor: MyColors.red,
            ));
          }
          this.token = token;
          this.events = fetchedEvents ?? {};
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          fetched
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: _headerHeight),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                        child: SearchBox(
                            onChanged: (value) {},
                            controller: controller,
                            hint: 'Search Typing to Search',
                            width: screenWidth * 0.9),
                      ),
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    MyColors.white),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: events["Event"].length,
                              itemBuilder: (context, index) => Function12(
                                delete: () async {
                                  final response = await MyApi.postRequest(
                                      endpoint: 'DeleteEvent/',
                                      headers: {
                                        'Authorization': 'Bearer $token'
                                      },
                                      body: {
                                        'EventId': events["Event"][index]["id"]
                                            .toString(),
                                      });
                                  if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Event Deleted Successfully',
                                        style: GoogleFonts.montserrat(
                                          color: MyColors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      backgroundColor: MyColors.green,
                                    ));
                                    setState(() {
                                      events["Event"].removeAt(index);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Something Went Wrong!',
                                        style: GoogleFonts.montserrat(
                                          color: MyColors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                      backgroundColor: MyColors.red,
                                    ));
                                  }
                                },
                                color: Color(int.parse(
                                    '0xff${events["Event"][index]["themeColor"].substring(1, events["Event"][index]["themeColor"].length)}')),
                                name: events["Event"][index]["name"],
                                head: 'Budget',
                                budget:
                                    events["Event"][index]["budget"].toString(),
                                headings: [
                                  'Event Type',
                                  'Functions',
                                  'Date',
                                ],
                                values: [
                                  events["Event"][index]["type"],
                                  events["nofunctions"][index].toString(),
                                  events["Event"][index]["date"],
                                ],
                                type: 'Event',
                                seePressed: () {
                                  Navigator.pushNamed(context, '/EventDetails',
                                      arguments: events["Event"][index]["id"]);
                                },
                                editPressed: () {
                                  Navigator.pushNamed(context, '/EditEvent',
                                      arguments: events["Event"][index]["id"]
                                          .toString());
                                },
                              ),
                            )
                    ],
                  ),
                )
              : Container(),
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
}
