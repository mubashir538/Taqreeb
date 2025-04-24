import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> _banks = [];
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UI_Management.headerHeight = renderBox.size.height);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
            endpoint: 'Payments/getWalletBalance/$userId/$type',
            headers: headers))
        .toString();
    _banks = await MyApi.getRequest(
        endpoint: 'Payments/getBank/$userId', headers: headers);
    _transactions = await MyApi.getRequest(
        endpoint: 'Payments/getTransactions/Recent/$userId/$type',
        headers: headers);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
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
                              height: UI_Management.headerHeight +
                                  Screen.height(context) * 0.01),
                          BalanceCard(
                            balance: _balance,
                          ),
                          WithDrawSection(
                            banks: _banks,
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
