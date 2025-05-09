import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

import '../../core/services/screen_size.dart';

class WithDrawSection extends StatefulWidget {
  final List<dynamic> banks;
  final int balance;
  const WithDrawSection(
      {super.key, required this.banks, required this.balance});

  @override
  State<WithDrawSection> createState() => _WithDrawSectionState();
}

class _WithDrawSectionState extends State<WithDrawSection> {
  TextEditingController amountController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  FocusNode amountFocusNode = FocusNode();
  List<String> banks = [];

  void convertBanks() {
    for (var element in widget.banks) {
      banks.add("${element['bankName']} ${element['masked_account_number']}");
    }
  }

  @override
  void initState() {
    super.initState();
    convertBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(Screen.max(context) * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Withdraw Money",
                style: GoogleFonts.montserrat(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w700,
                    color: MyColors.white)),
            SizedBox(
              height: Screen.max(context) * 0.02,
            ),
            Container(
                width: Screen.width(context) * 0.9,
                padding: EdgeInsets.all(Screen.max(context) * 0.02),
                decoration: BoxDecoration(
                    color: MyColors.darkLighter,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(51),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Column(
                  children: [
                    MyTextBox(
                      hint: "Withdraw Amount",
                      isNum: true,
                      valueController: amountController,
                      focusNode: amountFocusNode,
                    ),
                    ResponsiveDropdown(
                        items: banks,
                        labelText: "Select Bank",
                        onChanged: (value) {
                          bankController.text = value;
                        }),
                    ColoredButton(
                      text: "Withdraw",
                      onPressed: () async {
                        if (amountController.text.isEmpty) {
                          MyScaffold(text: 'Please Enter Amount').show(context);
                          return;
                        }
                        if (bankController.text.isEmpty) {
                          MyScaffold(text: 'Please Select Bank').show(context);
                          return;
                        }
                        if (int.parse(amountController.text) > widget.balance) {
                          MyScaffold(text: 'Insufficient Balance')
                              .show(context);
                          return;
                        }
                        final response = await MyApi.postRequest(
                            endpoint: 'Payments/WithdrawBalance',
                            body: {
                              'amount': amountController.text,
                              'userID':
                                  await MyStorage.getToken(MyTokens.userId),
                              'type': await MyTokens.getBusinessType(),
                              'bankDetails': bankController.text
                            },
                            headers: {
                              'Authorization':
                                  'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                            });

                        if (response['status'] == 'success') {
                          MyScaffold(
                                  text:
                                      'Your Amount has been Withdrawn Successfully')
                              .show(context);
                        }
                      },
                    ),
                  ],
                ))
          ],
        ));
  }
}
