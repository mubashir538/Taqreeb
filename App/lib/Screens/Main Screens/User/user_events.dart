import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
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
            MyScaffold(text: 'Something Went Wrong!').show(context);
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
                        margin: EdgeInsets.symmetric(
                            vertical: Screen.max(context) * 0.02),
                        child: SearchBox(
                            onChanged: (value) {},
                            controller: controller,
                            hint: 'Search Typing to Search',
                            width: Screen.width(context) * 0.9),
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
                                    MyScaffold(
                                            text: 'Event Deleted Successfully')
                                        .show(context);
                                    setState(() {
                                      events["Event"].removeAt(index);
                                    });
                                  } else {
                                    MyScaffold(text: 'Something Went Wrong!')
                                        .show(context);
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
