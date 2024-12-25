import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/Components/Message%20Chats.dart';
import 'package:taqreeb/Components/guests.dart';
import 'package:taqreeb/Components/header.dart';
import 'package:taqreeb/theme/color.dart';
import 'package:taqreeb/theme/icons.dart';

class CreateGuestList_List extends StatefulWidget {
  const CreateGuestList_List({super.key});

  @override
  State<CreateGuestList_List> createState() => _CreateGuestList_ListState();
}

class _CreateGuestList_ListState extends State<CreateGuestList_List> {
  String token = '';
  Map<String, dynamic> guests = {}; // Initialize as empty map
  Map<String, dynamic> args = {};
  bool isfunction = false;
  int functionid = 0;
  int eventId = 0;
  bool isLoading = true; // Add a loading flag
@override
  void initState() {
    super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) => _getHeaderHeight());
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    this.args = args;
    setState(() {
      if (args['functionid'] != null) {
        isfunction = true;
        functionid = args['functionid'];
      }
      eventId = args['eventId'];
    });
    fetchData(); // Fetch data in a separate method
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken('accessToken') ?? "";
    final fetchedGuests = await MyApi.postRequest(
      endpoint: 'show/guest/',
      body: {
        'EventId': eventId,
        'FunctionID': isfunction ? functionid : "None"
      },
      //  headers: {
      //   'Authorization': 'Bearer $token',
      // }
    );

    // Update the state
    setState(() {
      this.token = token;
      this.guests = fetchedGuests ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
    });
  }

  void _showOptions(BuildContext context, double maxThing, double width) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(maxThing * 0.02),
          decoration: BoxDecoration(
            color: MyColors.DarkLighter,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(maxThing * 0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ColoredButton(
                      text: 'Add Person',
                      width: width * 0.4,
                      textSize: maxThing * 0.015,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, '/CreateGuestList_AddPerson',
                            arguments: args);
                      }),
                  ColoredButton(
                      text: 'Add Family',
                      width: width * 0.4,
                      textSize: maxThing * 0.015,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                            context, '/CreateGuestList_AddFamily',
                            arguments: args);
                      }),
                ],
              ),
              SizedBox(height: maxThing * 0.03), // Space below the buttons
            ],
          ),
        );
      },
    );
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
    _getHeaderHeight();
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    SizedBox(
                      height: _headerHeight,
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(MyColors.white),
                            ),
                          )
                        : SizedBox(
                            width: screenWidth * 0.9,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: guests['Guests'].length,
                              itemBuilder: (context, index) {
                                return Guests(
                                  onpressed: () {},
                                  ondelete: () {},
                                  name: guests['Guests'][index]['name'] ?? '',
                                  contact: guests['Guests'][index]['type'] ==
                                          "Family"
                                      ? guests['Guests'][index]['members']
                                          .toString()
                                      : guests['Guests'][index]['phone'],
                                );
                              },
                            ),
                          ),
                  ]),
                ],
              ),
            ),
          ),
          Header(
            key: _headerKey,
            heading: 'Guest List',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.Yellow,
        onPressed: () => _showOptions(context, MaximumThing, screenWidth),
        child: Icon(
          Icons.add,
          color: MyColors.Dark,
          size: MaximumThing * 0.04,
        ),
      ),
    );
  }
}
