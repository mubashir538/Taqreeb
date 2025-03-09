import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/calendar.dart';
import 'package:taqreeb/theme/color.dart';


class CategorySlots extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Map listing;
  const CategorySlots(
      {super.key, required this.listing, required this.onDateSelected});

  @override
  State<CategorySlots> createState() => _CategorySlotsState();
}

class _CategorySlotsState extends State<CategorySlots> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double maximumDimension =
        screenWidth > screenHeight ? screenWidth : screenHeight;
    return Column(
      children: [
        Text(
          'Available Slots',
          style: GoogleFonts.montserrat(
            fontSize: maximumDimension * 0.025,
            fontWeight: FontWeight.w600,
            color: MyColors.Yellow,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: maximumDimension * 0.02,
              horizontal: maximumDimension * 0.01),
          child: CalendarView(
            onDateSelected: widget.onDateSelected,
            bookedDates: widget.listing['bookedDates']
                .map((date) {
                  return DateTime.parse(date);
                })
                .cast<DateTime>()
                .toList(),
          ),
        ),
      ],
    );
  }
}
