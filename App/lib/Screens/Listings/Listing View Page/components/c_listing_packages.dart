import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/c_package_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryPackages extends StatefulWidget {
  final Map listing;
  final bool type;

  const CategoryPackages({
    super.key,
    required this.listing,
    this.type = false,
  });

  @override
  State<CategoryPackages> createState() => _CategoryPackagesState();
}

class _CategoryPackagesState extends State<CategoryPackages> {
  late final TextEditingController _nameController;
  late final TextEditingController _detailsController;
  late final TextEditingController _priceController;
  bool _isBusinessUser = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _detailsController = TextEditingController();
    _priceController = TextEditingController();
    _checkUserType();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _checkUserType() async {
    final isBusinessUser = await MyStorage.exists(MyTokens.isBusinessOwner) ||
        await MyStorage.exists(MyTokens.isFreelancer);
    if (mounted) {
      setState(() => _isBusinessUser = isBusinessUser);
    }
  }

  Future<void> _handleAddOrEditPackage({int? index}) async {
    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listing['Listing']['id'].toString(),
          'operation': index == null ? 'add' : 'edit',
          'value': 'package',
          if (index != null) 'idv': widget.listing['Package'][index]['id'],
          'namev': _nameController.text,
          'pricev': _priceController.text,
          'descv': _detailsController.text,
        },
      );

      if (response['status'] == 'success') {
        _updatePackageList(response, index);
        _showSuccessMessage(index == null ? 'Added' : 'Updated');
      } else {
        _showErrorMessage();
      }
    } catch (e) {
      _showErrorMessage();
    }
  }

  void _updatePackageList(Map response, int? index) {
    final newPackage = {
      'id': response['id'] ?? widget.listing['Package'][index!]['id'],
      'name': _nameController.text,
      'description': _detailsController.text,
      'price': _priceController.text,
    };

    setState(() {
      if (index == null) {
        widget.listing['Package'].add(newPackage);
      } else {
        widget.listing['Package'][index] = newPackage;
      }
    });
  }

  Future<void> _handleDeletePackage(int index) async {
    try {
      final response = await MyApi.postRequest(
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        endpoint: 'businessowner/updateListings/',
        body: {
          'id': widget.listing['Listing']['id'].toString(),
          'operation': 'delete',
          'value': 'package',
          'idv': widget.listing['Package'][index]['id']
        },
      );

      if (response['status'] == 'success') {
        setState(() => widget.listing['Package'].removeAt(index));
        _showSuccessMessage('Deleted');
      } else {
        _showErrorMessage();
      }
    } catch (e) {
      _showErrorMessage();
    }
  }

  void _showSuccessMessage(String action) {
    MyScaffold(text: 'Package $action Successfully!').show(context);
  }

  void _showErrorMessage() {
    MyScaffold(text: 'Something Went Wrong!').show(context);
  }

  void _showPackageDialog({int? index}) {
    final nameFocus = FocusNode();
    final detailsFocus = FocusNode();
    final priceFocus = FocusNode();

    if (index != null) {
      final package = widget.listing['Package'][index];
      _nameController.text = package['name'];
      _detailsController.text = package['description'];
      _priceController.text = package['price'].toString();
    } else {
      _nameController.clear();
      _detailsController.clear();
      _priceController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => _buildPackageDialog(
        nameFocus,
        detailsFocus,
        priceFocus,
        index,
      ),
    ).then((_) {
      nameFocus.dispose();
      detailsFocus.dispose();
      priceFocus.dispose();
    });
  }

  Widget _buildPackageDialog(
    FocusNode nameFocus,
    FocusNode detailsFocus,
    FocusNode priceFocus,
    int? index,
  ) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: MyColors.dark,
      title: Text(
        index == null ? 'Add Package' : 'Edit Package',
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.02,
          fontWeight: FontWeight.w600,
          color: MyColors.yellow,
        ),
      ),
      content: SizedBox(
        width: Screen.width(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextBox(
              focusNode: nameFocus,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(detailsFocus),
              hint: 'Name',
              valueController: _nameController,
            ),
            DescriptionBox(
              valueController: _detailsController,
              focusNode: detailsFocus,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(priceFocus),
            ),
            MyTextBox(
              focusNode: priceFocus,
              onFieldSubmitted: (_) => priceFocus.unfocus(),
              hint: 'Price',
              isNum: true,
              isPrice: true,
              valueController: _priceController,
            ),
          ],
        ),
      ),
      actions: [
        BorderButton(
          text: 'Cancel',
          width: Screen.width(context) * 0.3,
          textSize: Screen.max(context) * 0.015,
          onPressed: () => Navigator.pop(context),
        ),
        ColoredButton(
          text: index == null ? 'Add' : 'Update',
          width: Screen.width(context) * 0.3,
          textSize: Screen.max(context) * 0.015,
          onPressed: () async {
            await _handleAddOrEditPackage(index: index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildPackageList() {
    return Column(
      children: widget.listing['Package']
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final package = entry.value;

            return Container(
              margin:
                  EdgeInsets.symmetric(vertical: Screen.max(context) * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isBusinessUser) _buildPackageActions(index),
                  PackageBox(
                    packageId: package['id'].toString(),
                    imageUrl: package['pictures'][0],
                    packageDetails: package['description'],
                    packagePrice: package['price'].toString(),
                    packageName: package['name'],
                    onPressed: () {},
                  ),
                ],
              ),
            );
          })
          .cast<Widget>()
          .toList(),
    );
  }

  Widget _buildPackageActions(int index) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.edit, color: MyColors.yellow),
          onPressed: () => _showPackageDialog(index: index),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: MyColors.red),
          onPressed: () => _handleDeletePackage(index),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Packages',
      style: GoogleFonts.roboto(
        fontSize: Screen.max(context) * 0.025,
        fontWeight: FontWeight.w600,
        color: MyColors.yellow,
      ),
    );
  }

  Widget _buildAddButton() {
    return IconButton(
      icon: Icon(Icons.add_circle_outline, color: MyColors.yellow),
      onPressed: () => _showPackageDialog(),
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

  @override
  Widget build(BuildContext context) {
    if (widget.listing['Package'].isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          Padding(
            padding: EdgeInsets.only(top: Screen.height(context) * 0.02),
            child: _buildPackageList(),
          ),
          if (_isBusinessUser) _buildAddButton(),
          _buildDivider(),
        ],
      ),
    );
  }
}
