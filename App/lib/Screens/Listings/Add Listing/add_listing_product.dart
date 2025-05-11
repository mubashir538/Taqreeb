import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Components/Home%20Page/c_product.dart';
import 'package:taqreeb/Components/global/header.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/ui_management.dart';
import 'package:taqreeb/core/utils/color.dart';

class AddCategoryProducts extends StatefulWidget {
  const AddCategoryProducts({super.key});

  @override
  State<AddCategoryProducts> createState() => _AddCategoryProductsState();
}

class _AddCategoryProductsState extends State<AddCategoryProducts> {
  final GlobalKey _headerKey = GlobalKey();
  Map<String, dynamic> _args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs != null) {
      _args = routeArgs as Map<String, dynamic>;
      _args['products'] ??= []; // Initialize products if null
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UImanagement.getHeaderHeight(
        headerKey: _headerKey,
        callback: _updateHeaderHeight,
      );
    });
  }

  void _updateHeaderHeight(RenderBox renderbox) {
    setState(() => UImanagement.headerHeight = renderbox.size.height);
  }

  void _navigateToAddProduct() {
    Navigator.pushNamed(
      context,
      '/AddCategory_AddProduct', // You'll need to create this route
      arguments: _args,
    );
  }

  void _navigateToNextStep() {
    Navigator.pushNamed(
      context,
      '/AddCategory_AddImage', // Adjust this to your navigation flow
      arguments: _args,
    );
  }

  @override
  Widget build(BuildContext context) {
    UImanagement.getHeaderHeight(
      headerKey: _headerKey,
      callback: _updateHeaderHeight,
    );

    return Scaffold(
      backgroundColor: MyColors.dark,
      body: Stack(
        children: [
          _buildContent(),
          _buildContinueButton(),
          _buildHeader(),
        ],
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: Screen.height(context)),
        width: Screen.width(context),
        child: Column(
          children: [
            SizedBox(
              height:
                  (Screen.height(context) * 0.03) + UImanagement.headerHeight,
            ),
            _buildTitle(),
            _buildProductsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.all(Screen.max(context) * 0.01),
      child: Text(
        "Products",
        style: GoogleFonts.roboto(
          fontSize: Screen.max(context) * 0.025,
          fontWeight: FontWeight.w600,
          color: MyColors.yellow,
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return _args['products']?.isNotEmpty ?? false
        ? Column(
            children: _args['products']
                .map<Widget>((product) => _buildProductItem(product))
                .toList(),
          )
        : const SizedBox.shrink();
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return ProductBox(
      productName: product['name'],
      productDescription: product['description'],
      productPrice: product['price'],
      productImage: product['image'],
    );
  }

  Widget _buildContinueButton() {
    return Positioned(
      bottom: Screen.height(context) * 0.02,
      left: Screen.width(context) * 0.25,
      right: Screen.width(context) * 0.25,
      child: ColoredButton(
        text: 'Continue',
        width: Screen.width(context) * 0.5,
        onPressed: _navigateToNextStep,
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      child: Header(
        key: _headerKey,
        heading: 'Service Products',
        para: 'Add products for your service',
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      backgroundColor: MyColors.yellow,
      onPressed: _navigateToAddProduct,
      child: Icon(
        FontAwesomeIcons.plus,
        color: MyColors.dark,
        size: Screen.max(context) * 0.04,
      ),
    );
  }
}
