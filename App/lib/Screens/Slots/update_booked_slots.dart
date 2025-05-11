import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_calendar.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_dropdown.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class ManageBookedSlotsScreen extends StatefulWidget {
  const ManageBookedSlotsScreen({super.key});

  @override
  State<ManageBookedSlotsScreen> createState() =>
      _ManageBookedSlotsScreenState();
}

class _ManageBookedSlotsScreenState extends State<ManageBookedSlotsScreen> {
  List<dynamic> listings = [];
  Map<String, dynamic>? selectedListing;
  List<DateTime> bookedDates = [];
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    try {
      final userId = await MyStorage.getToken(MyTokens.userId) ?? "";
      final type = await MyTokens.getBusinessType();

      await ApiCall.fetchAPI('YourListing/$userId/$type',
          onSuccess: (token, data) {
        setState(() {
          listings = data['YourListings'];
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load listings: $e')),
      );
    }
  }

  Future<void> _saveBookedDates() async {
    if (selectedListing == null) {
      MyScaffold(text: 'Please select a listing').show(context);
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final dates = bookedDates.map((date) => date.toIso8601String()).toList();

      final response = await MyApi.postRequest(
        endpoint: 'update_booking_status/${selectedListing!['id']}',
        body: {'dates': dates},
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
        },
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booked dates updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update booked dates: $e')),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      if (bookedDates.any((d) => _isSameDate(d, date))) {
        bookedDates.removeWhere((d) => _isSameDate(d, date));
      } else {
        bookedDates.add(date);
      }
    });
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onListingSelected(String? value) {
    if (value == null) return;

    final listing = listings.firstWhere(
      (l) => l['name'] == value,
      orElse: () => null,
    );

    if (listing != null) {
      setState(() {
        selectedListing = listing;
        bookedDates = (listing['booked_dates'] as List<dynamic>?)
                ?.map((date) => DateTime.parse(date))
                .toList() ??
            [];
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.yellow,
      ),
    );
  }

  Widget _buildListingDropdown() {
    return ResponsiveDropdown(
      items: listings.map((listing) => listing['name'].toString()).toList(),
      labelText: 'Select Listing',
      onChanged: _onListingSelected,
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Screen.max(context) * 0.02,
        horizontal: Screen.max(context) * 0.01,
      ),
      child: CalendarView(
        onDateSelected: _handleDateSelected,
        bookedDates: bookedDates,
        isSelectionMode: true,
      ),
    );
  }

  Widget _buildSaveButton() {
    return ColoredButton(
      text: isSaving ? 'Saving...' : 'Save Changes',
      width: Screen.width(context) * 0.6,
      onPressed: isSaving ? null : _saveBookedDates,
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.05,
        vertical: Screen.height(context) * 0.02,
      ),
      child: Text(
        'Tap on dates to mark them as booked. Tap again to unmark.',
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.02,
          color: MyColors.yellow,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Booked Slots',
          style: GoogleFonts.roboto(
            color: MyColors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? _buildLoadingIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Screen.max(context) * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildListingDropdown(),
                    SizedBox(height: Screen.height(context) * 0.03),
                    _buildInstructions(),
                    _buildCalendar(),
                    SizedBox(height: Screen.height(context) * 0.05),
                    Center(child: _buildSaveButton()),
                  ],
                ),
              ),
            ),
    );
  }
}
