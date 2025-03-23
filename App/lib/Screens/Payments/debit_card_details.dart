import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/validations.dart';
import 'package:taqreeb/core/utils/color.dart';

class SecurePaymentScreen extends StatefulWidget {
  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen> {
  final TextEditingController CardNumber = TextEditingController();
  final TextEditingController ExpireyDate = TextEditingController();
  final TextEditingController CVV = TextEditingController();
  final TextEditingController CardholderName = TextEditingController();

  final FocusNode CardNumberFocus = FocusNode();
  final FocusNode expiryDateFocus = FocusNode();
  final FocusNode CVVFocus = FocusNode();
  final FocusNode CardholderNameFocus = FocusNode();

  String cardNumberError = '';
  String expiryDateError = '';
  String cvvError = '';
  String cardholderNameError = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              heading: "Secure Payment",
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing
            SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  // Card Information Section
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter, // Use your card background color
                      borderRadius: BorderRadius.circular(screenWidth * 0.02), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Information Title
                        Text(
                          'Card Information',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02), // Responsive spacing

                        // Card Number
                        Text(
                          'Card Number',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035, // Responsive font size
                            color: Colors.grey,
                          ),
                        ),
                        MyTextBox(
                          hint: "1234 5678 9012 3456",
                          valueController: CardNumber,
                          errorText: cardNumberError,
                          onChanged: (value) {
                            setState(() {
                              cardNumberError = Validations.validateIntFields(value);
                            });
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02), // Responsive spacing

                        // Expiry Date and CVV
                        Row(
                          children: [
                            // Expiry Date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expiry Date',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035, // Responsive font size
                                      color: Colors.grey,
                                    ),
                                  ),
                                  MyTextBox(
                                    hint: "MM/YY",
                                    valueController: ExpireyDate,
                                    errorText: expiryDateError,
                                    onChanged: (value) {
                                      setState(() {
                                        expiryDateError = Validations.validateIntFields(value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // CVV
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CVV',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035, // Responsive font size
                                      color: Colors.grey,
                                    ),
                                  ),
                                  MyTextBox(
                                    hint: "123",
                                    valueController: CVV,
                                    errorText: cvvError,
                                    onChanged: (value) {
                                      setState(() {
                                        cvvError = Validations.validateIntFields(value);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02), // Responsive spacing

                        // Cardholder Name
                        Text(
                          'Cardholder Name',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035, // Responsive font size
                            color: Colors.grey,
                          ),
                        ),
                        MyTextBox(
                          hint: "John Smith",
                          valueController: CardholderName,
                          errorText: cardholderNameError,
                          onChanged: (value) {
                            setState(() {
                              cardholderNameError = Validations.validateName(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing

            // Divider
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing

            // Order Summary Section
            SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                    decoration: BoxDecoration(
                      color: MyColors.DarkLighter, // Use your card background color
                      borderRadius: BorderRadius.circular(screenWidth * 0.02), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Summary Title
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02), // Responsive spacing

                        // Subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035, // Responsive font size
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$129.99',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01), // Responsive spacing

                        // Tax
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tax',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035, // Responsive font size
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\$12.99',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03), // Responsive spacing

                        // Divider
                        Divider(
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: screenHeight * 0.03), // Responsive spacing

                        // Total Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pay',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '\$145.97',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045, // Responsive font size
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Responsive spacing

            // Payment Button
            ColoredButton(
              text: 'Pay Now',
              onPressed: () {
                // Validate all fields before proceeding
                setState(() {
                  cardNumberError = Validations.validateIntFields(CardNumber.text);
                  expiryDateError = Validations.validateIntFields(ExpireyDate.text);
                  cvvError = Validations.validateIntFields(CVV.text);
                  cardholderNameError = Validations.validateName(CardholderName.text);
                });

                if (cardNumberError.isEmpty &&
                    expiryDateError.isEmpty &&
                    cvvError.isEmpty &&
                    cardholderNameError.isEmpty) {
                  // All fields are valid, proceed with payment
                  // Add your payment logic here
                  print("Payment Successful!");
                } else {
                  // Show error message if any field is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fix the errors before proceeding."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: screenHeight * 0.005), // Responsive spacing

            // Cancel Payment
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle cancel payment
                },
                child: Text(
                  'Cancel Payment',
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: screenWidth * 0.035, // Responsive font size
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // Responsive spacing

            // Footer
            Center(
              child: Text(
                'By proceeding, you agree to our Terms and Privacy Policy',
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // Responsive font size
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.01), // Responsive spacing
            Center(
              child: Text(
                'Secure payment processing by Stripe',
                style: TextStyle(
                  fontSize: screenWidth * 0.03, // Responsive font size
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}