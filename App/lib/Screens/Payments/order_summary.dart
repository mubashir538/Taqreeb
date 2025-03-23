import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  String listingname = '';
  int listingprice = 0;
  String listingtype = '';
  String token = '';
  Map<String, dynamic> user = {};
  bool isLoading = true;

  void fetchData() async {
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    ApiCall.fetchAPI('accountInfo/$userid', onSuccess: (token, data) {
      if (mounted) {
        setState(() {
          token = token;
          user = data;
          isLoading = false;
        });
      }
    }, context: mounted ? context : null);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      listingname = args['Name'];
      listingprice = args['price'];
      listingtype = args['type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: SingleChildScrollView(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Order Summary Title
                    Header(heading: "Order Summary"),
                    SizedBox(
                        height: Screen.height(context) *
                            0.02), // Responsive spacing

                    // Event Details Section
                    Container(
                      width: Screen.width(context) * 0.9, // 90% of screen width
                      padding: EdgeInsets.all(
                          Screen.width(context) * 0.04), // Responsive padding
                      decoration: BoxDecoration(
                        color: MyColors
                            .DarkLighter, // Use your card background color
                        borderRadius: BorderRadius.circular(
                            Screen.width(context) * 0.02), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Details',
                            style: TextStyle(
                              fontSize: Screen.width(context) *
                                  0.045, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                              height: Screen.height(context) *
                                  0.02), // Responsive spacing
                          _buildDetailRow('Service Name', listingname),
                          _buildDetailRow('Service Type', listingtype),
                          _buildDetailRow('Price', listingprice.toString()),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: Screen.height(context) *
                            0.03), // Responsive spacing

                    // Service Breakdown Section
                    // Container(
                    //   width: Screen.width(context) * 0.9, // 90% of screen width
                    //   padding:
                    //       EdgeInsets.all(Screen.width(context) * 0.04), // Responsive padding
                    //   decoration: BoxDecoration(
                    //     color: MyColors.DarkLighter, // Use your card background color
                    //     borderRadius: BorderRadius.circular(
                    //         Screen.width(context) * 0.02), // Rounded corners
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Service Breakdown',
                    //         style: TextStyle(
                    //           fontSize: Screen.width(context) * 0.045, // Responsive font size
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       SizedBox(height: Screen.height(context) * 0.02), // Responsive spacing
                    //       _buildDetailRow('Venue Rental', '\$3,500'),
                    //       _buildDetailRow('Catering Service', '\$4,500'),
                    //       _buildDetailRow('Decoration', '\$1,200'),
                    //       _buildDetailRow('Photography', '\$800'),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: Screen.height(context) * 0.03), // Responsive spacing

                    // Customer Information Section
                    Container(
                      width: Screen.width(context) * 0.9, // 90% of screen width
                      padding: EdgeInsets.all(
                          Screen.width(context) * 0.04), // Responsive padding
                      decoration: BoxDecoration(
                        color: MyColors
                            .DarkLighter, // Use your card background color
                        borderRadius: BorderRadius.circular(
                            Screen.width(context) * 0.02), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize: Screen.width(context) *
                                  0.045, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                              height: Screen.height(context) *
                                  0.02), // Responsive spacing
                          _buildDetailRow('Name',
                              user['firstName'] + " " + user['lastName']),
                          _buildDetailRow('Contact', user['email']),
                          _buildDetailRow('Location', 'Karachi, Pakistan'),
                          Row(
                            children: [
                              Text(
                                'Secure Payment',
                                style: TextStyle(
                                  fontSize: Screen.width(context) *
                                      0.035, // Responsive font size
                                  color: Colors.grey,
                                ),
                              ),
                              Checkbox(
                                value:
                                    false, // Set to true if payment is secure
                                onChanged: (value) {
                                  // Handle checkbox state
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: Screen.height(context) *
                            0.03), // Responsive spacing

                    // Payment Buttons
                    Column(
                      children: [
                        ColoredButton(
                          text: "Pay 10% Advance ",
                          onPressed: () {
                            Navigator.pushNamed(context,
                                '/paymentdetails'); // Navigate to SecondScreen
                          },
                        ),
                        SizedBox(height: Screen.height(context) * 0.02),
                        ColoredButton(
                          text: "Pay Full Amount ",
                          onPressed: () {
                            Navigator.pushNamed(context,
                                '/paymentdetails'); // Navigate to SecondScreen
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: Screen.height(context) * 0.03),
                  ],
                ),
        ),
      ),
    );
  }

  // Helper method to build a detail row
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
