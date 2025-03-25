import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_calendar.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategorySlots extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Map listing;
  
  const CategorySlots({
    super.key, 
    required this.listing, 
    required this.onDateSelected,
  });

  @override
  State<CategorySlots> createState() => _CategorySlotsState();
}

class _CategorySlotsState extends State<CategorySlots> {
  List<DateTime> _parseBookedDates() {
    return widget.listing['bookedDates']
        .map<DateTime>((date) => DateTime.parse(date))
        .toList();
  }

  TextStyle _buildTitleStyle() {
    return GoogleFonts.montserrat(
      fontSize: Screen.max(context) * 0.025,
      fontWeight: FontWeight.w600,
      color: MyColors.Yellow,
    );
  }

  EdgeInsets _buildCalendarMargin() {
    return EdgeInsets.symmetric(
      vertical: Screen.max(context) * 0.02,
      horizontal: Screen.max(context) * 0.01,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Available Slots',
          style: _buildTitleStyle(),
        ),
        Container(
          margin: _buildCalendarMargin(),
          child: CalendarView(
            onDateSelected: widget.onDateSelected,
            bookedDates: _parseBookedDates(),
          ),
        ),
      ],
    );
  }
}