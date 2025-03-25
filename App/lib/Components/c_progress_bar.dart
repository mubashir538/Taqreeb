import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class ProgressBar extends StatelessWidget {
  final int Progress;
  const ProgressBar({super.key, required this.Progress});

  @override
  Widget build(BuildContext context) {
    List<Color?> c = [
      MyColors.whiteDarker,
      MyColors.whiteDarker,
      MyColors.whiteDarker,
      MyColors.whiteDarker,
      MyColors.whiteDarker
    ];
    for (int i = 0; i < Progress; i++) {
      c[i] = MyColors.Yellow;
    }

    return Container(
      height: Screen.height(context) * 0.015,
      width: Screen.width(context) * 0.9,
      margin: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  color: c[0],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: c[1],
              ),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: c[2],
              ),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: c[3],
              ),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  color: c[4],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
