import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart'; // Assuming MyColors is here

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.onTabChanged,
    this.initialIndex = 0,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.all(Screen.max(context) * 0.01),
      margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: colors.lightDark, // Change to your color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: List.generate(widget.tabs.length, (index) {
          final isSelected = index == _selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTabChanged?.call(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? colors.red : Colors.transparent,
                  borderRadius: _getBorderRadius(index, widget.tabs.length),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    widget.tabs[index],
                    style: GoogleFonts.roboto(
                      color: isSelected ? colors.white : colors.whiteDarker,
                      fontWeight: FontWeight.w500,
                      fontSize: Screen.max(context) * 0.015,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  BorderRadius _getBorderRadius(int index, int totalTabs) {
    return const BorderRadius.all(
      Radius.circular(20),
    );
  }
}
