import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/wallet%20System/transaction_card.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  bool isloading = true;
  List<Map<String, dynamic>> transactions = [];
  bool isChanged = false;

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
    if (isChanged) return;
    isChanged = true;
    fetchdata();
  }

  void fetchdata() async {
    final userId = await MyStorage.getToken(MyTokens.userId);
    final type = await MyTokens.getBusinessType();
    final headers = {
      'Authorization':
          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
    };
    final response = await MyApi.getRequest(
        context: context,
        refresh: true,
        endpoint: 'Payments/getTransactions/Recent/$userId/$type',
        headers: headers);
    if (response['status'] == 'success') {
      transactions = response['data'].cast<Map<String, dynamic>>()
          as List<Map<String, dynamic>>;
    } else {
      MyScaffold(text: 'Something went wrong!').show(context);
    }
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
                      height: Screen.height(context) * 0.15,
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Screen.max(context) * 0.02), 
          Text(
            title,
            style: GoogleFonts.roboto(
              color: MyColors.red,
              fontSize: Screen.max(context) * 0.025,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: Screen.width(context) * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final transact = transactions[index];
                return TransactionCard(
                  type: transact["type"],
                  amount:
                      _formatNumberWithCommas(transact["amount"].toString()),
                  paidBy: transact['info'],
                  date: formatDate(DateTime.parse(transact['date'])),
                );
              },
              itemCount: transactions.length,
            ),
          ),
        ]);
  }
}
