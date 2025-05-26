import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    final colors = AppColors(context);
    final isBooked = _isBooked(day);
    final isSelected = _isSelected(day);
    final isToday = isSameDay(day, DateTime.now());
    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    Color backgroundColor = Colors.transparent;
    Color textColor = isWeekend ? colors.red : colors.white;
    Border? border;

    if (isToday) {
      border = Border.all(color: colors.red, width: 1.5);
    }

    if (isBooked) {
      backgroundColor = colors.red;
      textColor = colors.white;
    }

    if (isSelected) {
      backgroundColor = colors.red;
      textColor = colors.white;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 14,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.dark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with month/year and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(FontAwesomeIcons.chevronLeft,
                    color: colors.white, size: 16),
                onPressed: () {
                  setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month - 1);
                  });
                },
              ),
              Text(
                '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                style: GoogleFonts.poppins(
                  color: colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.chevronRight,
                    color: colors.white, size: 16),
                onPressed: () {
                  setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month + 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((day) => Text(
                      day,
                      style: GoogleFonts.poppins(
                        color: day == 'S' ? colors.red : colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => widget.isSelectionMode
                ? _isSelected(day)
                : isSameDay(_selectedDay, day),
            onDaySelected: _handleDateSelection,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerVisible: false,
            daysOfWeekVisible: false,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              selectedDecoration: BoxDecoration(
                color: colors.red,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: GoogleFonts.poppins(color: colors.white),
              weekendTextStyle: GoogleFonts.poppins(color: colors.red),
              todayTextStyle: GoogleFonts.poppins(
                color: colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                  opacity: 0.3,
                  child: _buildDayWidget(day, focusedDay),
                );
              },
              outsideBuilder: (context, day, focusedDay) {
                return Opacity(
                  opacity: 0.3,
                  child: _buildDayWidget(day, focusedDay),
                );
              },
            ),
          ),

          // Legend/instructions
          if (widget.isSelectionMode) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Selected/Booked dates',
                  style: GoogleFonts.poppins(
                    color: colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Today',
                  style: GoogleFonts.poppins(
                    color: colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
