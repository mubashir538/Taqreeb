import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';

class UserBookings extends StatefulWidget {
  const UserBookings({super.key});

  @override
  State<UserBookings> createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings> {
  bool isloading = true;
  List<Map<String, dynamic>> bookings = [];
  final GlobalKey headerKey = GlobalKey();

  Map<String, List<Map<String, dynamic>>> groupedData = {
    'Today': [],
    'Yesterday': [],
    'This Month': [],
    'This Year': [],
    'Previous': []
  };

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    bookings = args['data'];
  }

  void fetchdata() async {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));
    String thisMonth = DateFormat('yyyy-MM').format(now);
    String thisYear = DateFormat('yyyy').format(now);

    Map<String, List<Map<String, dynamic>>> tempGroupedData = {
      'Today': [],
      'Yesterday': [],
      'This Month': [],
      'This Year': [],
      'Previous': []
    };

    for (var booking in bookings) {
      DateTime transactionDate = DateTime.parse(
          booking['date']); // Ensure your DB returns a valid date string
      String formattedDate = DateFormat('yyyy-MM-dd').format(transactionDate);
      String formattedMonth = DateFormat('yyyy-MM').format(transactionDate);
      String formattedYear = DateFormat('yyyy').format(transactionDate);

      if (formattedDate == today) {
        tempGroupedData['Today']!.add(booking);
      } else if (formattedDate == yesterday) {
        tempGroupedData['Yesterday']!.add(booking);
      } else if (formattedMonth == thisMonth) {
        tempGroupedData['This Month']!.add(booking);
      } else if (formattedYear == thisYear) {
        tempGroupedData['This Year']!.add(booking);
      } else {
        tempGroupedData['Previous']!.add(booking);
      }
    }

    setState(() {
      groupedData = tempGroupedData;
      isloading = false;
    });
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UI_Management.headerHeight = renderBox.size.height);
    }
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('MMM d,yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
        body: Stack(children: [
      SizedBox(
        width: Screen.width(context),
        child: SingleChildScrollView(child: Column()),
      ),
      Positioned(
          top: 0,
          child: Header(
            key: headerKey,
            heading: 'Your Bookings',
          ))
    ]));
  }
}
