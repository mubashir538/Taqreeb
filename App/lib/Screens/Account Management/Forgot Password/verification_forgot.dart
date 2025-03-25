import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/providers/ForgotPasswordVerifyCodeViewModel.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_otp.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/utils/color.dart';

class ForgotPassword_VerifyCode extends StatefulWidget {
  const ForgotPassword_VerifyCode({super.key});

  @override
  State<ForgotPassword_VerifyCode> createState() =>
      _ForgotPassword_VerifyCodeState();
}

class _ForgotPassword_VerifyCodeState extends State<ForgotPassword_VerifyCode> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UI_Management.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          setState(() {
            UI_Management.headerHeight = renderbox.size.height;
          });
        },
      );
      // Start the timer when the screen loads
      Provider.of<ForgotPasswordVerifyCodeViewModel>(context, listen: false)
          .startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final email = arguments['email'];
    final Map<String, dynamic> response = arguments['response'];
    final viewModel = Provider.of<ForgotPasswordVerifyCodeViewModel>(context);

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: UI_Management.headerHeight),
                Container(
                  margin: EdgeInsets.only(
                    top: Screen.max(context) * 0.07,
                    bottom: Screen.max(context) * 0.02,
                  ),
                  child: OTPBoxes(
                    onChanged: (value) {
                      viewModel.setEnteredOTP(value);
                    },
                  ),
                ),
                TextButton(
                  onPressed: viewModel.isResendEnabled
                      ? () async {
                          await viewModel.resendOTP(
                              response['email'], response['otp']);
                        }
                      : null,
                  child: Text(
                    viewModel.isResendEnabled
                        ? 'Send Code Again'
                        : 'Send Code Again in ${viewModel.formatTime(viewModel.remainingTime)}',
                    style: TextStyle(
                      color: MyColors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      decoration: viewModel.isResendEnabled
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: Screen.height(context) * 0.1,
                  child: const Center(child: MyDivider()),
                ),
                ColoredButton(
                  text: 'Verify Code',
                  onPressed: () async {
                    await viewModel.verifyOTP(
                      viewModel.enteredOTP,
                      response['otp'],
                      context,
                      email,
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Header(
              key: headerKey,
              heading: 'Verify Code',
              para: 'We have sent the code to $email',
            ),
          ),
        ],
      ),
    );
  }
}
