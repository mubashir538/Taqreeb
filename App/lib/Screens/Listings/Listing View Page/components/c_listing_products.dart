import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_border_button.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/Components/Home%20Page/c_product.dart';
import 'package:taqreeb/Components/Inputs/c_input_description.dart';
import 'package:taqreeb/Components/Inputs/c_input_text_box.dart';
import 'package:taqreeb/Components/global/c_divider.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';

class CategoryProducts extends StatefulWidget {
  final Map listing;
  final bool type;

  const CategoryProducts({
    super.key,
    required this.listing,
    this.type = false,
  });

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
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

  Future<void> _handleAddOrEditProduct({int? index}) async {
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
          'value': 'product',
          if (index != null) 'idv': widget.listing['Product'][index]['id'],
          'namev': _nameController.text,
          'pricev': _priceController.text,
          'descv': _detailsController.text,
        },
      );

      if (response['status'] == 'success') {
        _updateProductList(response, index);
        _showSuccessMessage(index == null ? 'Added' : 'Updated');
      } else {
        _showErrorMessage();
      }
    } catch (e) {
      _showErrorMessage();
    }
  }

  void _updateProductList(Map response, int? index) {
    final newProduct = {
      'id': response['id'] ?? widget.listing['Product'][index!]['id'],
      'name': _nameController.text,
      'description': _detailsController.text,
      'price': _priceController.text,
    };

    setState(() {
      if (index == null) {
        widget.listing['Product'].add(newProduct);
      } else {
        widget.listing['Product'][index] = newProduct;
      }
    });
  }

  Future<void> _handleDeleteProduct(int index) async {
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
          'value': 'product',
          'idv': widget.listing['Product'][index]['id']
        },
      );

      if (response['status'] == 'success') {
        setState(() => widget.listing['Product'].removeAt(index));
        _showSuccessMessage('Deleted');
      } else {
        _showErrorMessage();
      }
    } catch (e) {
      _showErrorMessage();
    }
  }

  void _showSuccessMessage(String action) {
    MyScaffold(text: 'Product $action Successfully!').show(context);
  }

  void _showErrorMessage() {
    MyScaffold(text: 'Something Went Wrong!').show(context);
  }

  Widget _buildProductDialog(
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
        index == null ? 'Add Product' : 'Edit Product',
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
              prefixIcon: FontAwesomeIcons.box,
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
            await _handleAddOrEditProduct(index: index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showProductDialog({int? index}) {
    final nameFocus = FocusNode();
    final detailsFocus = FocusNode();
    final priceFocus = FocusNode();

    if (index != null) {
      final product = widget.listing['Product'][index];
      _nameController.text = product['name'];
      _detailsController.text = product['description'];
      _priceController.text = product['price'].toString();
    } else {
      _nameController.clear();
      _detailsController.clear();
      _priceController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => _buildProductDialog(
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

  Widget _buildProductItem(Map product, int index) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.width(context) * 0.05,
      ),
      height: Screen.height(context) * 0.2,
      child: ProductBox(
        productId: product['id'].toString(),
        productImage: product['pictures'].isEmpty
            ? null
            : product['pictures'][0]['picturePath'],
        productDescription: product['description'],
        productPrice: product['price'].toString(),
        productName: product['name'],
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
            _currentPage < widget.listing['Product'].length - 1) {
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
            widget.listing['Product'].length,
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
                    : colors.white.withAlpha(77),
              ),
            ),
          ),
        ),
        _buildNavigationArrow(false)
      ],
    );
  }

  Widget _buildProductList() {
    if (widget.listing['Product'].isEmpty) return const SizedBox.shrink();
    final colors = AppColors(context);

    return Column(
      children: [
        SizedBox(
          height: Screen.height(context) * 0.22,
          child: SizedBox(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: widget.listing['Product'].length,
              itemBuilder: (context, index) {
                return _buildProductItem(
                  widget.listing['Product'][index],
                  index,
                );
              },
            ),
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
                  onPressed: () => _showProductDialog(index: _currentPage),
                ),
                SizedBox(width: Screen.width(context) * 0.05),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trash,
                    color: colors.red,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _handleDeleteProduct(_currentPage),
                ),
                SizedBox(width: Screen.width(context) * 0.05),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.circlePlus,
                    color: colors.yellow,
                    size: Screen.max(context) * 0.03,
                  ),
                  onPressed: () => _showProductDialog(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listing['products'].isEmpty) return const SizedBox.shrink();

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
              'Products',
              style: GoogleFonts.poppins(
                fontSize: Screen.max(context) * 0.025,
                fontWeight: FontWeight.w600,
                color: colors.white,
              ),
            ),
          ),
          SizedBox(height: Screen.height(context) * 0.02),
          _buildProductList(),
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
