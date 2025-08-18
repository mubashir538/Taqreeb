import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class PricingSection extends StatefulWidget {
  final Map listing;
  const PricingSection({super.key, required this.listing});

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  late final TextEditingController _priceMinController;
  late final TextEditingController _priceMaxController;
  bool _isEditingPriceMin = false;
  bool _isEditingPriceMax = false;
  bool _isBusinessUser = false;

  @override
  void initState() {
    super.initState();
    _priceMinController = TextEditingController(
      text: widget.listing['Listing']['priceMin'].toString(),
    );
    _priceMaxController = TextEditingController(
      text: widget.listing['Listing']['priceMax'].toString(),
    );
    _checkUserType();
  }

  @override
  void dispose() {
    _priceMinController.dispose();
    _priceMaxController.dispose();
    super.dispose();
  }

  Future<void> _checkUserType() async {
    final isBusinessUser = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    if (mounted) {
      setState(() => _isBusinessUser = isBusinessUser);
    }
  }

  Future<void> _savePriceField(String field, String value) async {
    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listing['Listing']['id'].toString(),
          field: value,
        },
      );

      if (response['status'] == 'success') {
        _handleSuccessfulUpdate(field, value);
      } else {
        throw Exception(response['message'] ?? 'Failed to update $field');
      }
    } catch (e) {
      _handleError(e, field);
    }
  }

  void _handleSuccessfulUpdate(String field, String value) {
    setState(() {
      widget.listing['Listing'][field] = value;
      widget.listing['Listing']['basicPrice'] = _calculateBasicPrice();
      if (field == 'priceMin') _isEditingPriceMin = false;
      if (field == 'priceMax') _isEditingPriceMax = false;
    });
    _showSuccessMessage('$field updated successfully!');
  }

  int _calculateBasicPrice() {
    return ((int.parse(widget.listing['Listing']['priceMin'].toString()) +
        int.parse(widget.listing['Listing']['priceMax'].toString())));
  }

  void _handleError(dynamic error, String field) {
    MyApi.postRequest(
      endpoint: 'error/application',
      body: {'error': 'Error updating $field: $error'},
    );
    _showErrorMessage('Failed to update $field: ${error.toString()}');
  }

  void _showSuccessMessage(String message) {
    MyScaffold(text: message).show(context);
  }

  void _showErrorMessage(String message) {
    MyScaffold(text: message).show(context);
  }

  String _formatNumberWithCommas(String number) {
    return number.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Widget _buildPriceRangeRow() {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(
          horizontal: Screen.width(context) * 0.05,
          vertical: Screen.height(context) * 0.04),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Pricing",
            style: _buildTextStyle(
              fontSize: 0.018,
              fontWeight: FontWeight.w600,
              color: colors.white,
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Min Price",
                    style: _buildTextStyle(
                      fontSize: 0.015,
                      fontWeight: FontWeight.w400,
                      color: colors.white.withAlpha(123),
                    ),
                  ),
                  Text(
                    "Rs. ${_formatNumberWithCommas(widget.listing['Listing']['priceMin'].toString())}",
                    style: _buildTextStyle(
                      fontSize: 0.025,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Max Price",
                    style: _buildTextStyle(
                      fontSize: 0.015,
                      fontWeight: FontWeight.w400,
                      color: colors.white.withAlpha(123),
                    ),
                  ),
                  Text(
                    "Rs. ${_formatNumberWithCommas(widget.listing['Listing']['priceMax'].toString())}",
                    style: _buildTextStyle(
                      fontSize: 0.025,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicPriceRow() {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.9,
      padding: EdgeInsets.symmetric(
          horizontal: Screen.width(context) * 0.05,
          vertical: Screen.height(context) * 0.04),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Basic Price:",
            style: _buildTextStyle(
              fontSize: 0.018,
              fontWeight: FontWeight.w400,
              color: colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Screen.width(context) * 0.03,
                vertical: Screen.height(context) * 0.008),
            decoration: BoxDecoration(
              color: colors.darkLighter,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Rs. ${widget.listing['Listing']['basicPrice']}",
              style: _buildTextStyle(
                fontSize: 0.025,
                fontWeight: FontWeight.w600,
                color: colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditablePriceRow({
    required String label,
    required String field,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onSave,
  }) {
    final colors = AppColors(context);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Screen.width(context) * 0.05,
          vertical: Screen.height(context) * 0.015),
      decoration: BoxDecoration(
        color: colors.lightDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: _buildTextStyle(
              fontSize: 0.018,
              fontWeight: FontWeight.w600,
              color: colors.yellow,
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.01),
          if (isEditing)
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: _buildTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 0.016,
                color: colors.white,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.darkLighter,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Screen.width(context) * 0.03,
                    vertical: Screen.height(context) * 0.015),
                hintText: 'Enter $label...',
                hintStyle: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: Screen.max(context) * 0.016,
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.03,
                  vertical: Screen.height(context) * 0.015),
              decoration: BoxDecoration(
                color: colors.lightDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.listing['Listing'][field].toString(),
                style: _buildTextStyle(
                  fontSize: 0.016,
                  fontWeight: FontWeight.w500,
                  color: colors.white,
                ),
              ),
            ),
          SizedBox(height: Screen.height(context) * 0.015),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: Screen.width(context) * 0.3,
              child: ColoredButton(
                text: isEditing ? "Save" : "Edit",
                onPressed: isEditing ? onSave : () => _toggleEditing(field),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Column(
        children: [
          _buildPriceRangeRow(),
          SizedBox(height: Screen.max(context) * 0.025),
          if (_isBusinessUser) ...[
            _buildEditablePriceRow(
              label: "Minimum Price",
              field: "priceMin",
              isEditing: _isEditingPriceMin,
              controller: _priceMinController,
              onSave: () =>
                  _savePriceField('priceMin', _priceMinController.text),
            ),
            SizedBox(height: Screen.max(context) * 0.025),
            _buildEditablePriceRow(
              label: "Maximum Price",
              field: "priceMax",
              isEditing: _isEditingPriceMax,
              controller: _priceMaxController,
              onSave: () =>
                  _savePriceField('priceMax', _priceMaxController.text),
            ),
            SizedBox(height: Screen.max(context) * 0.025),
          ],
          _buildBasicPriceRow(),
        ],
      ),
    );
  }

  TextStyle _buildTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return GoogleFonts.roboto(
      fontSize: Screen.max(context) * fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  void _toggleEditing(String field) {
    setState(() {
      if (field == 'priceMin') {
        _isEditingPriceMin = true;
      } else if (field == 'priceMax') {
        _isEditingPriceMax = true;
      }
    });
  }
}
