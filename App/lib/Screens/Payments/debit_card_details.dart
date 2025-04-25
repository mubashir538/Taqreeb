import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class SecurePaymentScreen extends StatefulWidget {
  final int orderId;
  final int amount;
  final bool isFullPayment;

  const SecurePaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.isFullPayment,
  });

  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen> {
  final PaymentController _controller = PaymentController();
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // Process payment with your payment gateway
      final paymentResponse =
          await MyApi.postRequest(endpoint: 'process_payment/', body: {
        'order_id': widget.orderId,
        'amount': widget.amount,
        'is_full_payment': widget.isFullPayment,
        'card_number': _controller.cardNumberController.text,
        'expiry_date': _controller.expiryDateController.text,
        'cvv': _controller.cvvController.text,
        'cardholder_name': _controller.cardholderNameController.text,
      }, headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      });

      if (paymentResponse['status'] == 'success') {
        // Update order status
        await MyApi.postRequest(endpoint: 'update_order_status/', body: {
          'order_id': widget.orderId,
          'status': 'paid',
          'payment_status':
              widget.isFullPayment ? 'paid_in_full' : 'deposit_paid',
        }, headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        });

        MyScaffold(text: 'Payment successful!').show(context);

        Navigator.pushNamedAndRemoveUntil(
            context, '/HomePage', (route) => false);
      } else {
        throw Exception(paymentResponse['message'] ?? 'Payment failed');
      }
    } catch (e) {
      MyScaffold(text: 'Payment error: ${e.toString()}').show(context);
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure Payment'),
        backgroundColor: MyColors.dark,
      ),
      backgroundColor: MyColors.DarkLighter,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Screen.width(context) * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Amount: \$${widget.amount.toStringAsFixed(2)}',
              style: GoogleFonts.montserrat(
                color: MyColors.white,
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Screen.height(context) * 0.03),
            Text(
              'Card Information',
              style: GoogleFonts.montserrat(
                color: MyColors.white,
                fontSize: Screen.max(context) * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Screen.height(context) * 0.02),
            MyTextBox(
              hint: 'Card Number',
              valueController: _controller.cardNumberController,
              isNum: true,
              maxLength: 16,
            ),
            SizedBox(height: Screen.height(context) * 0.015),
            Row(
              children: [
                Expanded(
                  child: MyTextBox(
                    hint: 'MM/YY',
                    valueController: _controller.expiryDateController,
                    isNum: true,
                    maxLength: 5,
                  ),
                ),
                SizedBox(width: Screen.width(context) * 0.03),
                Expanded(
                  child: MyTextBox(
                    hint: 'CVV',
                    valueController: _controller.cvvController,
                    isNum: true,
                    maxLength: 3,
                  ),
                ),
              ],
            ),
            SizedBox(height: Screen.height(context) * 0.015),
            MyTextBox(
              hint: 'Cardholder Name',
              valueController: _controller.cardholderNameController,
            ),
            SizedBox(height: Screen.height(context) * 0.04),
            if (!_isProcessing)
              ColoredButton(
                text: 'Pay Now',
                onPressed: _processPayment,
              )
            else
              Center(child: CircularProgressIndicator()),
            SizedBox(height: Screen.height(context) * 0.02),
            Center(
              child: Text(
                'Your payment is secured with 256-bit SSL encryption',
                style: GoogleFonts.montserrat(
                  color: MyColors.white,
                  fontSize: Screen.max(context) * 0.015,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PaymentController {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController cardholderNameController =
      TextEditingController();

  final FocusNode cardNumberFocus = FocusNode();
  final FocusNode expiryDateFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();
  final FocusNode cardholderNameFocus = FocusNode();

  String cardNumberError = '';
  String expiryDateError = '';
  String cvvError = '';
  String cardholderNameError = '';

  void validateAllFields() {
    cardNumberError = _validateCardNumber(cardNumberController.text);
    expiryDateError = _validateExpiryDate(expiryDateController.text);
    cvvError = _validateCvv(cvvController.text);
    cardholderNameError =
        _validateCardholderName(cardholderNameController.text);
  }

  bool get isFormValid {
    return cardNumberError.isEmpty &&
        expiryDateError.isEmpty &&
        cvvError.isEmpty &&
        cardholderNameError.isEmpty;
  }

  String _validateCardNumber(String value) {
    if (value.isEmpty) return 'Card number is required';
    if (value.length < 16) return 'Card number must be 16 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only numbers allowed';
    return '';
  }

  String _validateExpiryDate(String value) {
    if (value.isEmpty) return 'Expiry date is required';
    if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
      return 'Invalid format (MM/YY)';
    }
    return '';
  }

  String _validateCvv(String value) {
    if (value.isEmpty) return 'CVV is required';
    if (value.length < 3) return 'CVV must be 3 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only numbers allowed';
    return '';
  }

  String _validateCardholderName(String value) {
    if (value.isEmpty) return 'Cardholder name is required';
    if (value.length < 3) return 'Name too short';
    return '';
  }

  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardholderNameController.dispose();
    cardNumberFocus.dispose();
    expiryDateFocus.dispose();
    cvvFocus.dispose();
    cardholderNameFocus.dispose();
  }
}
