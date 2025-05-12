import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/wallet%20System/transaction_card.dart';
import 'package:taqreeb/core/utils/color.dart';
import '../../core/services/screen_size.dart';

class RecentTransactions extends StatefulWidget {
  final List<dynamic> transactions;
  const RecentTransactions({super.key, required this.transactions});

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  String _formatNumberWithCommas(String number) {
    return number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('MMM d,yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(Screen.max(context) * 0.02),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Recent Transactions",
                  style: GoogleFonts.roboto(
                      fontSize: Screen.max(context) * 0.02,
                      fontWeight: FontWeight.w700,
                      color: MyColors.white)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/AllTransactions",arguments: widget.transactions);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01, horizontal: Screen.max(context) * 0.02),
                  decoration: BoxDecoration(
                    color: MyColors.darkLighter,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("See All",
                      style: GoogleFonts.roboto(
                          fontSize: Screen.max(context) * 0.015,
                          fontWeight: FontWeight.w400,
                          color: MyColors.red)),
                ),
              ),
            ]),
            SizedBox(
              height: Screen.max(context) * 0.02,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final transact = widget.transactions[index];
                  return TransactionCard(
                    type: transact["type"],
                    amount:
                        _formatNumberWithCommas(transact["amount"].toString()),
                    paidBy: transact['info'],
                    date: formatDate(DateTime.parse(transact['date'])),
                  );
                },
                itemCount: widget.transactions.length)
          ],
        ));
  }
}
