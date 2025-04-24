import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';

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
    cardNumberError = Validations.validateIntFields(cardNumberController.text);
    expiryDateError = Validations.validateIntFields(expiryDateController.text);
    cvvError = Validations.validateIntFields(cvvController.text);
    cardholderNameError =
        Validations.validateName(cardholderNameController.text);
  }

  bool get isFormValid {
    return !(cardNumberError.isEmpty &&
        expiryDateError.isEmpty &&
        cvvError.isEmpty &&
        cardholderNameError.isEmpty);
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

class SecurePaymentScreen extends StatefulWidget {
  const SecurePaymentScreen({super.key});

  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen> {
  final PaymentController _controller = PaymentController();
  int listingId = 0;
  int price = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    listingId = args['listing'] as int;
    price = args['amount'] as int;
  }

  String _formatNumberWithCommas(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(heading: "Secure Payment"),
            _buildVerticalSpace(0.02),
            _buildCardInformationSection(),
            _buildVerticalSpace(0.03),
            const Divider(thickness: 1, color: Colors.grey),
            _buildVerticalSpace(0.03),
            _buildOrderSummarySection(),
            _buildVerticalSpace(0.03),
            _buildPaymentButton(context),
            _buildVerticalSpace(0.005),
            _buildCancelButton(),
            _buildVerticalSpace(0.02),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalSpace(double heightFactor) {
    return SizedBox(height: Screen.height(context) * heightFactor);
  }

  Widget _buildCardInformationSection() {
    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.all(Screen.width(context) * 0.04),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
        borderRadius: BorderRadius.circular(Screen.width(context) * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Card Information'),
          _buildVerticalSpace(0.02),
          _buildCardNumberField(),
          _buildVerticalSpace(0.02),
          _buildExpiryAndCvvFields(),
          _buildVerticalSpace(0.02),
          _buildCardholderNameField(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontSize: Screen.width(context) * 0.045,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Card Number'),
        MyTextBox(
          hint: "1234 5678 9012 3456",
          valueController: _controller.cardNumberController,
          errorText: _controller.cardNumberError,
          isNum: true,
          onChanged: (value) {
            setState(() {
              _controller.cardNumberError =
                  Validations.validateIntFields(value);
              if (value.length > 16) {
                _controller.cardNumberController.text = value.substring(0, 16);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildExpiryAndCvvFields() {
    return Row(
      children: [
        Expanded(child: _buildExpiryDateField()),
        const SizedBox(width: 16),
        Expanded(child: _buildCvvField()),
      ],
    );
  }

  Widget _buildExpiryDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Expiry Date'),
        MyTextBox(
          hint: "MM/YY",
          valueController: _controller.expiryDateController,
          errorText: _controller.expiryDateError,
          isNum: true,
          onChanged: (value) {
            setState(() {
              _controller.expiryDateError =
                  Validations.validateIntFields(value);

              if (value.length >= 4) {
                if (int.parse(value.substring(2, 4)) < 25) {
                  _controller.expiryDateError = "Invalid Date";
                }
              } else if (value.length >= 2) {
                if (int.parse(value.substring(0, 2)) > 12) {
                  _controller.expiryDateError = "Invalid Date";
                }
              }

              if (value.length > 4) {
                _controller.expiryDateController.text =
                    '${value.substring(0, 2)}/${value.substring(2, 4)}';
              } else if (value.length > 2) {
                if (int.parse(value.substring(0, 2)) > 12) {
                  _controller.expiryDateError = "Invalid Date";
                }
                _controller.expiryDateController.text =
                    '${value.substring(0, 2)}/${value.substring(2, value.length)}';
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCvvField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('CVV'),
        MyTextBox(
          hint: "123",
          isNum: true,
          valueController: _controller.cvvController,
          errorText: _controller.cvvError,
          onChanged: (value) {
            setState(() {
              _controller.cvvError = Validations.validateIntFields(value);
              if (value.length > 3) {
                _controller.cvvController.text = value.substring(0, 3);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCardholderNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Cardholder Name'),
        MyTextBox(
          hint: "John Smith",
          valueController: _controller.cardholderNameController,
          errorText: _controller.cardholderNameError,
          onChanged: (value) {
            setState(() {
              _controller.cardholderNameError = Validations.validateName(value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: Screen.width(context) * 0.035,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.all(Screen.width(context) * 0.04),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
        borderRadius: BorderRadius.circular(Screen.width(context) * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Order Summary'),
          _buildVerticalSpace(0.02),
          _buildOrderDetailRow(
              'Subtotal', 'Rs. ${_formatNumberWithCommas(price)}'),
          _buildVerticalSpace(0.01),
          _buildOrderDetailRow(
              'Tax', 'Rs. ${_formatNumberWithCommas((price * 0.02).toInt())}'),
          _buildVerticalSpace(0.03),
          const Divider(thickness: 1, color: Colors.grey),
          _buildVerticalSpace(0.03),
          _buildOrderDetailRow('Pay',
              'Rs. ${_formatNumberWithCommas((price * 0.02).toInt() + price)}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: Screen.width(context) * (isTotal ? 0.045 : 0.035),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.white : Colors.grey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: Screen.width(context) * (isTotal ? 0.045 : 0.04),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return ColoredButton(
      text: 'Pay Now',
      onPressed: () async {
        setState(() {
          _controller.validateAllFields();
        });

        if (_controller.isFormValid) {
          await MyApi.postRequest(endpoint: 'Payments/addTransaction', body: {
            'senderId': await MyStorage.getToken(MyTokens.userId),
            'listingId': listingId,
            'amount': price
          }, headers: {
            'Authorization':
                'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
          });
          MyScaffold(
                  text:
                      'Payment successful, Business Owner will approve to Payment to Continue Booking Otherwise your payment will be Refunded')
              .show(context);
          Navigator.pushNamedAndRemoveUntil(context, '/HomePage', (_) => false);
        } else {
          MyScaffold(text: 'Please fix the errors before proceeding.')
              .show(context);
        }
      },
    );
  }

  Widget _buildCancelButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancel Payment',
          style: GoogleFonts.roboto(
            color: MyColors.white,
            fontSize: Screen.width(context) * 0.035,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Center(
          child: Text(
            'By proceeding, you agree to our Terms and Privacy Policy',
            style: GoogleFonts.roboto(
              fontSize: Screen.width(context) * 0.03,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _buildVerticalSpace(0.01),
        Center(
          child: Text(
            'Secure payment processing by Stripe',
            style: GoogleFonts.roboto(
              fontSize: Screen.width(context) * 0.03,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
