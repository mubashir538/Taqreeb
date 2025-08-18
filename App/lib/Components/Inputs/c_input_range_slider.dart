import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/core/utils/color.dart';

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
  const RangeSliderWidget(
      {super.key,
      required this.start,
      required this.end,
      required this.divisions,
      required this.controller,
      required this.onChanged,
      this.startLabel = "",
      this.endLabel = "",
      this.price = true});

  final String startLabel;
  final String endLabel;
  final bool price;
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
    currentRange =
        RangeValues(widget.controller.minValue, widget.controller.maxValue);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colors.red,
              inactiveTrackColor: colors.whiteDarker,
              thumbColor: colors.red,
              overlayColor: colors.red.withAlpha(51),
              valueIndicatorTextStyle: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: Screen.max(context) * 0.015,
              ),
            ),
            child: RangeSlider(
              values: currentRange,
              min: widget.start,
              max: widget.end,
              divisions: widget.divisions,
              labels: widget.price
                  ? RangeLabels(
                      currentRange.start.round().toString(),
                      currentRange.end.round().toString(),
                    )
                  : RangeLabels(
                      currentRange.start.toString(),
                      currentRange.end.toString(),
                    ),
              onChanged: (RangeValues newRange) {
                setState(() {
                  currentRange = widget.price
                      ? RangeValues(
                          (newRange.start / 10000).round() * 10000.toDouble(),
                          (newRange.end / 10000).round() * 10000.toDouble(),
                        )
                      : RangeValues(newRange.start, newRange.end);

                  widget.controller
                      .updateValues(currentRange.start, currentRange.end);

                  widget.onChanged(currentRange.start, currentRange.end);
                });
              },
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Screen.max(context) * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.startLabel == ""
                      ? 'Rs. ${NumberFormat("#,##0").format(currentRange.start.round())}'
                      : widget.startLabel,
                  style: GoogleFonts.roboto(color: colors.white),
                ),
                Text(
                  widget.endLabel == ""
                      ? 'Rs. ${NumberFormat("#,##0").format(currentRange.end.round())}'
                      : widget.endLabel,
                  style: GoogleFonts.roboto(color: colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
