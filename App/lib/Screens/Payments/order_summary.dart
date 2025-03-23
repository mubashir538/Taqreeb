import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/api_service.dart';
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
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final Userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    final user = await MyApi.getRequest(
        endpoint: 'accountInfo/$Userid',
        headers: {'Authorization': 'Bearer $token'});

    setState(() {
      this.token = token;
      this.user = user ?? {};
      if (user == null || user['status'] == 'error') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something Went Wrong!',
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: MyColors.white,
                  fontWeight: FontWeight.w400)),
          backgroundColor: MyColors.red,
        ));
        return;
      } else {
        isLoading = false;
      }
    });
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
    print("${listingname} + ${listingprice} + ${listingtype}");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                    SizedBox(height: screenHeight * 0.02), // Responsive spacing

                    // Event Details Section
                    Container(
                      width: screenWidth * 0.9, // 90% of screen width
                      padding: EdgeInsets.all(
                          screenWidth * 0.04), // Responsive padding
                      decoration: BoxDecoration(
                        color: MyColors
                            .DarkLighter, // Use your card background color
                        borderRadius: BorderRadius.circular(
                            screenWidth * 0.02), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Details',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.045, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                              height:
                                  screenHeight * 0.02), // Responsive spacing
                          _buildDetailRow('Service Name', listingname),
                          _buildDetailRow('Service Type', listingtype),
                          _buildDetailRow('Price', listingprice.toString()),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Responsive spacing

                    // Service Breakdown Section
                    // Container(
                    //   width: screenWidth * 0.9, // 90% of screen width
                    //   padding:
                    //       EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                    //   decoration: BoxDecoration(
                    //     color: MyColors.DarkLighter, // Use your card background color
                    //     borderRadius: BorderRadius.circular(
                    //         screenWidth * 0.02), // Rounded corners
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Service Breakdown',
                    //         style: TextStyle(
                    //           fontSize: screenWidth * 0.045, // Responsive font size
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       SizedBox(height: screenHeight * 0.02), // Responsive spacing
                    //       _buildDetailRow('Venue Rental', '\$3,500'),
                    //       _buildDetailRow('Catering Service', '\$4,500'),
                    //       _buildDetailRow('Decoration', '\$1,200'),
                    //       _buildDetailRow('Photography', '\$800'),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: screenHeight * 0.03), // Responsive spacing

                    // Customer Information Section
                    Container(
                      width: screenWidth * 0.9, // 90% of screen width
                      padding: EdgeInsets.all(
                          screenWidth * 0.04), // Responsive padding
                      decoration: BoxDecoration(
                        color: MyColors
                            .DarkLighter, // Use your card background color
                        borderRadius: BorderRadius.circular(
                            screenWidth * 0.02), // Rounded corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.045, // Responsive font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                              height:
                                  screenHeight * 0.02), // Responsive spacing
                          _buildDetailRow('Name', user['firstName'] + " " + user['lastName']),
                          _buildDetailRow('Contact', user['email']),
                          _buildDetailRow('Location', 'Karachi, Pakistan'),
                          Row(
                            children: [
                              Text(
                                'Secure Payment',
                                style: TextStyle(
                                  fontSize: screenWidth *
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
                    SizedBox(height: screenHeight * 0.03), // Responsive spacing

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
                        SizedBox(height: screenHeight * 0.02),
                        ColoredButton(
                          text: "Pay Full Amount ",
                          onPressed: () {
                            Navigator.pushNamed(context,
                                '/paymentdetails'); // Navigate to SecondScreen
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
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
