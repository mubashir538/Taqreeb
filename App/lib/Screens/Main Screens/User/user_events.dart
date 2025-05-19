import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Cards/c_function_card.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
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
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> _events = {};
  bool _isLoading = true;
  final GlobalKey _headerKey = GlobalKey();
  List<dynamic> _filteredEvents = [];
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeHeaderHeight();
    _fetchData();
  }

  void _initializeHeaderHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: (renderbox) {
          _changeHeight(renderbox);
        },
      );
    });
  }

  void _searchEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = List.from(_events["Event"]);
      } else {
        _filteredEvents = _events["Event"]
            .where((event) =>
                event["name"].toLowerCase().contains(query.toLowerCase()) ||
                event["type"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _fetchData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    await ApiCall.fetchAPI('YourEvents/$userId', refresh: true,
        onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          _events = data;
          _filteredEvents = List.from(data["Event"]);
          _isLoading = false;
        });
      }
    }, context: mounted ? context : null);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _deleteEvent(int eventId, int index) async {
    final response = await MyApi.postRequest(
      endpoint: 'DeleteEvent/',
      context: mounted ? context : null,
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      body: {'EventId': eventId.toString()},
    );

    if (response['status'] == 'success') {
      final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      await MyApi.deleteCache('YourEvents/$userId');
      _fetchData();
      if (mounted) {
        MyScaffold(text: 'Event Deleted Successfully').show(context);
      }
      setState(() {
        _events["Event"].removeAt(index);
      });
    } else {
      if (mounted) {
        MyScaffold(text: 'Something Went Wrong!').show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderbox) {
        _changeHeight(renderbox);
      },
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: UImanagement.headerHeight),
                _buildSearchBox(),
                _isLoading ? _buildLoadingIndicator() : _buildEventList(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: 'Your Events',
              additionalIcons: [
                HeaderIcon(
                    icon: FontAwesomeIcons.heart,
                    onPressed: () {
                      context.pushNamedTransition(
                          routeName: '/Wishlist',
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: 300));
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
      child: SearchBox(
        focusNode: searchFocus,
        onclick: () {
          searchFocus.requestFocus();
        },
        onChanged: (value) {
          _searchEvents(value); // Call the search method
        },
        controller: _searchController,
        hint: 'Search Typing to Search',
        width: Screen.width(context) * 0.9,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return _buildSkeletonLoader();
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Screen.width(context) * 0.05),
      child: Column(
        children: List.generate(
          5, // Number of skeleton items to show
          (index) => _buildSkeletonItem(),
        ),
      ),
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: EdgeInsets.only(bottom: Screen.height(context) * 0.02),
      child: Shimmer.fromColors(
        baseColor: MyColors.ligthDark.withOpacity(0.6),
        highlightColor: MyColors.ligthDark.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title placeholder
            Container(
              width: Screen.width(context) * 0.6,
              height: Screen.height(context) * 0.03,
              color: Colors.white,
            ),
            SizedBox(height: Screen.height(context) * 0.01),

            // Budget placeholder
            Container(
              width: Screen.width(context) * 0.4,
              height: Screen.height(context) * 0.02,
              color: Colors.white,
            ),
            SizedBox(height: Screen.height(context) * 0.02),

            // Three info placeholders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Screen.width(context) * 0.2,
                  height: Screen.height(context) * 0.02,
                  color: Colors.white,
                ),
                Container(
                  width: Screen.width(context) * 0.2,
                  height: Screen.height(context) * 0.02,
                  color: Colors.white,
                ),
                Container(
                  width: Screen.width(context) * 0.2,
                  height: Screen.height(context) * 0.02,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: Screen.height(context) * 0.02),

            // Button placeholders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Screen.width(context) * 0.2,
                  height: Screen.height(context) * 0.04,
                  color: Colors.white,
                ),
                Container(
                  width: Screen.width(context) * 0.2,
                  height: Screen.height(context) * 0.04,
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: Screen.height(context) * 0.02),

            // Divider
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (_filteredEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Screen.height(context) * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.02),
              child: Text(
                'No Events Found',
                style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.02,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_events["Event"].length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Screen.height(context) * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.02),
              child: Text(
                'You currently don\'t have any events for this Name',
                style: GoogleFonts.roboto(
                  fontSize: Screen.max(context) * 0.02,
                  fontWeight: FontWeight.w400,
                  color: MyColors.white,
                ),
              ),
            ),
            SizedBox(height: Screen.height(context) * 0.03),
            ColoredButton(
              onPressed: () {
                // Navigate to the screen where user can add a new event
                context.pushNamedTransition(
                    routeName: '/AddEvent',
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: Duration(milliseconds: 300));
              },
              text: 'Add your first event',
              width: Screen.width(context) * 0.5,
              textSize: Screen.max(context) * 0.015,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return FunctionCard(
          delete: () => _deleteEvent(event["id"], index),
          color: MyColors.red,
          name: event["name"],
          head: 'Budget',
          budget: event["budget"].toString(),
          headings: ['Event Type', 'Functions', 'Date'],
          values: [
            event["type"],
            _events["nofunctions"][index].toString(),
            DateFormat('MMMM d, y')
                .format(DateTime.parse(event["date"]))
                .toString(),
          ],
          type: 'Event',
          seePressed: () {
            context.pushNamedTransition(
                routeName: '/EventDetails',
                type: PageTransitionType.rightToLeftWithFade,
                duration: Duration(milliseconds: 300),
                arguments: event["id"]);
          },
          editPressed: () {
            context.pushNamedTransition(
                routeName: '/EditEvent',
                type: PageTransitionType.rightToLeftWithFade,
                duration: Duration(milliseconds: 300),
                arguments: event["id"].toString());
          },
        );
      },
    );
  }
}
