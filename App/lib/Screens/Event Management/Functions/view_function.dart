import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Cards/c_listing_card.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/utils/images.dart';

class FunctionDetail extends StatefulWidget {
  const FunctionDetail({super.key});

  @override
  State<FunctionDetail> createState() => _FunctionDetailState();
}

class _FunctionDetailState extends State<FunctionDetail> {
  final GlobalKey _headerKey = GlobalKey();
  final List<Map<String, dynamic>> _bookingList = [];

  String _token = '';
  Map<String, dynamic> _functionDetails = {};
  Map<String, dynamic> _bookings = {};
  int _functionId = 0;
  int _eventId = 0;
  String _eventName = '';
  bool _isLoading = true;
  bool _dataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeFromArguments();
  }

  Future<void> _fetchBookings() async {
    await ApiCall.fetchAPI(
      'show/Bookcart/$_functionId',
      onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            _bookings = data; // Store the complete response
            _bookingList.addAll(data['cart'] ?? []); // Use the stored data
          });
        }
      },
      context: mounted ? context : null,
    );
  }

  void _initializeFromArguments() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (!_dataFetched) {
      setState(() {
        _functionId = args['fid'];
        _eventName = args['event'];
        _eventId = args['eventid'];
      });
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _fetchFunctionDetails(),
      _fetchBookings(),
    ]);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _dataFetched = true;
      });
    }
  }

  Future<void> _fetchFunctionDetails() async {
    await ApiCall.fetchAPI(
      'ViewFunction/$_functionId',
      onSuccess: (token, data) {
        if (mounted) {
          setState(() {
            _token = token;
            _functionDetails = data;
          });
        }
      },
      context: mounted ? context : null,
    );
  }

  void _updateHeaderHeight(RenderBox renderBox) {
    if (mounted) {
      setState(() => UI_Management.headerHeight = renderBox.size.height);
    }
  }

  void _navigateToGuestList() async {
    final response = await MyApi.postRequest(
      endpoint: 'show/guest/',
      headers: {'Authorization': 'Bearer $_token'},
      body: {
        'EventId': _eventId,
        'FunctionID': _functionId,
      },
    );

    if (!mounted) return;

    final routeName = response["Guests"].isEmpty
        ? '/CreateGuestList'
        : '/CreateGuestList_List';

    Navigator.pushNamed(
      context,
      routeName,
      arguments: {
        'eventId': _eventId,
        'functionid': _functionId,
      },
    );
  }

  void _navigateToChecklist() {
    Navigator.pushNamed(
      context,
      '/CreateChecklistItems',
      arguments: {
        'eventId': _eventId,
        'functionid': _functionId,
      },
    );
  }

  void _navigateToAddNewItem() {
    Navigator.pushNamed(context, '/SearchService');
  }

  @override
  Widget build(BuildContext context) {
    UI_Management.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.Dark,
      body: Stack(
        children: [
          _buildContent(),
          Positioned(
            top: 0,
            child: Header(
              key: _headerKey,
              heading: "Your Function Details",
              image: MyImages.CheckList,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        width: Screen.width(context),
        child: Column(
          children: [
            SizedBox(height: UI_Management.headerHeight),
            _isLoading ? _buildLoadingIndicator() : _buildFunctionDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(MyColors.white),
      ),
    );
  }

  Widget _buildFunctionDetails() {
    final function = _functionDetails['Fuctions'] ?? {};
    final headings = ['Function Type', 'Guests', 'Date'];
    final values = [
      function['type'] ?? '',
      '${function['guestsmin'] ?? ''}-${function['guestsmax'] ?? ''}',
      function['date'] ?? '',
    ];

    return Column(
      children: [
        _buildEventHeader(),
        _buildFunctionCard(function, headings, values),
        SizedBox(height: Screen.height(context) * 0.05),
        _buildAddNewItemButton(),
      ],
    );
  }

  Widget _buildEventHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.03),
      child: Text(
        _eventName,
        style: GoogleFonts.montserrat(
          fontSize: Screen.max(context) * 0.03,
          fontWeight: FontWeight.w700,
          color: MyColors.Yellow,
        ),
      ),
    );
  }

  Widget _buildFunctionCard(
    Map<String, dynamic> function,
    List<String> headings,
    List<dynamic> values,
  ) {
    return Container(
      width: Screen.width(context) * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: MyColors.DarkLighter,
      ),
      child: Column(
        children: [
          _buildFunctionHeader(function),
          _buildFunctionBody(headings, values),
        ],
      ),
    );
  }

  Widget _buildFunctionHeader(Map<String, dynamic> function) {
    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(vertical: Screen.height(context) * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: MyColors.red,
      ),
      child: Center(
        child: Text(
          function['type'] ?? '',
          style: GoogleFonts.montserrat(
            fontSize: Screen.max(context) * 0.02,
            fontWeight: FontWeight.w600,
            color: MyColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionBody(List<String> headings, List<dynamic> values) {
    return Container(
      width: Screen.width(context) * 0.9,
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _buildBudgetRow(),
          ..._buildInfoRows(headings, values),
          MyDivider(width: Screen.width(context) * 0.1),
          ..._buildBookingList(),
          MyDivider(width: Screen.width(context) * 0.6),
          SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildBudgetRow() {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Budget',
            style: _buildTextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            _functionDetails['Fuctions']?['budget']?.toString() ?? '',
            style: _buildTextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInfoRows(List<String> headings, List<dynamic> values) {
    return headings.map((heading) {
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: Screen.max(context) * 0.005,
          horizontal: Screen.max(context) * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              heading,
              style: _buildTextStyle(
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            Text(
              values[headings.indexOf(heading)],
              style: _buildTextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildBookingList() {
    return _bookingList.map((booking) {
      return Column(
        children: [
          Text(
            booking['type'].toString(),
            style: GoogleFonts.montserrat(
              fontSize: Screen.max(context) * 0.02,
              fontWeight: FontWeight.w600,
              color: MyColors.Yellow,
            ),
          ),
          Productcard(
            mywidth: Screen.width(context) * 0.85,
            listingType: booking['listing']?['type']?.toString() ?? '',
            listingid: booking['listing']?['id']?.toString() ?? '',
            imageUrl: _getBookingImageUrl(booking),
            venueName: booking['listing']?['name'] ?? '',
            location: booking['listing']?['location'] ?? '',
            type: booking['listing']?['type']?.toString() ?? '',
          ),
        ],
      );
    }).toList();
  }

  String _getBookingImageUrl(Map<String, dynamic> booking) {
    if (booking['pictures'] != null &&
        booking['pictures'].isNotEmpty &&
        booking['pictures'][0]['picturePath'] != " ") {
      return '${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${booking['pictures'][0]['picturePath']}';
    }
    return "https://picsum.photos/id/${DateTime.now().millisecondsSinceEpoch % 100}/600/300";
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          text: "View GuestList",
          onTap: _navigateToGuestList,
        ),
        _buildActionButton(
          text: "View CheckList",
          onTap: _navigateToChecklist,
        ),
        _buildActionButton(
          text: "Create Invitation Card",
          onTap: () => Navigator.pushNamed(context, '/InvitationCardEdit'),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String text, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      padding: EdgeInsets.symmetric(
        vertical: Screen.height(context) * 0.01,
        horizontal: Screen.width(context) * 0.03,
      ),
      decoration: BoxDecoration(
        color: MyColors.DarkLighter,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      width: Screen.width(context) * 0.8,
      child: InkWell(
        onTap: onTap,
        child: Text(text),
      ),
    );
  }

  Widget _buildAddNewItemButton() {
    return ColoredButton(
      text: 'Add New Item',
      onPressed: _navigateToAddNewItem,
    );
  }

  TextStyle _buildTextStyle({
    required FontWeight fontWeight,
    Color color = Colors.white, // Use Flutter's built-in Colors.white
  }) {
    return GoogleFonts.montserrat(
      fontSize:
          Screen.max(context) * (fontWeight == FontWeight.w600 ? 0.02 : 0.015),
      fontWeight: fontWeight,
      color: color,
    );
  }
}
