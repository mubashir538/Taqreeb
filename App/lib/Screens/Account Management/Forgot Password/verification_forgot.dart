import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/providers/forgot_password_verify_code_view_model.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/Components/Inputs/c_input_otp.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/utils/color.dart';

class ForgotPasswordVerifyCode extends StatefulWidget {
  const ForgotPasswordVerifyCode({super.key});

  @override
  State<ForgotPasswordVerifyCode> createState() =>
      ForgotPasswordVerifyCodeState();
}

class ForgotPasswordVerifyCodeState extends State<ForgotPasswordVerifyCode> {
  GlobalKey headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: headerKey,
        callback: (renderbox) {
          setState(() {
            UImanagement.headerHeight = renderbox.size.height;
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
    final colors = AppColors(context);

    return Scaffold(
      backgroundColor: colors.dark,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: UImanagement.headerHeight * 0.7),
                Container(
                  margin: EdgeInsets.only(
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
                              response['email'], response['otp'].toString());
                        }
                      : null,
                  child: Text(
                    viewModel.isResendEnabled
                        ? 'Send Code Again'
                        : 'Send Code Again in ${viewModel.formatTime(viewModel.remainingTime)}',
                    style: GoogleFonts.roboto(
                      color: colors.white,
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
                      int.parse(viewModel.enteredOTP),
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
