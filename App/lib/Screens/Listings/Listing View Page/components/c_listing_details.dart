import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryDetails extends StatefulWidget {
  final List<String> headings;
  final List<String> values;
  final Map<String, dynamic> listing;
  final bool type;

  const CategoryDetails({
    super.key,
    required this.listing,
    required this.headings,
    required this.values,
    this.type = false,
  });

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late List<TextEditingController> _controllers;
  late List<bool> _isEditing;
  late List<List<String>> _dropdownChoices;
  bool _isLoading = true;
  bool _isBusinessUser = false;
  bool _isEditGuestMin = false;
  bool _isEditGuestMax = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _checkUserType();
    _fetchListingDetails();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    String minControl = '';
    bool hasGuestRange = false;

    _controllers = widget.values.map((value) {
      if (value.contains('-')) {
        final parts = value.split('-');
        minControl = parts[1].trim();
        hasGuestRange = true;
        return TextEditingController(text: parts[0].trim());
      }
      return TextEditingController(text: value);
    }).toList();

    if (hasGuestRange) {
      _controllers.add(TextEditingController(text: minControl));
    }

    _isEditing = List<bool>.filled(widget.values.length, false);
    _dropdownChoices = [];
  }

  Future<void> _checkUserType() async {
    final isBusinessUser = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    if (mounted) {
      setState(() => _isBusinessUser = isBusinessUser);
    }
  }

  Future<void> _fetchListingDetails() async {
    try {
      final token = await MyStorage.getToken(MyTokens.accessToken);
      final response = await MyApi.getRequest(
        context: context,
        endpoint: 'getListingDetails/${widget.listing['Listing']['type']}',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (mounted) {
        setState(() {
          if (response['fields'] != null) {
            _dropdownChoices = (response['fields'] as List)
                .map<List<String>>((field) =>
                    (field['choices'] as List<dynamic>?)?.cast<String>() ?? [])
                .toList();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        MyScaffold(text: 'Failed to load listing details').show(context);
      }
    }
  }

  Future<void> _saveValue(int index) async {
    final newValue = widget.values[index].contains('-')
        ? '${_controllers[index].text}-${_controllers.last.text}'
        : _controllers[index].text;

    if (newValue.isEmpty) {
      MyScaffold(text: 'Value cannot be empty').show(context);
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
          _toLowerCaseNoSpaces(widget.headings[index]): newValue,
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          widget.values[index] = newValue;
          _isEditing[index] = false;
          _isEditGuestMin = false;
          _isEditGuestMax = false;
        });
        MyScaffold(text: '${widget.headings[index]} updated successfully!')
            .show(context);
      } else {
        throw Exception(response['message'] ?? 'Failed to update value');
      }
    } catch (e) {
      if (mounted) {
        MyScaffold(text: 'Error: ${e.toString()}').show(context);
      }
    }
  }

  String _toLowerCaseNoSpaces(String input) {
    return input.toLowerCase().replaceAll(' ', '');
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
    final colors = AppColors(context);

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(colors.white),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: Screen.width(context) * 0.03,
              mainAxisSpacing: Screen.height(context) * 0.02,
              childAspectRatio: 1.2, // Adjust this ratio as needed
            ),
            itemCount: widget.headings.length,
            itemBuilder: (context, index) {
              return _buildDetailCard(index);
            },
          ),
          if (widget.headings.isNotEmpty) _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildDetailCard(int index) {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.45,
      margin: EdgeInsets.only(bottom: Screen.height(context) * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.05,
        vertical: Screen.height(context) * 0.03,
      ),
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _isBusinessUser
          ? _buildEditableDetail(index)
          : _buildReadOnlyDetail(index),
    );
  }

  Widget _buildEditableDetail(int index) {
    final isGuestRange = widget.values[index].contains('-');

    if (isGuestRange) {
      return _buildGuestRangeEditor(index);
    }
    final colors = AppColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.headings[index],
          style: _buildTextStyle(
            fontSize: 0.018,
            fontWeight: FontWeight.w600,
            color: colors.yellow,
          ),
        ),
        SizedBox(height: Screen.height(context) * 0.01),
        _isEditing[index]
            ? _buildEditField(index)
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.03,
                  vertical: Screen.height(context) * 0.01,
                ),
                decoration: BoxDecoration(
                  color: colors.darkLighter,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.values[index],
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
              text: _isEditing[index] ? "Save" : "Edit",
              onPressed: () {
                if (_isEditing[index]) {
                  _saveValue(index);
                } else {
                  setState(() => _isEditing[index] = true);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestRangeEditor(int index) {
    final parts = widget.values[index].split('-');
    final isEditingMin = _isEditGuestMin && _isEditing[index];
    final isEditingMax = _isEditGuestMax && _isEditing[index];
    final colors = AppColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.headings[index],
          style: _buildTextStyle(
            fontSize: 0.018,
            fontWeight: FontWeight.w600,
            color: colors.yellow,
          ),
        ),
        SizedBox(height: Screen.height(context) * 0.015),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGuestRangePart(
              label: 'Min',
              value: parts[0],
              isEditing: isEditingMin,
              controller: _controllers[index],
              onEdit: () => setState(() {
                _isEditing[index] = true;
                _isEditGuestMin = true;
              }),
              onSave: () => _saveValue(index),
            ),
            _buildGuestRangePart(
              label: 'Max',
              value: parts[1],
              isEditing: isEditingMax,
              controller: _controllers.last,
              onEdit: () => setState(() {
                _isEditing[index] = true;
                _isEditGuestMax = true;
              }),
              onSave: () => _saveValue(index),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestRangePart({
    required String label,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onEdit,
    required VoidCallback onSave,
  }) {
    final colors = AppColors(context);

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: _buildTextStyle(
              fontSize: 0.016,
              fontWeight: FontWeight.w500,
              color: colors.yellow.withAlpha(204),
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.008),
          isEditing
              ? TextField(
                  controller: controller,
                  style: _buildTextStyle(
                    fontSize: 0.016,
                    fontWeight: FontWeight.w500,
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
                      vertical: Screen.height(context) * 0.015,
                    ),
                    hintText: 'Enter $label...',
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: Screen.max(context) * 0.016,
                    ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Screen.width(context) * 0.03,
                    vertical: Screen.height(context) * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: colors.darkLighter,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value,
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
            child: ColoredButton(
              width: Screen.width(context) * 0.3,
              textSize: Screen.max(context) * 0.015,
              text: isEditing ? "Save" : "Edit",
              onPressed: isEditing ? onSave : onEdit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(int index) {
    final colors = AppColors(context);

    if (_dropdownChoices[index].isNotEmpty) {
      return DropdownButtonFormField<String>(
        dropdownColor: colors.darkLighter,
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.darkLighter,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Screen.width(context) * 0.03,
            vertical: Screen.height(context) * 0.015,
          ),
          hintText: 'Select ${widget.headings[index]}...',
          hintStyle: _buildTextStyle(color: colors.whiteDarker),
        ),
        value: widget.values[index].isEmpty ? null : widget.values[index],
        items: _dropdownChoices[index].map((choice) {
          return DropdownMenuItem<String>(
            value: choice,
            child: Text(
              choice,
              style: _buildTextStyle(color: colors.white),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _controllers[index].text = value ?? '';
          });
        },
      );
    }

    return TextField(
      controller: _controllers[index],
      style: _buildTextStyle(
        fontSize: 0.016,
        fontWeight: FontWeight.w500,
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
          vertical: Screen.height(context) * 0.015,
        ),
        hintText: 'Enter ${widget.headings[index]}...',
        hintStyle: GoogleFonts.roboto(
          color: Colors.grey,
          fontSize: Screen.max(context) * 0.016,
        ),
      ),
    );
  }

  Widget _buildReadOnlyDetail(int index) {
    final colors = AppColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.headings[index],
          style: _buildTextStyle(
            fontSize: 0.015,
            fontWeight: FontWeight.w400,
            color: colors.white.withAlpha(123),
          ),
        ),
        widget.headings[index].toLowerCase() == 'Portfolio Link'.toLowerCase()
            ? InkWell(
                onTap: () => _launchUrl(widget.values[index]),
                child: Icon(
                  FontAwesomeIcons.link,
                  size: Screen.max(context) * 0.025,
                  color: colors.white.withAlpha(123),
                ),
              )
            : Text(
                widget.values[index],
                style: _buildTextStyle(
                  fontSize: 0.02,
                  fontWeight: FontWeight.w600,
                  color: colors.white,
                ),
              ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        MyScaffold(text: 'Cannot open link').show(context);
      }
    } catch (e) {
      MyScaffold(text: 'Error opening link').show(context);
    }
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
