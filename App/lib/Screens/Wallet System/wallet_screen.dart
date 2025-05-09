import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/wallet%20System/balance_card.dart';
import 'package:taqreeb/Components/wallet%20System/recent_transactions.dart';
import 'package:taqreeb/Components/wallet%20System/withdraw_section.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey headerKey = GlobalKey();
  String _balance = "";
  List<dynamic> _banks = [];
  List<dynamic> _transactions = [];
  bool _isLoading = true;

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UImanagement.headerHeight = renderBox.size.height);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final userId = await MyStorage.getToken(MyTokens.userId);
    final type = await MyTokens.getBusinessType();
    final headers = {
      'Authorization':
          'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
    };
    _balance = (await MyApi.getRequest(
            refresh: true,
            context: context,
            endpoint: 'Payments/getWalletBalance/$userId/$type',
            headers: headers))['balance']
        .toString();

    final response = await MyApi.getRequest(
        context: context,
        refresh: true,
        endpoint: 'Payments/getBank/$userId',
        headers: headers);
    if (response['status'] == 'success') {
      _banks = response['data'];
    } else {
      MyScaffold(text: 'Something went wrong!').show(context);
    }
    final response2 = await MyApi.getRequest(
        context: context,
        refresh: true,
        endpoint: 'Payments/getTransactions/Recent/$userId/$type',
        headers: headers);
    if (response2['status'] == 'success') {
      _transactions = response2['data'];
    } else {
      MyScaffold(text: 'Something went wrong!').show(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: SizedBox(
                      width: Screen.width(context),
                      child: Column(
                        children: [
                          SizedBox(
                              height: UImanagement.headerHeight +
                                  Screen.height(context) * 0.01),
                          BalanceCard(
                            balance: _balance,
                            onpopped: fetchData,
                          ),
                          WithDrawSection(
                            banks: _banks,
                            balance: int.parse(_balance),
                          ),
                          RecentTransactions(
                            transactions: _transactions,
                          ),
                        ],
                      )),
                ),
          Positioned(
              top: 0, child: Header(key: headerKey, heading: 'Your Wallet')),
        ],
      ),
    );
  }
}
