import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Cards/c_calendar.dart';
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

  final Map<DateTime, List<CartItem>> _selectedDates = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Implement user info loading if needed
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
    // Validate all required fields
    bool isValid = _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;

    // Validate that listings have selected dates
    bool hasListingDates = true;
    for (var item in widget.cart.items) {
      if (item.itemType == 'listing' &&
          !_selectedDates.values.any((items) => items.contains(item))) {
        hasListingDates = false;
        break;
      }
    }

    return isValid && hasListingDates;
  }

  Future<void> _proceedToPayment() async {
    if (!_validateForm()) {
      String errorMessage = 'Please fill all required fields';

      // Check if listings have dates selected
      for (var item in widget.cart.items) {
        if (item.itemType == 'listing' &&
            !_selectedDates.values.any((items) => items.contains(item))) {
          errorMessage = 'Please select dates for all listings';
          break;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
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
        'selected_items': _selectedDates.entries
            .map((entry) => {
                  'date': entry.key.toIso8601String(),
                  'items': entry.value.map((item) => item.id).toList(),
                })
            .toList(),
      };

      context.pushNamedTransition(
          routeName: '/OrderSummary',
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 300),
          arguments: {
            'cart': widget.cart,
            'bookingInfo': bookingInfo,
          });
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
    final colors = AppColors(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Information'),
        backgroundColor: colors.dark,
      ),
      backgroundColor: colors.darkLighter,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(Screen.width(context) * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),
                  SizedBox(height: Screen.height(context) * 0.02),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.user,
                    hint: 'Full Name',
                    valueController: _nameController,
                  ),
                  SizedBox(height: Screen.height(context) * 0.015),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.envelope,
                    hint: 'Email Address',
                    valueController: _emailController,
                  ),
                  SizedBox(height: Screen.height(context) * 0.015),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.phone,
                    hint: 'Phone Number',
                    valueController: _phoneController,
                    isNum: true,
                  ),
                  SizedBox(height: Screen.height(context) * 0.015),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.addressCard,
                    hint: 'ID Number',
                    valueController: _idNumberController,
                  ),
                  SizedBox(height: Screen.height(context) * 0.03),

                  // Booking Dates Section (only for listings)
                  if (widget.cart.items
                      .any((item) => item.itemType == 'listing'))
                    _buildSectionTitle('Booking Dates'),
                  SizedBox(height: Screen.height(context) * 0.02),
                  ...widget.cart.items.map((item) {
                    if (item.itemType == 'listing') {
                      return _buildItemDateSelector(item);
                    } else {
                      return _buildNonDateItem(item);
                    }
                  }),

                  // Additional Notes Section
                  SizedBox(height: Screen.height(context) * 0.03),
                  _buildSectionTitle('Additional Notes'),
                  SizedBox(height: Screen.height(context) * 0.02),
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.noteSticky,
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

  Widget _buildSectionTitle(String title) {
    final colors = AppColors(context);
    return Text(
      title,
      style: GoogleFonts.roboto(
        color: colors.white,
        fontSize: Screen.max(context) * 0.025,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildItemDateSelector(CartItem item) {
    final colors = AppColors(context);

    return item.itemDetails['booked_dates'].length == 0
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.itemDetails['name'] ?? 'Unnamed Listing',
                style: GoogleFonts.roboto(
                  color: colors.white,
                  fontSize: Screen.max(context) * 0.02,
                ),
              ),
              SizedBox(height: Screen.height(context) * 0.01),
              Container(
                padding: EdgeInsets.all(Screen.width(context) * 0.03),
                decoration: BoxDecoration(
                  color: colors.dark,
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

  Widget _buildNonDateItem(CartItem item) {
    final colors = AppColors(context);

    return Padding(
      padding: EdgeInsets.only(bottom: Screen.height(context) * 0.02),
      child: Row(
        children: [
          Icon(
            item.itemType == 'product'
                ? FontAwesomeIcons.box
                : FontAwesomeIcons.boxesStacked,
            color: colors.white,
            size: Screen.max(context) * 0.03,
          ),
          SizedBox(width: Screen.width(context) * 0.03),
          Expanded(
            child: Text(
              '${item.itemDetails['name'] ?? 'Unnamed ${item.itemType}'} (Qty: ${item.quantity})',
              style: GoogleFonts.roboto(
                color: colors.white,
                fontSize: Screen.max(context) * 0.02,
              ),
            ),
          ),
        ],
      ),
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
