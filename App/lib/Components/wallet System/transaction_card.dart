import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/color.dart';

import '../../core/services/screen_size.dart';

class TransactionCard extends StatefulWidget {
  final String amount;
  final String paidBy;
  final String type;
  final String date;

  const TransactionCard({
    super.key,
    required this.amount,
    required this.paidBy,
    required this.type,
    required this.date,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
        decoration: BoxDecoration(
          color: MyColors.darkLighter,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:
                      widget.type == "Deposit" ? MyColors.red : MyColors.green,
                  radius: Screen.max(context) * 0.03,
                  child: Icon(
                    widget.type == "Deposit"
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: MyColors.white.withAlpha(200),
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: Screen.max(context) * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.paidBy,
                      style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.017,
                        fontWeight: FontWeight.w400,
                        color: MyColors.white,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: GoogleFonts.montserrat(
                        fontSize: Screen.max(context) * 0.013,
                        fontWeight: FontWeight.w300,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              (widget.type == "Deposit" ? "-" : "+") + widget.amount,
              style: GoogleFonts.montserrat(
                fontSize: Screen.max(context) * 0.017,
                fontWeight: FontWeight.w400,
                color: widget.type == "Deposit" ? MyColors.red : MyColors.green,
              ),
            ),
          ],
        ));
  }
}
