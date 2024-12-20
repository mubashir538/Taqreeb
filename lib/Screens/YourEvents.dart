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

    final fetchedEvents = await MyApi.getRequest(endpoint: 'YourEvents/$id');

    // Update the state
    setState(() {
      this.token = token;
      this.events = fetchedEvents ?? {}; // Ensure no null data
      isLoading = false; // Data has been fetched, so stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: 'Your Events',
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
              child:
                  SearchBox(controller: controller, width: screenWidth * 0.9),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events["Event"].length,
                    itemBuilder: (context, index) => Function12(
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
                            arguments: events["Event"][index]["id"].toString());
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
