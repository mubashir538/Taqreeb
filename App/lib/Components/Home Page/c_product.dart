import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/services/cart_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';

class ProductBox extends StatefulWidget {
  final String productName;
  final String productDescription;
  final String productPrice;
  final String? productImage;
  final String? productId; // Now optional (nullable)

  const ProductBox({
    super.key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.productId, // No longer required
    this.productImage,
  });

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  bool _isAddingToCart = false;

  Future<void> _addToCart() async {
    if (_isAddingToCart || widget.productId == null) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final token = await MyStorage.getToken(MyTokens.accessToken);
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login to add items to cart')),
          );
          context.pushNamedTransition(
              routeName: '/Login',
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: 300));
        }
        return;
      }

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
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Screen.max(context) * 0.03,
        vertical: Screen.max(context) * 0.01,
      ),
      padding: EdgeInsets.all(Screen.max(context) * 0.02),
      decoration: BoxDecoration(
        color: MyColors.darkLighter,
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
                    // Conditionally show "Add to Cart" button
                    if (widget.productId != null)
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
                    color: MyColors.yellow,
                    fontSize: Screen.max(context) * 0.022,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
