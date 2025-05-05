import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taqreeb/core/providers/forgot_password_provider.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/utils/images.dart';
import 'forgot_password_form.dart';

class ForgotPasswordEmailorPhoneInput extends StatefulWidget {
  const ForgotPasswordEmailorPhoneInput({super.key});

  @override
  State<ForgotPasswordEmailorPhoneInput> createState() =>
      _ForgotPasswordEmailorPhoneInputState();
}

class _ForgotPasswordEmailorPhoneInputState
    extends State<ForgotPasswordEmailorPhoneInput> {
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: (renderbox) {
          _changeHeight(renderbox);
        },
      );
    });
  }

  void _changeHeight(RenderBox renderbox) {
    setState(() {
      UImanagement.headerHeight = renderbox.size.height;
    });
  }

  Future<void> _sendCode() async {
    final forgotPasswordProvider =
        Provider.of<ForgotPasswordProvider>(context, listen: false);
    await forgotPasswordProvider.sendCode(
        _contactController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordProvider = Provider.of<ForgotPasswordProvider>(context);

    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: (renderbox) {
        _changeHeight(renderbox);
      },
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: forgotPasswordProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: UImanagement.headerHeight),
                      ForgotPasswordForm(
                        contactController: _contactController,
                        onSendCode: _sendCode,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Header(
                    key: _headerKey,
                    heading: 'Forgot Password',
                    para:
                        'Enter the email address with your account and we\'ll send an email with confirmation to reset your password',
                    image: MyImages.forgotPassword,
                  ),
                ),
              ],
            ),
    );
  }
}
