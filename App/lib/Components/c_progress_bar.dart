import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class ProgressBar extends StatelessWidget {
  final int progress; // Should be between 0 and 5 (for 5 steps)
  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    // Calculate progress percentage (0.0 to 1.0)
    final progressPercentage = progress.clamp(0, 5) / 5;

    return Container(
      height: Screen.height(context) * 0.02,
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.03),
      child: Stack(
        children: [
          // Background of the progress bar
          Container(
            decoration: BoxDecoration(
              color: MyColors.whiteDarker,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Progress indicator
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: constraints.maxWidth * progressPercentage,
                decoration: BoxDecoration(
                  color: MyColors.yellow,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
