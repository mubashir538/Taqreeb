import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final GlobalKey headerKey = GlobalKey();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  String? selectedBank;

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UImanagement.headerHeight = renderBox.size.height);
    }
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
          SingleChildScrollView(
            child: SizedBox(
              width: Screen.width(context),
              child: Column(
                children: [
                  SizedBox(
                    height: UImanagement.headerHeight +
                        Screen.height(context) * 0.02,
                  ),
                  Container(
                    width: Screen.width(context) * 0.9,
                    padding: EdgeInsets.all(Screen.max(context) * 0.03),
                    decoration: BoxDecoration(
                      color: MyColors.darkLighter,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(51),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Bank Account",
                          style: GoogleFonts.montserrat(
                            fontSize: Screen.max(context) * 0.025,
                            fontWeight: FontWeight.w700,
                            color: MyColors.white,
                          ),
                        ),
                        SizedBox(height: Screen.max(context) * 0.03),

                        // Bank Selection Dropdown
                        ResponsiveDropdown(
                          items: const [
                            'Bank Al Habib',
                            'Meezan Bank',
                            'Habib Bank Limited',
                            'United Bank Limited',
                            'Allied Bank',
                            'MCB Bank',
                            'NayaPay',
                            'SadaPay',
                          ],
                          labelText: "Select Bank",
                          onChanged: (value) {
                            setState(() {
                              selectedBank = value;
                            });
                          },
                        ),
                        SizedBox(height: Screen.max(context) * 0.02),

                        // Account Name Field
                        MyTextBox(
                          hint: "Account Holder Name",
                          valueController: accountNameController,
                        ),
                        SizedBox(height: Screen.max(context) * 0.02),

                        // Account Number Field
                        MyTextBox(
                          hint: "Account Number",
                          isNum: true,
                          maxLength: 16,
                          valueController: accountNumberController,
                        ),
                        SizedBox(height: Screen.max(context) * 0.02),

                        // IBAN Number Field
                        MyTextBox(
                          hint: "IBAN Number",
                          valueController: ibanController,
                          maxLength: 24,
                        ),
                        SizedBox(height: Screen.max(context) * 0.04),

                        // Submit Button
                        Center(
                          child: ColoredButton(
                            text: "Add Bank Account",
                            onPressed: () async {
                              // Handle bank account submission
                              final response = await MyApi.postRequest(
                                  endpoint: 'Payments/addBank/',
                                  body: {
                                    'bankName': selectedBank,
                                    'accountNumber':
                                        accountNumberController.text,
                                    'IBANNumber': ibanController.text,
                                    'accountHolderName':
                                        accountNameController.text,
                                    'userID': await MyStorage.getToken(
                                        MyTokens.userId)
                                  },
                                  headers: {
                                    'Authorization':
                                        'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
                                  });
                              if (response['status'] == 'success') {
                                MyScaffold(text: 'Bank Added Successfully!')
                                    .show(context);
                              } else {
                                MyScaffold(text: 'Failed to Add Bank Account!')
                                    .show(context);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Screen.max(context) * 0.05),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Add Bank Account',
            ),
          ),
        ],
      ),
    );
  }
}
