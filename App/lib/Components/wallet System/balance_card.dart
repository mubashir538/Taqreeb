import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class BalanceCard extends StatefulWidget {
  final String balance;
  final VoidCallback onpopped;
  const BalanceCard({super.key, required this.balance, required this.onpopped});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Screen.width(context) * 0.9,
        height: Screen.height(context) * 0.25,
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
        margin: EdgeInsets.all(Screen.max(context) * 0.02),
        decoration: BoxDecoration(
            color: MyColors.darkLighter,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(51),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Available Balance",
              style: GoogleFonts.roboto(
                  color: MyColors.white,
                  fontSize: Screen.max(context) * 0.015,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Rs. ${widget.balance}",
              style: GoogleFonts.roboto(
                  color: MyColors.white,
                  fontSize: Screen.max(context) * 0.03,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: Screen.max(context) * 0.01,
            ),
            ColoredButton(
                text: "Add Bank",
                onPressed: () {
                  context.pushNamedTransition(
                      routeName: "/AddBank",
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300));
                },
                width: Screen.width(context) * 0.3,
                textSize: Screen.max(context) * 0.015)
          ],
        ));
  }
}
