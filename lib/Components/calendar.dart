import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taqreeb/theme/color.dart';

class CalendarView extends StatefulWidget {
  final List<DateTime> bookedDates; // List of booked dates
  final Function(DateTime) onDateSelected; // Callback function
  const CalendarView(
      {Key? key, required this.bookedDates, required this.onDateSelected})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: DateTime.now(), // Start from today's date
          lastDay:
              DateTime.now().add(const Duration(days: 365)), // One year ahead
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update focusedDay
            });
            widget.onDateSelected(selectedDay);
          },
          calendarFormat: CalendarFormat.month,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: MyColors.red,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: MyColors.Yellow,
              shape: BoxShape.rectangle,
            ),
            defaultTextStyle: GoogleFonts.montserrat(color: MyColors.white),
            weekendTextStyle: GoogleFonts.montserrat(color: MyColors.red),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: MyColors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: MyColors.white),
            titleTextStyle:
                GoogleFonts.montserrat(color: MyColors.white, fontSize: 20),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              if (widget.bookedDates
                  .any((bookedDate) => isSameDay(bookedDate, day))) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.red,
                      shape: BoxShape.circle,
                    ),
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.montserrat(color: MyColors.white),
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
