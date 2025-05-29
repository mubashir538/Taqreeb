import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/core/services/screen_size.dart';
import 'package:taqreeb/core/services/user_logs.dart';
import 'package:taqreeb/core/services/cart_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class BookNowButton extends StatefulWidget {
  final Map<String, dynamic> listing;
  final BuildContext context;
  const BookNowButton({
    super.key,
    required this.context,
    required this.listing,
  });

  @override
  State<BookNowButton> createState() => _BookNowButtonState();
}

class _BookNowButtonState extends State<BookNowButton> {
  bool _isAddingToCart = false;

  Future<void> _handleBookNow() async {
    await Logs.logUserActivity(
      "book_${widget.listing['Listing']['type'].toLowerCase().trim()}",
      {"listing_id": widget.listing['Listing']['id'] ?? 0},
    );

    widget.context.pushNamedTransition(
      routeName: '/OrderSummary',
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 300),
      arguments: {
        'Name': widget.listing['Listing']['name'],
        'type': widget.listing['Listing']['type'],
        'price': widget.listing['Listing']['basicPrice'],
        'id': widget.listing['Listing']['id']
      },
    );
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      final token = await MyStorage.getToken(MyTokens.accessToken);
      
      await CartService.addToCart(
        token: token ?? "",
        itemType: 'listing',
        itemId: widget.listing['Listing']['id'].toString(),
        quantity: 1,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing added to cart')),
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
    return Padding(
      padding: EdgeInsets.only(top: Screen.height(context) * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.02),
              child: ColoredButton(
                text: 'Book Now',
                onPressed: _handleBookNow,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Screen.width(context) * 0.02),
              child: ColoredButton(
                text: _isAddingToCart ? 'Adding...' : 'Add to Cart',
                onPressed: _addToCart,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
