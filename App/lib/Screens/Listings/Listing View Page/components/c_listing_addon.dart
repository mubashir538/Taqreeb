import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/Screens/Temp/For%20Fyp2/Create%20AI%20Package/Components/radio%20button%20question.dart';
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

  Future<void> _saveAddon(int index) async {
    final response = await MyApi.postRequest(
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      endpoint: 'businessowner/updateListings/',
      body: {
        'id': widget.listing['Listing']['id'].toString(),
        'idv': widget.listing['Addons'][index]['id'].toString(),
        'operation': 'edit',
        'value': 'addon',
        'namev': _headingControllers[index].text,
        'pricev': _valueControllers[index].text
      },
    );

    if (!mounted) return;

    if (response['status'] == 'success') {
      setState(() {
        widget.listing['Addons'][index]['name'] =
            _headingControllers[index].text;
        widget.listing['Addons'][index]['price'] =
            _valueControllers[index].text;
        _isEditingHeading[index] = false;
        _isEditingValue[index] = false;
      });
      MyScaffold(text: 'Addon Updated Successfully!').show(context);
    } else {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Future<void> _showAddAddonDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final headTypeController = TextEditingController();
    bool isPerHead = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: MyColors.dark,
            title: Text(
              'Add Add-Ons',
              style: _buildTextStyle(
                fontSize: 0.02,
                fontWeight: FontWeight.w600,
                color: MyColors.Yellow,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextBox(
                  hint: 'Name',
                  valueController: nameController,
                ),
                MyTextBox(
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
        response['id'],
        nameController.text,
        priceController.text,
        isPerHead,
        headTypeController.text,
      );
      MyScaffold(text: 'Addon Added Successfully!').show(context);
    } else {
      MyScaffold(text: 'Failed to Add Addon!').show(context);
    }
    Navigator.pop(context);
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

  Future<void> _deleteAddon(int index) async {
    final response = await MyApi.postRequest(
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      endpoint: 'businessowner/updateListings/',
      body: {
        'id': widget.listing['Listing']['id'].toString(),
        'idv': widget.listing['Addons'][index]['id'].toString(),
        'operation': 'delete',
        'value': 'addon',
      },
    );

    if (!mounted) return;

    if (response['status'] == 'success') {
      setState(() {
        widget.listing['Addons'].removeAt(index);
        _headingControllers.removeAt(index);
        _valueControllers.removeAt(index);
        _isEditingHeading.removeAt(index);
        _isEditingValue.removeAt(index);
      });
      MyScaffold(text: 'Addon Deleted Successfully!').show(context);
    } else {
      MyScaffold(text: 'Something Went Wrong!').show(context);
    }
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
    if (widget.listing['Addons'].isEmpty && !_isBusinessUser) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add-Ons',
            style: _buildTextStyle(
              fontSize: 0.025,
              fontWeight: FontWeight.w600,
              color: MyColors.Yellow,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
            child: _buildAddonsList(),
          ),
          if (_isBusinessUser) _buildAddAddonButton(),
          SizedBox(
            height: Screen.height(context) * 0.05,
            child: Center(
              child: MyDivider(width: Screen.width(context) * 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonsList() {
    return Column(
      children: [
        for (int i = 0; i < widget.listing['Addons'].length; i++)
          Container(
            margin: EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
            child: _buildAddonItem(i),
          ),
      ],
    );
  }

  Widget _buildAddonItem(int index) {
    final addon = widget.listing['Addons'][index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add-On ${index + 1}',
          style: _buildTextStyle(
            fontWeight: FontWeight.w500,
            color: MyColors.Yellow,
          ),
        ),
        _buildEditableField(
          controller: _headingControllers[index],
          isEditing: _isEditingHeading[index],
          defaultValue: _capitalize(addon['name']),
          onSave: () => _saveAddon(index),
          onEdit: () => setState(() => _isEditingHeading[index] = true),
        ),
        _buildEditableField(
          controller: _valueControllers[index],
          isEditing: _isEditingValue[index],
          defaultValue: addon['isPer']
              ? '${addon['price']}/${_capitalize(addon['perType'])}'
              : addon['price'].toString(),
          onSave: () => _saveAddon(index),
          onEdit: () => setState(() => _isEditingValue[index] = true),
        ),
        if (_isBusinessUser) _buildAddonActions(index),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required bool isEditing,
    required String defaultValue,
    required VoidCallback onSave,
    required VoidCallback onEdit,
  }) {
    return isEditing
        ? TextField(
            controller: controller,
            style: _buildTextStyle(color: MyColors.white),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          )
        : Text(
            defaultValue,
            style: _buildTextStyle(color: MyColors.white),
          );
  }

  Widget _buildAddonActions(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          text: _isEditingHeading[index] ? 'Save' : 'Edit Name',
          onPressed: _isEditingHeading[index]
              ? () => _saveAddon(index)
              : () => setState(() => _isEditingHeading[index] = true),
        ),
        SizedBox(width: Screen.max(context) * 0.02),
        _buildActionButton(
          text: _isEditingValue[index] ? 'Save' : 'Edit Price',
          onPressed: _isEditingValue[index]
              ? () => _saveAddon(index)
              : () => setState(() => _isEditingValue[index] = true),
        ),
        SizedBox(width: Screen.max(context) * 0.02),
        _buildActionButton(
          text: 'Delete',
          onPressed: () => _deleteAddon(index),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return ColoredButton(
      text: text,
      width: Screen.width(context) * 0.25,
      textSize: Screen.max(context) * 0.015,
      onPressed: onPressed,
    );
  }

  Widget _buildAddAddonButton() {
    return ColoredButton(
      text: 'Add New Add-On',
      onPressed: _showAddAddonDialog,
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
