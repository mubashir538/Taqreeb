import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class OrderSummaryController {
  String listingName = '';
  int listingPrice = 0;
  int listingId = 0;
  String listingType = '';
  String token = '';
  Map<String, dynamic> user = {};
  bool isLoading = true;

  Future<void> fetchUserData() async {
    try {
      final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      await ApiCall.fetchAPI('accountInfo/$userId', onSuccess: (token, data) {
        this.token = token;
        user = data;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }

  void setListingDetails(Map<String, dynamic> args) {
    listingName = args['Name'] ?? '';
    listingPrice = args['price'] ?? 0;
    listingType = args['type'] ?? '';
    listingId = args['id'] ?? 0;
  }
}

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final OrderSummaryController _controller = OrderSummaryController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _controller.setListingDetails(args);
  }

  Future<void> _loadData() async {
    await _controller.fetchUserData();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.dark,
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Header(heading: "Order Summary"),
            _buildVerticalSpace(0.02),
            _buildEventDetailsSection(),
            _buildVerticalSpace(0.03),
            _buildCustomerInfoSection(),
            _buildVerticalSpace(0.03),
            _buildPaymentButtons(),
            _buildVerticalSpace(0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalSpace(double heightFactor) {
    return SizedBox(height: Screen.height(context) * heightFactor);
  }

  Widget _buildEventDetailsSection() {
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
          _buildSectionTitle('Event Details'),
          _buildVerticalSpace(0.02),
          _buildDetailRow('Service Name', _controller.listingName),
          _buildDetailRow('Service Type', _controller.listingType),
          _buildDetailRow('Price', _controller.listingPrice.toString()),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoSection() {
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
          _buildSectionTitle('Customer Information'),
          _buildVerticalSpace(0.02),
          _buildDetailRow(
            'Name',
            '${_controller.user['firstName']} ${_controller.user['lastName']}',
          ),
          _buildDetailRow('Contact',
              '${_controller.user['email'].substring(0, 3)}***${_controller.user['email'].substring(_controller.user['email'].length - 4, _controller.user['email'].length)}'),
          _buildDetailRow('Location', 'Karachi, Pakistan'),
        ],
      ),
    );
  }

  Widget _buildPaymentButtons() {
    return Column(
      children: [
        ColoredButton(
          text: "Pay 10% Advance",
          onPressed: () {
            int payment = (_controller.listingPrice * 0.1).toInt();
            _navigateToPayment('/PaymentDetails',
                {'amount': payment, 'listing': _controller.listingId});
          },
        ),
        _buildVerticalSpace(0.02),
        ColoredButton(
          text: "Pay Full Amount",
          onPressed: () {
            _navigateToPayment('/PaymentDetails', {
              'amount': _controller.listingPrice,
              'listing': _controller.listingId
            });
          },
        ),
      ],
    );
  }

  void _navigateToPayment(String route, Map<String, dynamic> arguments) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontSize: Screen.max(context) * 0.015,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose any resources if needed
  }
}
