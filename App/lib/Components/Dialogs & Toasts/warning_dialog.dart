import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/utils/color.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget> actions;
  const WarningDialog(
      {super.key,
      required this.title,
      required this.message,
      this.actions = const []});

  Future<void> showDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final colors = AppColors(context);

          return AlertDialog(
              backgroundColor: colors.dark,
              title: Text(
                title,
                style: GoogleFonts.roboto(
                    color: colors.yellow,
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w600),
              ),
              content: Text(
                message,
                style: GoogleFonts.roboto(
                    color: colors.white,
                    fontSize: Screen.max(context) * 0.015,
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
