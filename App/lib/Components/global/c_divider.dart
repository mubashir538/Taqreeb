import 'package:flutter/material.dart';
import 'package:taqreeb/core/utils/color.dart';

class MyDivider extends StatelessWidget {
  final double width;
  final double thickness;
  const MyDivider({super.key, this.width = 0, this.thickness = 1.5});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      width: width == 0 ? MediaQuery.of(context).size.width * 0.8 : width,
      child: Opacity(
        opacity: 0.4,
        child: Divider(
          thickness: thickness,
          color: MyColors.whiteDarker,
        ),
      ),
    );
  }
}
