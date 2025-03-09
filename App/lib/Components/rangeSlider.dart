import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/theme/color.dart';

class RangeSliderController {
  double minValue;
  double maxValue;

  RangeSliderController({required this.minValue, required this.maxValue});

  void updateValues(double min, double max) {
    minValue = min;
    maxValue = max;
  }
}

class RangeSliderWidget extends StatefulWidget {
  const RangeSliderWidget({
    super.key,
    required this.start,
    required this.end,
    required this.divisions,
    required this.controller,
    required this.onChanged,
  });

  final double start;
  final double end;
  final int divisions;
  final RangeSliderController controller;
  final Function(double min, double max) onChanged;

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  late RangeValues currentRange;

  @override
  void initState() {
    super.initState();
    currentRange = RangeValues(widget.controller.minValue, widget.controller.maxValue);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return Container(
      margin: EdgeInsets.symmetric(vertical: MaximumThing * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: MyColors.red,
              inactiveTrackColor: MyColors.whiteDarker,
              thumbColor: MyColors.red,
              overlayColor: MyColors.red.withOpacity(0.2),
              valueIndicatorTextStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: MaximumThing * 0.015,
              ),
            ),
            child: RangeSlider(
              values: currentRange,
              min: widget.start,
              max: widget.end,
              divisions: widget.divisions,
              labels: RangeLabels(
                currentRange.start.round().toString(),
                currentRange.end.round().toString(),
              ),
              onChanged: (RangeValues newRange) {
                setState(() {
                  currentRange = RangeValues(
                    (newRange.start / 10000).round() * 10000.toDouble(),
                    (newRange.end / 10000).round() * 10000.toDouble(),
                  );

                  widget.controller.updateValues(currentRange.start, currentRange.end);

                  widget.onChanged(currentRange.start, currentRange.end);
                });
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs. ${NumberFormat("#,##0").format(currentRange.start.round())}',
                  style: GoogleFonts.montserrat(color: MyColors.white),
                ),
                Text(
                  'Rs. ${NumberFormat("#,##0").format(currentRange.end.round())}',
                  style: GoogleFonts.montserrat(color: MyColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
