import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
    _pageController.dispose();
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
              prefixIcon: FontAwesomeIcons.cubes,
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
              prefixIcon: FontAwesomeIcons.moneyBill,
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

  Widget _buildPackageItem(Map package, int index) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.05,
      ),
      height: Screen.height(context)*0.2,
      child: PackageBox(
        packageId: package['id'].toString(),
        imageUrl: package['pictures'].isEmpty
            ? 'https://picsum.photos/id/${DateTime.now().millisecondsSinceEpoch % 1000}/600/300'
            : package['pictures'][0]['picturePath'],
        packageDetails: package['description'],
        packagePrice: package['price'].toString(),
        packageName: package['name'],
        onPressed: () {},
      ),
    );
  }

  Widget _buildNavigationArrow(bool isLeft) {
    return IconButton(
      icon: Icon(
        isLeft ? FontAwesomeIcons.chevronLeft : FontAwesomeIcons.chevronRight,
        color: MyColors.red,
        size: Screen.max(context) * 0.04,
      ),
      onPressed: () {
        if (isLeft && _currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else if (!isLeft &&
            _currentPage < widget.listing['Package'].length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.listing['Package'].length,
        (index) => Container(
          width: Screen.max(context) * 0.015,
          height: Screen.max(context) * 0.015,
          margin: EdgeInsets.symmetric(
            horizontal: Screen.width(context) * 0.01,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? MyColors.red
                : MyColors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageList() {
    if (widget.listing['Package'].isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: Screen.height(context) * 0.22,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: widget.listing['Package'].length,
                  itemBuilder: (context, index) {
                    return _buildPackageItem(
                      widget.listing['Package'][index],
                      index,
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                child: _buildNavigationArrow(true),
              ),
              Positioned(
                right: 0,
                child: _buildNavigationArrow(false),
              ),
            ],
          ),
        ),
        SizedBox(height: Screen.height(context) * 0.02),
        _buildPageIndicator(),
        if (_isBusinessUser)
          Padding(
            padding: EdgeInsets.only(
              top: Screen.height(context) * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.pen,
                    color: MyColors.yellow,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _showPackageDialog(index: _currentPage),
                ),
                SizedBox(width: Screen.width(context) * 0.05),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trash,
                    color: MyColors.red,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _handleDeletePackage(_currentPage),
                ),
                SizedBox(width: Screen.width(context) * 0.05),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.circlePlus,
                    color: MyColors.yellow,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _showPackageDialog(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listing['Package'].isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Screen.height(context) * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Screen.width(context) * 0.05,
            ),
            child: Text(
              'Packages',
              style: GoogleFonts.poppins(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w600,
                color: MyColors.white,
              ),
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.02),
          _buildPackageList(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Screen.width(context) * 0.05,
            ),
            child: MyDivider(),
          ),
        ],
      ),
    );
  }
}
