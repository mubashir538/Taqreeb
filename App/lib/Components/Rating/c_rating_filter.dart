import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

class RatingFilter extends StatefulWidget {
  final TextEditingController controller;
  RatingFilter({super.key, required this.controller});

  @override
  State<RatingFilter> createState() => _RatingFilterState();
}

class _RatingFilterState extends State<RatingFilter> {
  int selectedIndex = 0;
  List<String> Filters = [
    'All Reviews',
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Stars'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Screen.height(context) * 0.07,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == selectedIndex) {
            return FilterButton(label: Filters[index], selected: true);
          } else {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = Filters.indexOf(Filters[index]);
                    widget.controller.text = Filters[index];
                  });
                },
                child: FilterButton(label: Filters[index], selected: false));
          }
        },
        itemCount: 6,
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  FilterButton({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    double max = Screen.width(context) > Screen.height(context)
        ? Screen.width(context)
        : Screen.height(context);
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: max * 0.01, vertical: max * 0.007),
      width: Screen.width(context) * 0.3,
      margin: EdgeInsets.symmetric(horizontal: max * 0.01),
      decoration: BoxDecoration(
        border: Border.all(
            color: selected ? Colors.transparent : MyColors.whiteDarker,
            width: 1),
        borderRadius: BorderRadius.circular(10),
        color: selected ? MyColors.DarkLighter : Colors.transparent,
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.montserrat(
              fontSize: max * 0.015,
              fontWeight: FontWeight.w400,
              color: selected ? MyColors.white : MyColors.whiteDarker),
        ),
      ),
    );
  }
}
