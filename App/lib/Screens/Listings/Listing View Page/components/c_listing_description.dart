import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
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
    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Screen.height(context) * 0.02),
          _buildTitle(),
          _isBusinessUser && _isEditing ? _buildEditMode() : _buildViewMode(),
          if (_isBusinessUser && !_isEditing) _buildEditButton(),
          SizedBox(height: Screen.height(context) * 0.02),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final colors = AppColors(context);

    return Container(
      margin: EdgeInsets.only(bottom: Screen.max(context) * 0.015),
      child: Text(
        "Description",
        style: _buildTextStyle(
          fontSize: 0.025,
          fontWeight: FontWeight.w600,
          color: colors.white,
        ),
      ),
    );
  }

  Widget _buildEditMode() {
    final colors = AppColors(context);

    return Column(
      children: [
        TextField(
          controller: _descriptionController,
          maxLines: null,
          style: _buildTextStyle(color: colors.white),
          decoration: InputDecoration(
            hintText: 'Edit description...',
            hintStyle: GoogleFonts.roboto(color: colors.white.withAlpha(153)),
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
    final colors = AppColors(context);

    return InkWell(
      onTap: () => setState(() => _isToggled = !_isToggled),
      child: Container(
        decoration: BoxDecoration(
          color: colors.darkLighter,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(Screen.max(context) * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.listing['Listing']['description'],
              overflow: TextOverflow.ellipsis,
              maxLines: _isToggled ? 6 : 200,
              style: _buildTextStyle(color: colors.white),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: Screen.height(context) * 0.02),
            Icon(_isToggled
                ? FontAwesomeIcons.chevronDown
                : FontAwesomeIcons.chevronUp),
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
}
