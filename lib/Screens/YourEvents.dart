import 'package:flutter/material.dart';
import 'package:taqreeb/Classes/api.dart';
import 'package:taqreeb/Classes/flutterStorage.dart';
import 'package:taqreeb/Components/Header.dart';
import 'package:taqreeb/Components/Search%20Box.dart';
import 'package:taqreeb/Components/function.dart';
import 'package:taqreeb/theme/color.dart';

class YourEvents extends StatefulWidget {
  const YourEvents({super.key});

  @override
  State<YourEvents> createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  String token = '';
  Map<String, dynamic> events = {}; // Initialize as empty map

  bool isLoading = true; // Add a loading flag

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data in a separate method
  }

  void fetchData() async {
    // Perform asynchronous operations
    final token = await MyStorage.getToken('accessToken') ?? "";
    final String id = await MyStorage.getToken('userId') ?? "";

    print(id);
    final fetchedEvents = await MyApi.getRequest(endpoint: 'YourEvents/$id');

    // Update the state
    setState(() {
      this.token = token;
      this.events = fetchedEvents ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
      print('Events: $events');
    });
  }

  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.0;
  void _getHeaderHeight() {
    final RenderBox renderBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _headerHeight = renderBox.size.height;
    });
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: _headerHeight),
                Container(
                  margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
                  child: SearchBox(
                      onChanged: (value) {},
                      controller: controller,
                      hint: 'Search Typing to Search',
                      width: screenWidth * 0.9),
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(MyColors.white),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: events["Event"].length,
                        itemBuilder: (context, index) => Function12(
                          color: Color(int.parse(
                              '0xff${events["Event"][index]["themeColor"].substring(1, events["Event"][index]["themeColor"].length)}')),
                          name: events["Event"][index]["name"],
                          head: 'Budget',
                          budget: events["Event"][index]["budget"].toString(),
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
                                arguments:
                                    events["Event"][index]["id"].toString());
                          },
                        ),
                      )
              ],
            ),
          ),
          Positioned(
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
