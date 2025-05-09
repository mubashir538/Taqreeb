import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class DescriptionCategory extends StatefulWidget {
  final Map<String, dynamic> listing;
  final bool type;

  const DescriptionCategory({
    super.key,
    required this.listing,
    this.type = false,
  });

  @override
  State<DescriptionCategory> createState() => _DescriptionCategoryState();
}

class _DescriptionCategoryState extends State<DescriptionCategory> {
  late final TextEditingController _descriptionController;
  bool _isToggled = true;
  bool _isEditing = false;
  bool _isBusinessUser = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.listing['Listing']['description'] ?? '',
    );
    _checkUserType();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _checkUserType() async {
    final isBusinessUser = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    if (mounted) {
      setState(() => _isBusinessUser = isBusinessUser);
    }
  }

  Future<void> _saveDescription() async {
    final newDescription = _descriptionController.text.trim();

    if (newDescription.isEmpty) {
      MyScaffold(text: 'Description cannot be empty').show(context);
      return;
    }

    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listing['Listing']['id'].toString(),
          'description': newDescription,
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          _isEditing = false;
          widget.listing['Listing']['description'] = newDescription;
        });
        MyScaffold(text: 'Description updated successfully!').show(context);
      } else {
        throw Exception(response['message'] ?? 'Failed to update description');
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: 'Error: ${e.toString()}').show(context);
      }
    }
  }

  TextStyle _buildTextStyle({
    double fontSize = 0.015,
    FontWeight fontWeight = FontWeight.w300,
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
    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _isBusinessUser && _isEditing ? _buildEditMode() : _buildViewMode(),
          if (_isBusinessUser && !_isEditing) _buildEditButton(),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: Screen.max(context) * 0.015),
      child: Text(
        "Description",
        style: _buildTextStyle(
          fontSize: 0.025,
          fontWeight: FontWeight.w600,
          color: MyColors.yellow,
        ),
      ),
    );
  }

  Widget _buildEditMode() {
    return Column(
      children: [
        TextField(
          controller: _descriptionController,
          maxLines: null,
          style: _buildTextStyle(color: MyColors.white),
          decoration: InputDecoration(
            hintText: 'Edit description...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(),
          ),
        ),
        SizedBox(height: Screen.height(context) * 0.02),
        ColoredButton(
          text: 'Save',
          onPressed: _saveDescription,
        ),
      ],
    );
  }

  Widget _buildViewMode() {
    return InkWell(
      onTap: () => setState(() => _isToggled = !_isToggled),
      child: Padding(
        padding: EdgeInsets.only(bottom: Screen.max(context) * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.listing['Listing']['description'],
              overflow: TextOverflow.ellipsis,
              maxLines: _isToggled ? 6 : 200,
              style: _buildTextStyle(color: MyColors.white),
              textAlign: TextAlign.justify,
            ),
            Icon(_isToggled
                ? Icons.arrow_downward_outlined
                : Icons.arrow_upward_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return ColoredButton(
      text: 'Edit',
      onPressed: () => setState(() => _isEditing = true),
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: Screen.height(context) * 0.05,
      child: Center(
        child: MyDivider(width: Screen.width(context) * 0.85),
      ),
    );
  }
}
