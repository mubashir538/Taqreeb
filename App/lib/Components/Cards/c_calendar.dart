import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taqreeb/core/utils/color.dart';

class CalendarView extends StatefulWidget {
  final List<DateTime> bookedDates;
  final Function(DateTime) onDateSelected;
  final bool isSelectionMode;

  const CalendarView({
    super.key,
    required this.bookedDates,
    required this.onDateSelected,
    this.isSelectionMode = false,
  });

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _selectedDates = {};

  bool _isBooked(DateTime day) {
    return widget.bookedDates.any((bookedDate) => isSameDay(bookedDate, day));
  }

  bool _isSelected(DateTime day) {
    return _selectedDates.any((selectedDate) => isSameDay(selectedDate, day));
  }

  void _handleDateSelection(DateTime selectedDay, DateTime focusedDay) {
    if (widget.isSelectionMode) {
      setState(() {
        if (_selectedDates.any((date) => isSameDay(date, selectedDay))) {
          _selectedDates.removeWhere((date) => isSameDay(date, selectedDay));
        } else {
          _selectedDates.add(selectedDay);
        }
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    } else {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }

    widget.onDateSelected(selectedDay);
  }

  Widget _buildDayWidget(DateTime day, DateTime focusedDay) {
    final isBooked = _isBooked(day);
    final isSelected = _isSelected(day);
    final isToday = isSameDay(day, DateTime.now());

    Color backgroundColor = Colors.transparent;
    Color textColor = MyColors.white;

    if (isToday) {
      backgroundColor = MyColors.red;
    }

    if (isBooked) {
      backgroundColor = MyColors.red;
      textColor = MyColors.white;
    }

    if (isSelected) {
      backgroundColor = MyColors.yellow;
      textColor = Colors.black;
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.roboto(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => widget.isSelectionMode
              ? _isSelected(day)
              : isSameDay(_selectedDay, day),
          onDaySelected: _handleDateSelection,
          calendarFormat: CalendarFormat.month,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: MyColors.red,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: MyColors.yellow,
              shape: BoxShape.rectangle,
            ),
            defaultTextStyle: GoogleFonts.roboto(color: MyColors.white),
            weekendTextStyle: GoogleFonts.roboto(color: MyColors.red),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: MyColors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: MyColors.white),
            titleTextStyle: GoogleFonts.roboto(
              color: MyColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.roboto(color: MyColors.white),
            weekendStyle: GoogleFonts.roboto(color: MyColors.white),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return _buildDayWidget(day, focusedDay);
            },
            todayBuilder: (context, day, focusedDay) {
              return _buildDayWidget(day, focusedDay);
            },
            selectedBuilder: (context, day, focusedDay) {
              return _buildDayWidget(day, focusedDay);
            },
            disabledBuilder: (context, day, focusedDay) {
              return Opacity(
                opacity: 0.5,
                child: _buildDayWidget(day, focusedDay),
              );
            },
          ),
        ),
        if (widget.isSelectionMode) ...[
          const SizedBox(height: 16),
          Text(
            'Tap dates to select/unselect',
            style: GoogleFonts.roboto(
              color: MyColors.yellow,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Booked dates are shown in red',
            style: GoogleFonts.roboto(
              color: MyColors.red,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
