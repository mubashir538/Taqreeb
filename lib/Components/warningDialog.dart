import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Colored%20Button.dart';
import 'package:taqreeb/theme/color.dart';

class warningDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  const warningDialog(
      {super.key,
      required this.title,
      required this.message,
      this.actions = const []});

  Future<void> showDialogBox(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double MaximumThing =
        screenWidth > screenHeight ? screenWidth : screenHeight;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: MyColors.Dark,
              title: Text(
                title,
                style: GoogleFonts.montserrat(
                    color: MyColors.Yellow,
                    fontSize: MaximumThing * 0.02,
                    fontWeight: FontWeight.w600),
              ),
              content: Text(
                message,
                style: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontSize: MaximumThing * 0.015,
                    fontWeight: FontWeight.w400),
              ),
              actions: actions.isNotEmpty 
                  ? actions
                  : [
                      ColoredButton(
                          text: 'Ok', onPressed: () => Navigator.pop(context))
                    ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
