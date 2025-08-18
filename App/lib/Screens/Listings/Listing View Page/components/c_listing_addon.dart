import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Inputs/c_radio_button_question.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryAddons extends StatefulWidget {
  final Map<String, dynamic> listing;

  const CategoryAddons({super.key, required this.listing});

  @override
  State<CategoryAddons> createState() => _CategoryAddonsState();
}

class _CategoryAddonsState extends State<CategoryAddons> {
  late List<TextEditingController> _headingControllers;
  late List<TextEditingController> _valueControllers;
  late List<bool> _isEditingHeading;
  late List<bool> _isEditingValue;
  bool _isBusinessUser = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _checkUserType();
  }

  void _initializeControllers() {
    _headingControllers =
        widget.listing['Addons'].map<TextEditingController>((addon) {
      return TextEditingController(text: addon['name']);
    }).toList();

    _valueControllers =
        widget.listing['Addons'].map<TextEditingController>((addon) {
      return TextEditingController(text: addon['price'].toString());
    }).toList();

    _isEditingHeading =
        List<bool>.filled(widget.listing['Addons'].length, false);
    _isEditingValue = List<bool>.filled(widget.listing['Addons'].length, false);
  }

  Future<void> _checkUserType() async {
    final isBusinessUser = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    setState(() => _isBusinessUser = isBusinessUser);
  }

  Future<void> _showAddAddonDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final headTypeController = TextEditingController();
    bool isPerHead = false;
    final colors = AppColors(context);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: colors.dark,
            title: Text(
              'Add Add-Ons',
              style: _buildTextStyle(
                fontSize: 0.02,
                fontWeight: FontWeight.w600,
                color: colors.yellow,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextBox(
                  prefixIcon: FontAwesomeIcons.puzzlePiece,
                  hint: 'Name',
                  valueController: nameController,
                ),
                MyTextBox(
                  prefixIcon: FontAwesomeIcons.moneyBill,
                  hint: 'Price',
                  isNum: true,
                  isPrice: true,
                  valueController: priceController,
                ),
                RadioButtonQuestion(
                  options: ['Yes', 'No'],
                  question: '',
                  myValue: isPerHead ? 'Yes' : 'No',
                  onChanged: (value) {
                    setState(() => isPerHead = value == 'Yes');
                  },
                ),
                if (isPerHead)
                  MyTextBox(
                    prefixIcon: FontAwesomeIcons.person,
                    hint: 'PerHead Type',
                    valueController: headTypeController,
                  ),
              ],
            ),
            actions: [
              BorderButton(
                text: 'Cancel',
                width: Screen.width(context) * 0.3,
                textSize: Screen.max(context) * 0.015,
                onPressed: () => Navigator.pop(context),
              ),
              ColoredButton(
                text: 'Add',
                width: Screen.width(context) * 0.3,
                textSize: Screen.max(context) * 0.015,
                onPressed: () => _handleAddAddon(
                  nameController,
                  priceController,
                  headTypeController,
                  isPerHead,
                  context,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleAddAddon(
    TextEditingController nameController,
    TextEditingController priceController,
    TextEditingController headTypeController,
    bool isPerHead,
    BuildContext context,
  ) async {
    try {
      if (nameController.text.isEmpty || priceController.text.isEmpty) {
        MyScaffold(text: 'Please Fill All the Fields!').show(context);
        return;
      }

      if (isPerHead && headTypeController.text.isEmpty) {
        MyScaffold(text: 'Please specify per head type').show(context);
        return;
      }

      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listing['Listing']['id'].toString(),
          'operation': 'add',
          'value': 'addon',
          'namev': nameController.text,
          'pricev': priceController.text,
          'perheadv': isPerHead ? 'Yes' : 'No',
          'headtypev': isPerHead ? headTypeController.text : '',
        },
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        _addNewAddon(
          response['id'].toString(), 
          nameController.text,
          priceController.text,
          isPerHead,
          headTypeController.text,
        );
        MyScaffold(text: 'Addon Added Successfully!').show(context);
      } else {
        MyScaffold(text: response['error'] ?? 'Failed to Add Addon!')
            .show(context);
      }
      Navigator.pop(context);
    } catch (e) {
      MyScaffold(text: 'Error: ${e.toString()}').show(context);
    }
  }

  void _addNewAddon(
    String id,
    String name,
    String price,
    bool isPerHead,
    String perType,
  ) {
    setState(() {
      widget.listing['Addons'].add({
        'id': id,
        'name': name,
        'price': isPerHead ? '$price/$perType' : price,
        'isPer': isPerHead,
        'perType': perType,
        'listingId': widget.listing['Listing']['id'],
      });
      _headingControllers.add(TextEditingController(text: name));
      _valueControllers.add(TextEditingController(text: price));
      _isEditingHeading.add(false);
      _isEditingValue.add(false);
    });
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
    if (widget.listing['Addons'].isEmpty && !_isBusinessUser) {
      return const SizedBox.shrink();
    }
    final colors = AppColors(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.02,
        vertical: Screen.height(context) * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add-Ons',
            style: GoogleFonts.poppins(
              fontSize: Screen.max(context) * 0.025,
              fontWeight: FontWeight.w600,
              color: colors.white,
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.02),
          _buildAddonsGrid(),
          if (_isBusinessUser) ...[
            SizedBox(height: Screen.height(context) * 0.03),
            Center(
              child: ColoredButton(
                text: 'Add New Add-On',
                width: Screen.width(context) * 0.6,
                onPressed: _showAddAddonDialog,
              ),
            ),
          ],
          SizedBox(height: Screen.height(context) * 0.03),
        ],
      ),
    );
  }

  Widget _buildAddonsGrid() {
    final addons = widget.listing['Addons'] as List;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Screen.max(context) * 0.02,
        mainAxisSpacing: Screen.max(context) * 0.02,
        childAspectRatio: 1.2,
      ),
      itemCount: addons.length,
      itemBuilder: (context, index) {
        return _buildAddonCard(addons[index]);
      },
    );
  }

  Widget _buildAddonCard(Map<String, dynamic> addon) {
    final colors = AppColors(context);

    return Container(
      width: Screen.width(context) * 0.45,
      decoration: BoxDecoration(
        color: colors.darkLighter,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(Screen.max(context) * 0.015),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addon['name'],
                style: GoogleFonts.poppins(
                  fontSize: Screen.max(context) * 0.018,
                  fontWeight: FontWeight.w400,
                  color: colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Screen.height(context) * 0.01),
              SizedBox(
                width: Screen.width(context) * 0.4,
                child: Text(
                  'Rs. ${addon['price']}${addon['isPer'] ? '/${addon['perType']}' : ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: Screen.max(context) * 0.02,
                    fontWeight: FontWeight.w600,
                    color: colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    for (final controller in _headingControllers) {
      controller.dispose();
    }
    for (final controller in _valueControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
