import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/theme/color.dart';

class SliderQuestion extends StatefulWidget {
  SliderQuestion({
    super.key,
    required this.question,
    required this.start,
    required this.end,
    required this.div,
    required this.currentCount,
  });

  final String question;
  final double start;
  final double end;
  final int div;
  double currentCount;

  @override
  State<SliderQuestion> createState() => _SliderQuestionState();
}

class _SliderQuestionState extends State<SliderQuestion> {
  void _updateValue(double delta) {
    setState(() {
      widget.currentCount += delta;

      // Ensure the value stays within bounds
      if (widget.currentCount < widget.start) {
        widget.currentCount = widget.start;
      } else if (widget.currentCount > widget.end) {
        widget.currentCount = widget.end;
      }

      // Snap to the nearest multiple of 10
      widget.currentCount = (widget.currentCount / 10).round() * 10.toDouble();
    });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
            child: Text(
              widget.question,
              style: GoogleFonts.montserrat(
                color: MyColors.white,
                fontSize: MaximumThing * 0.018,
              ),
            ),
          ),

          // Slider with controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Minus Icon
              IconButton(
                onPressed: () => _updateValue(-50000),
                icon: Icon(Icons.remove, color: MyColors.red),
              ),

              // Slider
              Expanded(
                child: Slider(
                  value: widget.currentCount,
                  min: widget.start,
                  max: widget.end,
                  divisions: widget.div,
                  label: widget.currentCount.round().toString(),
                  onChanged: (double newValue) {
                    setState(() {
                      // Snap to the nearest multiple of 10
                      widget.currentCount =
                          (newValue / 10).round() * 10.toDouble();
                    });
                  },
                  activeColor: MyColors.red,
                  inactiveColor: MyColors.whiteDarker,
                ),
              ),

              // Add Icon
              IconButton(
                onPressed: () => _updateValue(50000),
                icon: Icon(Icons.add, color: MyColors.red),
              ),
            ],
          ),

          // Range Labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MaximumThing * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.start.toInt().toString(),
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                Text(
                  widget.end.toInt().toString(),
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
