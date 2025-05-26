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
  final DateTime? selectedDate;

  const UpperHeadings({
    super.key,
    required this.listing,
    required this.listingId,
    required this.selectedDate,
  });

  @override
  State<UpperHeadings> createState() => _UpperHeadingsState();
}

class _UpperHeadingsState extends State<UpperHeadings> {
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  bool _isEditingName = false;
  bool _isEditingLocation = false;
Color _wishlistColor = Color(0xFFFFFFFF);
  IconData _wishlistIcon = FontAwesomeIcons.heart;
  bool _isBusinessUser = false;
  Map<String, dynamic> events = {};

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.listing['Listing']['name'] ?? '');
    _locationController = TextEditingController(
        text: widget.listing['Listing']['location'] ?? '');
    _checkUserType();
    _checkWishList();
    fetchEvents();
  }

  void fetchEvents() async {
    final userId = await MyStorage.getToken(MyTokens.userId);
    final token = await MyStorage.getToken(MyTokens.accessToken);
    final response = await MyApi.getRequest(
        context: context,
        endpoint: 'Events/getBasics/$userId',
        headers: {'Authorization': 'Bearer $token'});
    setState(() {
      events = response;
    });
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
    final colors = AppColors(context);

    await showModalBottomSheet(
      context: context,
      backgroundColor: colors.dark,
      builder: (context) => _buildEventSelectionDialog(),
    );
  }

  Widget _buildEventSelectionDialog() {
    final colors = AppColors(context);

    final maxDimension = Screen.max(context);
    return Container(
      padding: EdgeInsets.all(maxDimension * 0.02),
      decoration: BoxDecoration(
        color: colors.dark,
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
                color: colors.white),
          ),
          SizedBox(height: maxDimension * 0.02),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: events['Event']?.length ?? 0,
              itemBuilder: (context, index) =>
                  _buildEventItem(index, maxDimension),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(int index, double maxDimension) {
    final colors = AppColors(context);

    final event = events['Event'][index];
    return Container(
      margin: EdgeInsets.only(bottom: maxDimension * 0.02),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: colors.red),
        color: colors.darkLighter,
      ),
      child: ExpansionTile(
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: colors.red,
        collapsedBackgroundColor: colors.darkLighter,
        title: Text(
          event['name'],
          style: _buildTextStyle(fontSize: 0.015, color: colors.white),
        ),
        children: (event['functions'] as List).map<Widget>((function) {
          return ListTile(
            title: Text(
              function['name'],
              style: _buildTextStyle(
                fontSize: 0.015,
                color: colors.whiteDarker,
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
          'type': widget.listing['Listing']['type'],
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        Navigator.pop(context);
      } else if (response['status'] == 'BudgetError') {
        WarningDialog(
          message: 'Event Budget is Exceeding',
          title: 'Budget Exceed',
          actions: [
            ColoredButton(
              text: 'Ok',
              onPressed: () => Navigator.pop(context),
            )
          ],
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
    final colors = AppColors(context);

    try {
      final endpoint =
          _wishlistColor == colors.red ? 'wishlist/delete' : 'wishlist/add';
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
          if (_wishlistColor == colors.red) {
            _wishlistColor = colors.white;
            _wishlistIcon = FontAwesomeIcons.heart;
          } else {
            _wishlistIcon = FontAwesomeIcons.solidHeart;
            _wishlistColor = colors.red;
          }
        });
        MyScaffold(
          text: _wishlistColor == colors.red
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
                Navigator.pop(context);
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
    return GoogleFonts.roboto(
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
    final colors = AppColors(context);

    return Flexible(
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            style: _buildTextStyle(fontSize: 0.025, color: colors.white),
            decoration: InputDecoration(
              hintText: 'Edit name',
              hintStyle: _buildTextStyle(
                fontSize: 0.015,
                color: colors.white.withAlpha(153),
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
    final colors = AppColors(context);

    return Flexible(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.listing['Listing']['name'],
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _buildTextStyle(
                      fontSize: 0.02,
                      fontWeight: FontWeight.w600,
                      color: colors.white),
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
    final colors = AppColors(context);

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
            FontAwesomeIcons.plus,
            color: colors.yellow,
            size: Screen.max(context) * 0.03,
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
              color: Colors.black.withAlpha(76),
              spreadRadius: 0.5,
              blurRadius: 3,
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        margin: EdgeInsets.all(Screen.max(context) * 0.02),
        child: Icon(
          FontAwesomeIcons.trash,
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
    final colors = AppColors(context);

    return Flexible(
      child: Column(
        children: [
          TextField(
            controller: _locationController,
            style: _buildTextStyle(color: colors.white),
            decoration: InputDecoration(
              hintText: 'Edit location...',
              hintStyle: _buildTextStyle(color: colors.white.withAlpha(153)),
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
          _buildLocationDisplay(),
          _buildRatingDisplay(),
        ],
      ),
    );
  }

  Widget _buildRatingDisplay() {
    final colors = AppColors(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.lightDark,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Row(
        children: [
          Icon(Icons.star, color: colors.yellow),
          Text(
            "${widget.listing['Listing']['rating']}",
            style: _buildTextStyle(color: colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDisplay() {
    final colors = AppColors(context);

    return Column(
      children: [
        Row(
          children: [
            Icon(FontAwesomeIcons.locationDot, color: colors.white),
            SizedBox(width: Screen.width(context) * 0.01),
            SizedBox(
              width: Screen.width(context) * 0.6,
              child: Text(
                widget.listing['Listing']['location'],
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                softWrap: true,
                style: _buildTextStyle(color: colors.white),
              ),
            ),
          ],
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

  void _checkWishList() async {

    final response = await MyApi.getRequest(
        refresh: true,
        endpoint: 'wishlist/check',
        params: {
          'userid': await MyStorage.getToken(MyTokens.userId),
          'listing': widget.listingId
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        });
    if (response['status'] == 'success') {
      if (response['is_in_wishlist']) {
        setState(() {
          _wishlistColor = Color(0xffF13F5A);
          _wishlistIcon = FontAwesomeIcons.solidHeart;
        });
      }
    }
  }
}
