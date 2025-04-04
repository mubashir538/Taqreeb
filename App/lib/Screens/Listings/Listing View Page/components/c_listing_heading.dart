import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/warning_dialog.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class UpperHeadings extends StatefulWidget {
  final Map<String, dynamic> listing;
  final int? listingId;
  final Map<String, dynamic> events;
  final DateTime? selectedDate;

  const UpperHeadings({
    super.key,
    required this.listing,
    required this.listingId,
    required this.selectedDate,
    required this.events,
  });

  @override
  State<UpperHeadings> createState() => _UpperHeadingsState();
}

class _UpperHeadingsState extends State<UpperHeadings> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  bool _isEditingName = false;
  bool _isEditingLocation = false;
  Color _wishlistColor = MyColors.white;
  IconData _wishlistIcon = FontAwesomeIcons.heart;
  bool _isBusinessUser = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.listing['Listing']['name'] ?? '');
    _locationController = TextEditingController(
        text: widget.listing['Listing']['location'] ?? '');
    _checkUserType();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _checkUserType() async {
    final isBusinessUser = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    if (mounted) {
      setState(() => _isBusinessUser = isBusinessUser);
    }
  }

  Future<void> _showEventSelectionDialog() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: MyColors.Dark,
      builder: (context) => _buildEventSelectionDialog(),
    );
  }

  Widget _buildEventSelectionDialog() {
    final maxDimension = Screen.max(context);
    return Container(
      padding: EdgeInsets.all(maxDimension * 0.02),
      decoration: BoxDecoration(
        color: MyColors.Dark,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(maxDimension * 0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Choose for a Function",
            style: _buildTextStyle(
                fontSize: 0.025,
                fontWeight: FontWeight.w500,
                color: MyColors.white),
          ),
          SizedBox(height: maxDimension * 0.02),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.events['Event']?.length ?? 0,
              itemBuilder: (context, index) =>
                  _buildEventItem(index, maxDimension),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(int index, double maxDimension) {
    final event = widget.events['Event'][index];
    return Container(
      margin: EdgeInsets.only(bottom: maxDimension * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: MyColors.red),
        color: MyColors.DarkLighter,
      ),
      child: ExpansionTile(
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: MyColors.red,
        collapsedBackgroundColor: MyColors.DarkLighter,
        title: Text(
          event['name'],
          style: _buildTextStyle(fontSize: 0.015, color: MyColors.white),
        ),
        children: (event['functions'] as List).map<Widget>((function) {
          return ListTile(
            title: Text(
              function['name'],
              style: _buildTextStyle(
                fontSize: 0.015,
                color: MyColors.whiteDarker,
              ),
            ),
            onTap: () => _addToBookCart(function),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _addToBookCart(Map<String, dynamic> function) async {
    try {
      final token = await MyStorage.getToken(MyTokens.accessToken);
      final response = await MyApi.postRequest(
        headers: {'Authorization': 'Bearer $token'},
        endpoint: 'add/Bookcart/',
        body: {
          'fid': function['id'].toString(),
          'uid': await MyStorage.getToken(MyTokens.userId) ?? "",
          'lid': widget.listingId.toString(),
          'type': 'Venue',
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        Navigator.pop(context);
      } else if (response['status'] == 'BudgetError') {
        WarningDialog(
          message: 'Event Budget is Exceeding',
          title: 'Budget Exceed',
          actions: [ColoredButton(text: 'Ok')],
        ).showDialogBox(context);
      } else {
        MyScaffold(text: 'Something Went Wrong!').show(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: 'Error: ${e.toString()}').show(context);
      }
    }
  }

  Future<void> _saveField(String field, String value) async {
    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listingId.toString(),
          field: value,
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          widget.listing['Listing'][field] = value;
          if (field == 'name') _isEditingName = false;
          if (field == 'location') _isEditingLocation = false;
        });
        MyScaffold(text: '$field updated successfully!').show(context);
      } else {
        throw Exception(response['message'] ?? 'Failed to update $field');
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: 'Error: ${e.toString()}').show(context);
      }
    }
  }

  Future<void> _toggleWishlist() async {
    try {
      final endpoint =
          _wishlistColor == MyColors.red ? 'wishlist/delete' : 'wishlist/add';
      final response = await MyApi.postRequest(
        endpoint: endpoint,
        body: {
          'userid': await MyStorage.getToken(MyTokens.userId),
          'listing': widget.listingId,
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          if (_wishlistColor == MyColors.red) {
            _wishlistColor = MyColors.white;
            _wishlistIcon = FontAwesomeIcons.heart;
          } else {
            _wishlistIcon = FontAwesomeIcons.solidHeart;
            _wishlistColor = MyColors.red;
          }
        });
        MyScaffold(
          text: _wishlistColor == MyColors.red
              ? 'Added to wishlist!'
              : 'Removed from wishlist!',
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: 'Error updating wishlist').show(context);
      }
    }
  }

  Future<void> _deleteListing() async {
    WarningDialog(
      title: 'Delete',
      message: 'Are you sure you want to delete this Listing?',
      actions: [
        BorderButton(
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(false),
          width: Screen.width(context) * 0.3,
          textSize: Screen.max(context) * 0.015,
        ),
        ColoredButton(
          text: 'Delete',
          onPressed: () async {
            try {
              final token = await MyStorage.getToken(MyTokens.accessToken);
              final response = await MyApi.postRequest(
                endpoint: 'businessowner/DeleteListings/',
                body: {'id': widget.listingId},
                headers: {'Authorization': 'Bearer $token'},
              );

              if (!mounted) return;

              if (response['status'] == 'success') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/YourListings',
                  ModalRoute.withName('/HomePage'),
                );
                MyScaffold(text: 'Listing Deleted Successfully!').show(context);
              } else {
                MyScaffold(text: 'Something went Wrong!').show(context);
              }
            } catch (e) {
              if (mounted) {
                MyScaffold(text: 'Error: ${e.toString()}').show(context);
              }
            }
            Navigator.of(context).pop(true);
          },
          width: Screen.width(context) * 0.3,
          textSize: Screen.max(context) * 0.015,
        ),
      ],
    ).showDialogBox(context);
  }

  TextStyle _buildTextStyle({
    double fontSize = 0.015,
    FontWeight fontWeight = FontWeight.w400,
    required Color color,
  }) {
    return GoogleFonts.montserrat(
      fontSize: Screen.max(context) * fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildNameSection(),
        _buildLocationAndRatingSection(),
      ],
    );
  }

  Widget _buildNameSection() {
    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isEditingName && _isBusinessUser
              ? _buildNameEditField()
              : _buildNameDisplay(),
        ],
      ),
    );
  }

  Widget _buildNameEditField() {
    return Flexible(
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            style: _buildTextStyle(fontSize: 0.025, color: MyColors.white),
            decoration: InputDecoration(
              hintText: 'Edit name',
              hintStyle: _buildTextStyle(
                fontSize: 0.015,
                color: MyColors.white.withOpacity(0.6),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          ColoredButton(
            text: 'Save',
            onPressed: () => _saveField('name', _nameController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildNameDisplay() {
    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Screen.width(context) * 0.6,
                child: Text(
                  widget.listing['Listing']['name'],
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _buildTextStyle(
                      fontSize: 0.025,
                      fontWeight: FontWeight.w600,
                      color: MyColors.white),
                ),
              ),
              _isBusinessUser ? _buildDeleteButton() : _buildUserActions(),
            ],
          ),
          if (_isBusinessUser)
            ColoredButton(
              text: 'Edit',
              onPressed: () => setState(() => _isEditingName = true),
            ),
        ],
      ),
    );
  }

  Widget _buildUserActions() {
    return Row(
      children: [
        GestureDetector(
          onTap: _toggleWishlist,
          child: Icon(
            _wishlistIcon,
            color: _wishlistColor,
            size: Screen.max(context) * 0.03,
          ),
        ),
        SizedBox(width: Screen.width(context) * 0.01),
        GestureDetector(
          onTap: _showEventSelectionDialog,
          child: Icon(
            Icons.add,
            color: MyColors.Yellow,
            size: Screen.max(context) * 0.05,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _deleteListing,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0.5,
              blurRadius: 3,
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        margin: EdgeInsets.all(Screen.max(context) * 0.02),
        child: Icon(
          Icons.delete,
          size: Screen.max(context) * 0.03,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLocationAndRatingSection() {
    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _isEditingLocation && _isBusinessUser
              ? _buildLocationEditField()
              : _buildLocationAndRatingDisplay(),
        ],
      ),
    );
  }

  Widget _buildLocationEditField() {
    return Flexible(
      child: Column(
        children: [
          TextField(
            controller: _locationController,
            style: _buildTextStyle(color: MyColors.white),
            decoration: InputDecoration(
              hintText: 'Edit location...',
              hintStyle:
                  _buildTextStyle(color: MyColors.white.withOpacity(0.6)),
              border: const OutlineInputBorder(),
            ),
          ),
          ColoredButton(
            text: 'Save',
            onPressed: () => _saveField('location', _locationController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndRatingDisplay() {
    return SizedBox(
      width: Screen.width(context) * 0.9,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRatingDisplay(),
          _buildLocationDisplay(),
          Icon(Icons.location_on, color: MyColors.white),
        ],
      ),
    );
  }

  Widget _buildRatingDisplay() {
    return Row(
      children: [
        Icon(Icons.star, color: MyColors.Yellow),
        Text(
          "${widget.listing['reveiewData']['average']} (${widget.listing['reveiewData']['count']})",
          style: _buildTextStyle(color: MyColors.white),
        ),
      ],
    );
  }

  Widget _buildLocationDisplay() {
    return Column(
      children: [
        Container(
          width: Screen.width(context) * 0.6,
          child: Text(
            widget.listing['Listing']['location'],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            softWrap: true,
            style: _buildTextStyle(color: MyColors.white),
          ),
        ),
        if (_isBusinessUser)
          ColoredButton(
            text: 'Edit',
            width: Screen.width(context) * 0.5,
            textSize: Screen.max(context) * 0.015,
            onPressed: () => setState(() => _isEditingLocation = true),
          ),
      ],
    );
  }
}
