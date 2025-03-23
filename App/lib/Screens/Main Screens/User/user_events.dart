import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
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
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => UI_Management.getHeaderHeight(
            headerKey: headerKey,
            callback: (renderbox) {
              changeHeight(renderbox);
            }));
    fetchData();
  }

  void fetchData() async {
    final String id = await MyStorage.getToken(MyTokens.userId) ?? "";
    ApiCall.fetchAPI('YourEvents/$id', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          this.token = token;
          events = data;
          isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void changeHeight(RenderBox renderbox) {
    setState(() {
      UI_Management.headerHeight = renderbox.size.height;
    });
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          changeHeight(renderbox);
        });
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          fetched
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: UI_Management.headerHeight),
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
              key: headerKey,
              heading: 'Your Events',
            ),
          ),
        ],
      ),
    );
  }
}
