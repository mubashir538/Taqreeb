import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Cards/c_calendar.dart';
import 'package:taqreeb/Screens/Payments/order_summary.dart';
import 'package:taqreeb/core/models/cart_model.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/utils/color.dart';

class BookingInformationScreen extends StatefulWidget {
  final Cart cart;

  const BookingInformationScreen({super.key, required this.cart});

  @override
  State<BookingInformationScreen> createState() =>
      _BookingInformationScreenState();
}

class _BookingInformationScreenState extends State<BookingInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Map<DateTime, List<CartItem>> _selectedDates = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill user info if available
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // You can implement this to pre-fill user info from storage
  }

  void _handleDateSelection(DateTime date, CartItem item) {
    setState(() {
      if (_selectedDates.containsKey(date)) {
        if (_selectedDates[date]!.contains(item)) {
          _selectedDates[date]!.remove(item);
          if (_selectedDates[date]!.isEmpty) {
            _selectedDates.remove(date);
          }
        } else {
          _selectedDates[date]!.add(item);
        }
      } else {
        _selectedDates[date] = [item];
      }
    });
  }

  bool _validateForm() {
    // Add your validation logic here
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  Future<void> _proceedToPayment() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Prepare booking info
      final bookingInfo = {
        'customer_info': {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'id_number': _idNumberController.text,
          'notes': _notesController.text,
        },
        'selected_dates':
            _selectedDates.keys.map((date) => date.toIso8601String()).toList(),
      };

      // Navigate to order summary with the booking info
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryScreen(
            cart: widget.cart,
            bookingInfo: bookingInfo,
          ),
        ),
      );
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
        title: Text('Booking Information'),
        backgroundColor: MyColors.dark,
      ),
      backgroundColor: MyColors.DarkLighter,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(Screen.width(context) * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontSize: Screen.max(context) * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Screen.height(context) * 0.02),
                  MyTextBox(
                    hint: 'Full Name',
                    valueController: _nameController,
                  ),
                  SizedBox(height: Screen.height(context) * 0.015),
                  MyTextBox(
                    hint: 'Email Address',
                    valueController: _emailController,
                  ),
                  SizedBox(height: Screen.height(context) * 0.015),
                  MyTextBox(
                    hint: 'Phone Number',
                    valueController: _phoneController,
                    isNum: true,
                  ),
                  SizedBox(height: Screen.height(context) * 0.015),
                  MyTextBox(
                    hint: 'ID Number (Optional)',
                    valueController: _idNumberController,
                  ),
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
                  ...widget.cart.items
                      .map((item) => _buildItemDateSelector(item)),
                  SizedBox(height: Screen.height(context) * 0.03),
                  Text(
                    'Additional Notes',
                    style: GoogleFonts.montserrat(
                      color: MyColors.white,
                      fontSize: Screen.max(context) * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Screen.height(context) * 0.02),
                  MyTextBox(
                    hint: 'Special requests or notes',
                    valueController: _notesController,
                  ),
                  SizedBox(height: Screen.height(context) * 0.04),
                  ColoredButton(
                    text: 'Continue to Payment',
                    onPressed: _proceedToPayment,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildItemDateSelector(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.itemDetails['name'],
          style: GoogleFonts.montserrat(
            color: MyColors.white,
            fontSize: Screen.max(context) * 0.02,
          ),
        ),
        SizedBox(height: Screen.height(context) * 0.01),
        Container(
          padding: EdgeInsets.all(Screen.width(context) * 0.03),
          decoration: BoxDecoration(
            color: MyColors.dark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CalendarView(
            bookedDates: (item.itemDetails['booked_dates'] ?? [])
                .map((date) => DateTime.parse(date))
                .toList(),
            onDateSelected: (date) => _handleDateSelection(date, item),
            isSelectionMode: true,
          ),
        ),
        SizedBox(height: Screen.height(context) * 0.02),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idNumberController.dispose();
    _notesController.dispose();
  super.dispose();
  }
}
