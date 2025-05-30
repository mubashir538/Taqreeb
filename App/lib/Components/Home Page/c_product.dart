import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/cart_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';

class ProductDetailsPopup extends StatefulWidget {
  final String productId;
  final String productName;
  final String productDescription;
  final String productPrice;
  final List<String>? productImages;
  final VoidCallback onClose;
  final VoidCallback? onAddToCart;

  const ProductDetailsPopup({
    super.key,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.productImages,
    required this.onClose,
    this.onAddToCart,
  });

  @override
  State<ProductDetailsPopup> createState() => _ProductDetailsPopupState();
}

class _ProductDetailsPopupState extends State<ProductDetailsPopup> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleAddToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";

      await CartService.addToCart(
        token: token,
        itemType: 'product',
        itemId: widget.productId,
        quantity: 1,
      );

      if (widget.onAddToCart != null) {
        widget.onAddToCart!();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);
    final hasImages =
        widget.productImages != null && widget.productImages!.isNotEmpty;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.dark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productName,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            if (hasImages)
              SizedBox(
                height: Screen.height(context) * 0.3,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.productImages!.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image:
                                  FileImage(File(widget.productImages![index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    if (widget.productImages!.length > 1)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.productImages!.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? colors.white
                                    : colors.white.withAlpha(128),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.productDescription,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: colors.whiteDarker,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.productPrice,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.yellow,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.productId.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.red,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isAddingToCart ? null : _handleAddToCart,
                  child: _isAddingToCart
                      ? CircularProgressIndicator(color: colors.white)
                      : Text(
                          'Add to Cart',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.white,
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProductBox extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String productPrice;
  final String? productImage;
  final String? productId;
  final bool showPopupOnTap;
  final List<String>? popupImages;

  const ProductBox({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.productId,
    this.productImage,
    this.showPopupOnTap = true,
    this.popupImages,
  });

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  bool _isAddingToCart = false;

  void _showProductDetails(BuildContext context) {
    if (!widget.showPopupOnTap || widget.productId == null) {
      _addToCart();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ProductDetailsPopup(
        productId: widget.productId!,
        productName: widget.productName,
        productDescription: widget.productDescription,
        productPrice: widget.productPrice,
        productImages: widget.popupImages ??
            (widget.productImage != null ? [widget.productImage!] : null),
        onClose: () => Navigator.of(context).pop(),
        onAddToCart: _addToCart,
      ),
    );
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart || widget.productId == null) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";

      await CartService.addToCart(
        token: token,
        itemType: 'product',
        itemId: widget.productId!,
        quantity: 1,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added to cart')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return InkWell(
      onTap: () => _showProductDetails,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Screen.max(context) * 0.03,
          vertical: Screen.max(context) * 0.01,
        ),
        padding: EdgeInsets.all(Screen.max(context) * 0.02),
        decoration: BoxDecoration(
          color: colors.darkLighter,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (widget.productImage != null)
              Container(
                width: Screen.max(context) * 0.15,
                height: Screen.max(context) * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(File(widget.productImage!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(width: Screen.max(context) * 0.02),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.productName,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: Screen.max(context) * 0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!widget.showPopupOnTap && widget.productId != null)
                        SizedBox(
                          width: Screen.width(context) * 0.25,
                          child: ColoredButton(
                            text: _isAddingToCart ? 'Adding...' : 'Add to Cart',
                            onPressed: _isAddingToCart ? null : _addToCart,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: Screen.max(context) * 0.01),
                  Text(
                    widget.productDescription,
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: Screen.max(context) * 0.018,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Screen.max(context) * 0.01),
                  Text(
                    widget.productPrice,
                    style: GoogleFonts.roboto(
                      color: colors.yellow,
                      fontSize: Screen.max(context) * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
