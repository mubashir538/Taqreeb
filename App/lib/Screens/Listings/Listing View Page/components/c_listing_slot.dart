import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategorySlots extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final List<DateTime> bookedDates;
  final bool isSelectionMode;

  const CategorySlots({
    super.key,
    required this.onDateSelected,
    required this.bookedDates,
    this.isSelectionMode = false,
  });

  @override
  State<CategorySlots> createState() => _CategorySlotsState();
}

class _CategorySlotsState extends State<CategorySlots> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
  }

  bool _isBooked(DateTime day) {
    return widget.bookedDates.any((date) =>
        date.year == day.year &&
        date.month == day.month &&
        date.day == day.day);
  }

  Widget _buildDayWidget(DateTime day, DateTime focusedDay) {
    final isBooked = _isBooked(day);
    final isSelected = _selectedDay != null &&
        _selectedDay!.year == day.year &&
        _selectedDay!.month == day.month &&
        _selectedDay!.day == day.day;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isBooked
            ? MyColors.yellow.withAlpha(77)
            : isSelected
                ? MyColors.yellow.withAlpha(153)
                : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.montserrat(
            color: isBooked || isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleTextStyle: GoogleFonts.montserrat(
          color: MyColors.yellow,
          fontSize: Screen.max(context) * 0.025,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: MyColors.yellow,
          size: Screen.max(context) * 0.04,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: MyColors.yellow,
          size: Screen.max(context) * 0.04,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: GoogleFonts.montserrat(
          color: MyColors.yellow,
          fontSize: Screen.max(context) * 0.02,
        ),
        weekendStyle: GoogleFonts.montserrat(
          color: MyColors.yellow,
          fontSize: Screen.max(context) * 0.02,
        ),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: GoogleFonts.montserrat(
          color: Colors.white,
        ),
        weekendTextStyle: GoogleFonts.montserrat(
          color: Colors.white,
        ),
        outsideTextStyle: GoogleFonts.montserrat(
          color: Colors.grey,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey.withAlpha(128),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: MyColors.yellow,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: MyColors.yellow,
          shape: BoxShape.circle,
        ),
        // dayDecoration: (date, isSelected, isToday, isBooked) {
        //   return BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: isBooked
        //         ? MyColors.yellow.withOpacity(0.3)
        //         : isSelected
        //             ? MyColors.yellow
        //             : isToday
        //                 ? Colors.grey.withOpacity(0.5)
        //                 : Colors.transparent,
        //   );
        // },
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!widget.isSelectionMode) return;

        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
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
      ),
    );
  }
}
