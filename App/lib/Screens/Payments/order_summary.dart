import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/models/cart_model.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Future<Map<String, dynamic>> _userFuture;
  bool _isLoading = false;
  Cart? _cart;
  Map<String, dynamic>? _bookingInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchRouteArguments();
    _userFuture = _fetchUserData();
  }

  void _fetchRouteArguments() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      _cart = args['cart'] as Cart;
      _bookingInfo = args['bookingInfo'] as Map<String, dynamic>;
    } else {
      // Handle error or navigate back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
    final response = await MyApi.getRequest(
        context: context,
        endpoint: 'accountInfo/$userId',
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        });
    return response;
  }

  double get _totalAmount {
    if (_cart == null) return 0;

    double total = 0;
    for (var item in _cart!.items) {
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
    if (_cart == null || _bookingInfo == null) return;

    setState(() => _isLoading = true);

    try {
      final paymentAmount = isFullPayment ? _totalAmount : _totalAmount * 0.1;

      // Create the order first
      final orderResponse = await MyApi.postRequest(
        endpoint: 'create_order/',
        body: {
          'booking_info': _bookingInfo,
          'booking_date': _bookingInfo!['selected_dates'][0], // Use first date
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
      );

      if (orderResponse['status'] == 'success') {
        context.pushNamedTransition(
            routeName: '/PaymentDetails',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            arguments: {
              'orderId': orderResponse['order']['id'],
              'amount': paymentAmount.toInt(),
              'isFullPayment': isFullPayment,
            });
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
    if (_cart == null || _bookingInfo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final colors = AppColors(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: colors.dark,
      ),
      backgroundColor: colors.darkLighter,
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
                  style: GoogleFonts.roboto(
                    color: colors.white,
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.02),
                ..._cart!.items.map((item) => _buildOrderItem(item)),
                SizedBox(height: Screen.height(context) * 0.03),
                Text(
                  'Booking Dates',
                  style: GoogleFonts.roboto(
                    color: colors.white,
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.02),
                ..._bookingInfo!['selected_dates'].map<Widget>((dateStr) {
                  final date = DateTime.parse(dateStr);
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: Screen.height(context) * 0.01),
                    child: Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: GoogleFonts.roboto(
                        color: colors.white,
                      ),
                    ),
                  );
                }).toList(),
                SizedBox(height: Screen.height(context) * 0.03),
                Text(
                  'Customer Information',
                  style: GoogleFonts.roboto(
                    color: colors.white,
                    fontSize: Screen.max(context) * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.02),
                _buildInfoRow('Name', _bookingInfo!['customer_info']['name']),
                _buildInfoRow('Email', _bookingInfo!['customer_info']['email']),
                _buildInfoRow('Phone', _bookingInfo!['customer_info']['phone']),
                SizedBox(height: Screen.height(context) * 0.03),
                Container(
                  padding: EdgeInsets.all(Screen.width(context) * 0.04),
                  decoration: BoxDecoration(
                    color: colors.dark,
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
    final colors = AppColors(context);

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
                  style: GoogleFonts.roboto(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.005),
                Text(
                  'Quantity: ${item.quantity}',
                  style: GoogleFonts.roboto(
                    color: colors.white,
                  ),
                ),
                SizedBox(height: Screen.height(context) * 0.005),
                Text(
                  '\$${_getItemPrice(item).toStringAsFixed(2)}',
                  style: GoogleFonts.roboto(
                    color: colors.yellow,
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
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.015,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: Screen.max(context) * 0.015,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    final colors = AppColors(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              color: colors.white,
              fontSize: isTotal
                  ? Screen.max(context) * 0.02
                  : Screen.max(context) * 0.018,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.roboto(
              color: isTotal ? colors.yellow : colors.white,
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
