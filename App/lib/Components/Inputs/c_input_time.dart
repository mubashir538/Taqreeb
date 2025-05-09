import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeInputWidget extends StatefulWidget {
  final String hint;
  final TextEditingController valueController;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const TimeInputWidget({
    super.key,
    required this.hint,
    required this.valueController,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  State<TimeInputWidget> createState() => _TimeInputWidgetState();
}

class _TimeInputWidgetState extends State<TimeInputWidget> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.valueController.text.isNotEmpty) {
      _parseTimeFromController();
    }
  }

  void _parseTimeFromController() {
    try {
      final timeText = widget.valueController.text;
      final isPM = timeText.toLowerCase().contains('pm');
      final timePart = timeText.replaceAll(RegExp(r'[aApPmM]'), '').trim();
      final parts = timePart.split(':');

      if (parts.length == 2) {
        var hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        if (isPM && hour < 12) hour += 12;
        if (!isPM && hour == 12) hour = 0;

        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      _selectedTime = null;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: MyColors.yellow,
              onPrimary: MyColors.dark,
              surface: MyColors.darkLighter,
              onSurface: MyColors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: MyColors.darkLighter,
              hourMinuteTextColor: MyColors.white,
              dialHandColor: MyColors.yellow,
              dialBackgroundColor: MyColors.dark.withAlpha(127),
              hourMinuteColor: MyColors.dark.withAlpha(127),
              entryModeIconColor: MyColors.yellow,

              // ✅ Highlight selected AM/PM
              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return MyColors.red; // <-- highlight selected
                }
                return MyColors.dark.withAlpha(127); // unselected
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.grey[300]!;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        widget.valueController.text = _formatTime(picked);
      });
      if (widget.onFieldSubmitted != null) {
        widget.onFieldSubmitted!(widget.valueController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxDimension = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);

    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: maxDimension * 0.02,
          vertical: maxDimension * 0.015,
        ),
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.focusNode?.hasFocus ?? false
                ? MyColors.yellow
                : MyColors.whiteDarker,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                  _selectedTime != null
                      ? _formatTime(_selectedTime!)
                      : widget.hint,
                  style: GoogleFonts.montserrat(
                    fontSize: maxDimension * 0.015,
                    fontWeight: FontWeight.w400,
                    color: _selectedTime != null
                        ? MyColors.white
                        : MyColors.whiteDarker,
                  )),
            ),
            Icon(
              Icons.access_time,
              color: MyColors.yellow,
              size: maxDimension * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
