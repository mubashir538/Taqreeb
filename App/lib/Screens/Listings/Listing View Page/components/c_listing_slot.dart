import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  bool _isBooked(DateTime day) {
    return widget.bookedDates.any((date) => isSameDay(date, day));
  }

  Widget _buildDayWidget(DateTime day, DateTime focusedDay) {
    final isBooked = _isBooked(day);
    final isSelected = isSameDay(_selectedDay, day);
    final isToday = isSameDay(day, DateTime.now());
    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    final colors = AppColors(context);

    Color backgroundColor = Colors.transparent;
    Color textColor = isWeekend ? colors.red : colors.white;
    Border? border;

    if (isToday) {
      border = Border.all(
        color: colors.red,
        width: Screen.max(context) * 0.003,
      );
    }

    if (isBooked) {
      backgroundColor = colors.red.withAlpha(179);
      textColor = colors.white;
    }

    if (isSelected) {
      backgroundColor = colors.red;
      textColor = colors.white;
    }

    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.005),
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
            fontSize: Screen.max(context) * 0.018,
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
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: colors.dark.withAlpha(204),
        borderRadius: BorderRadius.circular(Screen.max(context) * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with month/year and navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: colors.white,
                  size: Screen.max(context) * 0.025,
                ),
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
                  fontSize: Screen.max(context) * 0.025,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.chevronRight,
                  color: colors.white,
                  size: Screen.max(context) * 0.025,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month + 1);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: Screen.height(context) * 0.02),

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((day) => Text(
                      day,
                      style: GoogleFonts.poppins(
                        color: day == 'S' ? colors.red : colors.white,
                        fontSize: Screen.max(context) * 0.02,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: Screen.height(context) * 0.01),

          // Calendar grid
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!widget.isSelectionMode) return;

              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              widget.onDateSelected(selectedDay);
            },
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
            SizedBox(height: Screen.height(context) * 0.02),
            Row(
              children: [
                Container(
                  width: Screen.max(context) * 0.015,
                  height: Screen.max(context) * 0.015,
                  decoration: BoxDecoration(
                    color: colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: Screen.width(context) * 0.02),
                Text(
                  'Booked dates',
                  style: GoogleFonts.poppins(
                    color: colors.white,
                    fontSize: Screen.max(context) * 0.015,
                  ),
                ),
              ],
            ),
            SizedBox(height: Screen.height(context) * 0.01),
            Row(
              children: [
                Container(
                  width: Screen.max(context) * 0.015,
                  height: Screen.max(context) * 0.015,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.red),
                  ),
                ),
                SizedBox(width: Screen.width(context) * 0.02),
                Text(
                  'Today',
                  style: GoogleFonts.poppins(
                    color: colors.white,
                    fontSize: Screen.max(context) * 0.015,
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
