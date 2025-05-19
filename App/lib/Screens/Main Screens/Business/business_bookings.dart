import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class BusinessBookingsScreen extends StatefulWidget {
  const BusinessBookingsScreen({super.key});

  @override
  State<BusinessBookingsScreen> createState() => _BusinessBookingsScreenState();
}

class _BusinessBookingsScreenState extends State<BusinessBookingsScreen> {
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    _token = await MyStorage.getToken(MyTokens.accessToken);
    try {
      final response = await MyApi.getRequest(
          context: context,
          endpoint: 'business/bookings',
          headers: {
            'Authorization': 'Bearer $_token',
          });
      setState(() {
        _bookings = response['bookings'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load bookings: $e')),
      );
    }
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    try {
      await MyApi.postRequest(
        endpoint: 'update_booking_status/$bookingId',
        body: {'status': status},
        headers: {'Authorization': 'Bearer $_token'},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking status updated to $status')),
      );
      _loadBookings(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final bookingDate = DateTime.parse(booking['booking_date']);
    final status = booking['status'];
    final item = booking['listing'] ?? booking['product'] ?? booking['package'];
    final user = booking['user'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: MyColors.darkLighter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['name'],
              style: GoogleFonts.roboto(
                color: MyColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customer: ${user['firstName']} ${user['lastName']}',
              style: GoogleFonts.roboto(color: MyColors.white),
            ),
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(bookingDate)}',
              style: GoogleFonts.roboto(color: MyColors.white),
            ),
            Text(
              'Time: ${DateFormat('hh:mm a').format(bookingDate)}',
              style: GoogleFonts.roboto(color: MyColors.white),
            ),
            Text(
              'Status: ${status.toUpperCase()}',
              style: GoogleFonts.roboto(
                color: _getStatusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (status == 'pending')
              Row(
                children: [
                  Expanded(
                    child: ColoredButton(
                      text: 'Confirm',
                      onPressed: () =>
                          _updateBookingStatus(booking['id'], 'confirmed'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ColoredButton(
                      text: 'Reject',
                      onPressed: () =>
                          _updateBookingStatus(booking['id'], 'cancelled'),
                    ),
                  ),
                ],
              ),
            if (status == 'confirmed' && bookingDate.isAfter(DateTime.now()))
              ColoredButton(
                text: 'Mark as Completed',
                onPressed: () =>
                    _updateBookingStatus(booking['id'], 'completed'),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return MyColors.green;
      case 'cancelled':
        return MyColors.red;
      case 'completed':
        return MyColors.green;
      default:
        return MyColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Bookings'),
        backgroundColor: MyColors.dark,
      ),
      backgroundColor: MyColors.dark,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(
                  child: Text(
                    'No bookings found',
                    style: GoogleFonts.roboto(color: MyColors.white),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBookings,
                  child: ListView.builder(
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) =>
                        _buildBookingCard(_bookings[index]),
                  ),
                ),
    );
  }
}
