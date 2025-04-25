import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Screens/Payments/debit_card_details.dart';
import 'package:taqreeb/core/models/cart_model.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Cart cart;
  final Map<String, dynamic> bookingInfo;

  const OrderSummaryScreen({
    super.key,
    required this.cart,
    required this.bookingInfo,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Future<Map<String, dynamic>> _userFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    final response = await MyApi.getRequest(
        endpoint: 'accountInfo/$userId',
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        });
    return response;
  }

  double get _totalAmount {
    double total = 0;
    for (var item in widget.cart.items) {
      if (item.itemType == 'listing') {
        total += (item.itemDetails['priceMin'] ?? 0).toDouble();
      } else if (item.itemType == 'product') {
        total += (item.itemDetails['price'] ?? 0).toDouble() * item.quantity;
      } else if (item.itemType == 'package') {
        total += (item.itemDetails['price'] ?? 0).toDouble();
      }
    }
    return total;
  }

  Future<void> _proceedToPayment(bool isFullPayment) async {
    setState(() => _isLoading = true);

    try {
      final paymentAmount = isFullPayment ? _totalAmount : _totalAmount * 0.1;

      // Create the order first
      final orderResponse = await MyApi.postRequest(
        endpoint: 'create_order/',
        body: {
          'booking_info': widget.bookingInfo,
          'booking_date': widget.bookingInfo['selected_dates']
              [0], // Use first date
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
      );

      if (orderResponse['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecurePaymentScreen(
              orderId: orderResponse['order']['id'],
              amount: paymentAmount.toInt(),
              isFullPayment: isFullPayment,
            ),
          ),
        );
      } else {
        throw Exception(orderResponse['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: MyColors.dark,
      ),
      backgroundColor: MyColors.DarkLighter,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading user data'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(Screen.width(context) * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Items',
                  style: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.02),
                ...widget.cart.items.map((item) => _buildOrderItem(item)),
                SizedBox(height: Screen.height(context) * 0.03),
                Text(
                  'Booking Dates',
                  style: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.02),
                ...widget.bookingInfo['selected_dates'].map<Widget>((dateStr) {
                  final date = DateTime.parse(dateStr);
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: Screen.height(context) * 0.01),
                    child: Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: GoogleFonts.montserrat(
                        color: MyColors.white,
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: Screen.height(context) * 0.03),
                Text(
                  'Customer Information',
                  style: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.02),
                _buildInfoRow(
                    'Name', widget.bookingInfo['customer_info']['name']),
                _buildInfoRow(
                    'Email', widget.bookingInfo['customer_info']['email']),
                _buildInfoRow(
                    'Phone', widget.bookingInfo['customer_info']['phone']),
                SizedBox(height: Screen.height(context) * 0.03),
                Container(
                  padding: EdgeInsets.all(Screen.width(context) * 0.04),
                  decoration: BoxDecoration(
                    color: MyColors.dark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildTotalRow('Subtotal', _totalAmount),
                      _buildTotalRow('Tax', _totalAmount * 0.02),
                      Divider(color: Colors.grey),
                      _buildTotalRow('Total', _totalAmount * 1.02,
                          isTotal: true),
                    ],
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.04),
                if (!_isLoading) ...[
                  ColoredButton(
                    text: 'Pay 10% Advance',
                    onPressed: () => _proceedToPayment(false),
                  ),
                  SizedBox(height: Screen.height(context) * 0.02),
                  ColoredButton(
                    text: 'Pay Full Amount',
                    onPressed: () => _proceedToPayment(true),
                  ),
                ] else ...[
                  Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: Screen.height(context) * 0.02),
      child: Row(
        children: [
          Container(
            width: Screen.width(context) * 0.2,
            height: Screen.width(context) * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                  item.itemDetails['pictures']?[0]?['picturePath'] ?? '',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: Screen.width(context) * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemDetails['name'] ?? 'No Name',
                  style: GoogleFonts.montserrat(
                    color: MyColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.005),
                Text(
                  'Quantity: ${item.quantity}',
                  style: GoogleFonts.montserrat(
                    color: MyColors.white,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.005),
                Text(
                  '\$${_getItemPrice(item).toStringAsFixed(2)}',
                  style: GoogleFonts.montserrat(
                    color: MyColors.Yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getItemPrice(CartItem item) {
    if (item.itemType == 'listing') {
      return (item.itemDetails['priceMin'] ?? 0).toDouble() * item.quantity;
    } else if (item.itemType == 'product') {
      return (item.itemDetails['price'] ?? 0).toDouble() * item.quantity;
    } else if (item.itemType == 'package') {
      return (item.itemDetails['price'] ?? 0).toDouble() * item.quantity;
    }
    return 0.0;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Screen.height(context) * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: MyColors.white,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: MyColors.white,
              fontSize: isTotal
                  ? Screen.max(context) * 0.02
                  : Screen.max(context) * 0.018,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.montserrat(
              color: isTotal ? MyColors.Yellow : MyColors.white,
              fontSize: isTotal
                  ? Screen.max(context) * 0.02
                  : Screen.max(context) * 0.018,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
