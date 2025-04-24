import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
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

  Widget _buildPriceRangeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Pricing:",
          style: _buildTextStyle(
            fontSize: 0.02,
            fontWeight: FontWeight.w500,
            color: MyColors.white,
          ),
        ),
        Text(
          "Rs. ${widget.listing['Listing']['priceMin']} - ${widget.listing['Listing']['priceMax']}",
          style: _buildTextStyle(
            fontSize: 0.02,
            fontWeight: FontWeight.w400,
            color: MyColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicPriceRow() {
    return _buildNonEditableRow(
      label: "Basic Price:",
      value: widget.listing['Listing']['basicPrice'].toString(),
      isYellow: !_isBusinessUser,
    );
  }

  Widget _buildEditablePriceRow({
    required String label,
    required String field,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onSave,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: _buildTextStyle(
            fontSize: 0.015,
            fontWeight: FontWeight.w500,
            color: MyColors.yellow,
          ),
        ),
        const SizedBox(height: 4),
        if (isEditing)
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: _buildTextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 0.015,
              color: MyColors.white,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter $label...',
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          )
        else
          Text(
            widget.listing['Listing'][field].toString(),
            style: _buildTextStyle(
              fontSize: 0.015,
              fontWeight: FontWeight.w400,
              color: MyColors.white,
            ),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ColoredButton(
            text: isEditing ? "Save" : "Edit",
            onPressed: isEditing ? onSave : () => _toggleEditing(field),
          ),
        ),
      ],
    );
  }

  Widget _buildNonEditableRow({
    required String label,
    required String value,
    bool isYellow = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: _buildTextStyle(
            fontSize: 0.015,
            fontWeight: FontWeight.w500,
            color: isYellow ? MyColors.yellow : MyColors.white,
          ),
        ),
        Text(
          value,
          style: _buildTextStyle(
            fontSize: 0.015,
            fontWeight: FontWeight.w400,
            color: MyColors.white,
          ),
        ),
      ],
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

  Widget _buildDivider() {
    return SizedBox(
      height: Screen.height(context) * 0.05,
      child: Center(
        child: MyDivider(width: Screen.width(context) * 0.85),
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
          SizedBox(height: Screen.max(context) * 0.02),
          if (_isBusinessUser) ...[
            _buildEditablePriceRow(
              label: "Minimum Price:",
              field: "priceMin",
              isEditing: _isEditingPriceMin,
              controller: _priceMinController,
              onSave: () =>
                  _savePriceField('priceMin', _priceMinController.text),
            ),
            SizedBox(height: Screen.max(context) * 0.02),
            _buildEditablePriceRow(
              label: "Maximum Price:",
              field: "priceMax",
              isEditing: _isEditingPriceMax,
              controller: _priceMaxController,
              onSave: () =>
                  _savePriceField('priceMax', _priceMaxController.text),
            ),
            SizedBox(height: Screen.max(context) * 0.02),
          ],
          _buildBasicPriceRow(),
          _buildDivider(),
        ],
      ),
    );
  }
}
