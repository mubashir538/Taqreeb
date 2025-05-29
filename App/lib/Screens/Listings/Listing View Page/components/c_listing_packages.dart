import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

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

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images;
        });
      }
    } catch (e) {
      MyScaffold(text: 'Error selecting images: ${e.toString()}').show(context);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _handleAddOrEditPackage({int? index}) async {
    try {
      if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
        MyScaffold(text: 'Name and Price are required').show(context);
        return;
      }

      final Map<String, dynamic> body = {
        'id': widget.listing['Listing']['id'].toString(),
        'operation': index == null ? 'add' : 'edit',
        'value': 'package',
        if (index != null) 'idv': widget.listing['Package'][index]['id'],
        'namev': _nameController.text,
        'pricev': _priceController.text,
        'descv': _detailsController.text,
      };

      final Map<String, dynamic> files = {};
      if (_selectedImages.isNotEmpty) {
        files['pictures'] = _selectedImages.map((img) => img.path).toList();
      }

      final response = await MyApi.postMultipartRequest(
        endpoint: 'businessowner/updateListings/',
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
        },
        body: body,
        files: files,
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
      'pictures': response['pictures'] ??
          widget.listing['Package'][index]['pictures'] ??
          [],
    };

    setState(() {
      if (index == null) {
        widget.listing['Package'].add(newPackage);
      } else {
        widget.listing['Package'][index] = newPackage;
      }
      _selectedImages = [];
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

  Widget _buildImagePreview() {
    if (_selectedImages.isEmpty) return const SizedBox();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(_selectedImages[index].path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPackageDialog(
    FocusNode nameFocus,
    FocusNode detailsFocus,
    FocusNode priceFocus,
    int? index,
  ) {
    final colors = AppColors(context);

    return AlertDialog(
      scrollable: true,
      backgroundColor: colors.dark,
      title: Text(
        index == null ? 'Add Package' : 'Edit Package',
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.02,
          fontWeight: FontWeight.w600,
          color: colors.yellow,
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
            SizedBox(height: Screen.height(context) * 0.02),
            Text(
              'Add Images (Max 5)',
              style: GoogleFonts.roboto(
                color: colors.white,
                fontSize: Screen.max(context) * 0.018,
              ),
            ),
            SizedBox(height: Screen.height(context) * 0.01),
            _buildImagePreview(),
            SizedBox(height: Screen.height(context) * 0.01),
            ColoredButton(
              text: 'Select Images',
              width: Screen.width(context) * 0.5,
              textSize: Screen.max(context) * 0.015,
              onPressed: _pickImages,
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
            if (mounted) Navigator.pop(context);
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
      _selectedImages = [];
    } else {
      _nameController.clear();
      _detailsController.clear();
      _priceController.clear();
      _selectedImages = [];
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
      height: Screen.height(context) * 0.2,
      child: PackageBox(
        showPopupOnTap: _isBusinessUser ? false : true,
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
    final colors = AppColors(context);

    return IconButton(
      icon: Icon(
        isLeft ? FontAwesomeIcons.chevronLeft : FontAwesomeIcons.chevronRight,
        color: colors.red,
        size: Screen.max(context) * 0.02,
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
    final colors = AppColors(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavigationArrow(true),
        Row(
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
                    ? colors.red
                    : colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ),
        _buildNavigationArrow(false)
      ],
    );
  }

  Widget _buildPackageList() {
    if (widget.listing['Package'].isEmpty) {
      return _buildEmptyState();
    }

    final colors = AppColors(context);

    return Column(
      children: [
        SizedBox(
          height: Screen.height(context) * 0.22,
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
                    color: colors.yellow,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _showPackageDialog(index: _currentPage),
                ),
                SizedBox(width: Screen.width(context) * 0.05),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trash,
                    color: colors.red,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _handleDeletePackage(_currentPage),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    final colors = AppColors(context);

    if (!_isBusinessUser) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        children: [
          Text(
            'No Packages Available',
            style: GoogleFonts.poppins(
              fontSize: Screen.max(context) * 0.02,
              color: colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.03),
          ColoredButton(
            text: 'Add New Package',
            width: Screen.width(context) * 0.6,
            onPressed: _showPackageDialog,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

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
                color: colors.white,
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
