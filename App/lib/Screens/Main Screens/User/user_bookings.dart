import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  State<UserBookingsScreen> createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
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
          endpoint: 'user/bookings',
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

  Future<void> _cancelBooking(String bookingId) async {
    try {
      await MyApi.postRequest(
        endpoint: 'cancel_booking/$bookingId',
        body: {},
        headers: {'Authorization': 'Bearer $_token'},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled successfully')),
      );
      _loadBookings(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $e')),
      );
    }
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final bookingDate = DateTime.parse(booking['booking_date']);
    final canCancel = bookingDate.isAfter(DateTime.now());
    final status = booking['status'];
    final item = booking['listing'] ?? booking['product'] ?? booking['package'];
    final hasReviewed = booking['has_reviewed'] ?? false;
    final isCompleted = status == 'completed';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: MyColors.DarkLighter,
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
              'Date: ${DateFormat('MMM dd, yyyy').format(bookingDate)}',
              style: TextStyle(color: MyColors.white),
            ),
            Text(
              'Time: ${DateFormat('hh:mm a').format(bookingDate)}',
              style: TextStyle(color: MyColors.white),
            ),
            Text(
              'Status: ${status.toUpperCase()}',
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (canCancel && status == 'confirmed')
              ColoredButton(
                text: 'Cancel Booking',
                onPressed: () => _showCancelDialog(booking['id']),
              ),
            if (isCompleted && !hasReviewed)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'How was your experience?',
                    style: TextStyle(color: MyColors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          _selectedRatings[booking['id']] != null &&
                                  index < _selectedRatings[booking['id']]!
                              ? Icons.star
                              : Icons.star_border,
                          color: MyColors.Yellow,
                        ),
                        onPressed: () => _setRating(booking['id'], index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  MyTextBox(
                    hint: 'Write your review (optional)',
                    valueController: _reviewControllers[booking['id']] ??=
                        TextEditingController(),
                  ),
                  const SizedBox(height: 8),
                  ColoredButton(
                    text: 'Submit Review',
                    onPressed: () => _submitReview(
                        booking['id'], item['listingId'] ?? item['id']),
                  ),
                ],
              ),
            if (hasReviewed)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Thanks for your review!',
                  style: TextStyle(color: MyColors.Yellow),
                ),
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
      case 'pending':
        return MyColors.Yellow;
      default:
        return MyColors.white;
    }
  }

  void _showCancelDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MyColors.dark,
        title: Text(
          'Cancel Booking',
          style: TextStyle(color: MyColors.white),
        ),
        content: Text(
          'Are you sure you want to cancel this booking?',
          style: TextStyle(color: MyColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: TextStyle(color: MyColors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking(bookingId);
            },
            child: Text('Yes', style: TextStyle(color: MyColors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: MyColors.dark,
      ),
      backgroundColor: MyColors.dark,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? Center(
                  child: Text(
                    'No bookings found',
                    style: TextStyle(color: MyColors.white),
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

  final Map<String, int?> _selectedRatings = {};
  final Map<String, TextEditingController> _reviewControllers = {};

  void _setRating(String bookingId, int rating) {
    setState(() {
      _selectedRatings[bookingId] = rating;
    });
  }

  Future<void> _submitReview(String bookingId, String listingId) async {
    final rating = _selectedRatings[bookingId];
    final reviewText = _reviewControllers[bookingId]?.text ?? '';

    if (rating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    try {
      final userId = await MyStorage.getToken(MyTokens.userId);
      await MyApi.postRequest(
        endpoint: 'Reviews/add',
        body: {
          'review': reviewText,
          'rating': rating,
          'listingId': listingId,
          'userId': userId,
        },
      );

      // Mark booking as reviewed
      await MyApi.postRequest(
        endpoint: 'Reviews/MarkBooking',
        body: {'booking_id': bookingId},
        headers: {'Authorization': 'Bearer $_token'},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );

      _loadBookings(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
