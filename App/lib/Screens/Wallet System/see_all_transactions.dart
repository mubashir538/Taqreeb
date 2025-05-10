import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/wallet%20System/transaction_card.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/utils/color.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  bool isloading = true;
  List<Map<String, dynamic>> transactions = [];

  Map<String, List<Map<String, dynamic>>> groupedData = {
    'Today': [],
    'Yesterday': [],
    'This Month': [],
    'This Year': [],
    'Previous': []
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    transactions = args['data'];
  }

  void fetchdata() async {
    // data = await db.getExpenses();
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));
    String thisMonth = DateFormat('yyyy-MM').format(now);
    String thisYear = DateFormat('yyyy').format(now);

    Map<String, List<Map<String, dynamic>>> tempGroupedData = {
      'Today': [],
      'Yesterday': [],
      'This Month': [],
      'This Year': [],
      'Previous': []
    };

    for (var transaction in transactions) {
      DateTime transactionDate = DateTime.parse(
          transaction['date']); // Ensure your DB returns a valid date string
      String formattedDate = DateFormat('yyyy-MM-dd').format(transactionDate);
      String formattedMonth = DateFormat('yyyy-MM').format(transactionDate);
      String formattedYear = DateFormat('yyyy').format(transactionDate);

      if (formattedDate == today) {
        tempGroupedData['Today']!.add(transaction);
      } else if (formattedDate == yesterday) {
        tempGroupedData['Yesterday']!.add(transaction);
      } else if (formattedMonth == thisMonth) {
        tempGroupedData['This Month']!.add(transaction);
      } else if (formattedYear == thisYear) {
        tempGroupedData['This Year']!.add(transaction);
      } else {
        tempGroupedData['Previous']!.add(transaction);
      }
    }

    setState(() {
      groupedData = tempGroupedData;
      isloading = false;
    });
  }

  String _formatNumberWithCommas(String number) {
    return number.toString().replaceAllMapped(
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
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: Screen.height(context) * 0.1,
                      width: Screen.width(context)),
                  Column(
                    children: groupedData.entries
                        .where((entry) => entry
                            .value.isNotEmpty) // Show only non-empty sections
                        .map((entry) =>
                            buildTransactionSection(entry.key, entry.value))
                        .toList(),
                  ),
                ]),
          ),
          Positioned(top: 0, child: Header()),
        ],
      ),
    );
  }

  Widget buildTransactionSection(
      String title, List<Map<String, dynamic>> transactions) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        title,
        style: GoogleFonts.roboto(
          color: MyColors.red,
          fontSize: Screen.max(context) * 0.02,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: Screen.max(context) * 0.02),
      SizedBox(
        width: Screen.width(context) * 0.9,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final transact = transactions[index];
            return TransactionCard(
              type: transact["type"],
              amount: _formatNumberWithCommas(transact["amount"]),
              paidBy: transact['info'],
              date: formatDate(transact['date']),
            );
          },
          itemCount: transactions.length,
        ),
      ),
    ]);
  }
}
