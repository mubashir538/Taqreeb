import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taqreeb/Components/Buttons/c_color_button.dart';
import 'package:taqreeb/Screens/Payments/booking_information_screen.dart';
import 'package:taqreeb/core/models/cart_model.dart';
import 'package:taqreeb/core/services/cart_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/core/utils/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taqreeb/core/utils/images.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<Cart> _cartFuture;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    _token = await MyStorage.getToken(MyTokens.accessToken);
    setState(() {
      _cartFuture = CartService.getCart(_token!);
    });
  }

  Future<void> _removeItem(String itemId) async {
    try {
      await CartService.removeFromCart(token: _token!, itemId: itemId);
      _loadCart(); // Refresh cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateQuantity(String itemId, int newQuantity) async {
    try {
      await CartService.updateQuantity(
        token: _token!,
        itemId: itemId,
        quantity: newQuantity,
      );
      _loadCart(); // Refresh cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        centerTitle: true,
        backgroundColor: colors.dark,
      ),
      backgroundColor: colors.darkLighter,
      body: FutureBuilder<Cart>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load cart\n${snapshot.error}',
                style: GoogleFonts.roboto(color: colors.white),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    MyImages.helpCenter,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.roboto(
                      color: colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add items to get started',
                    style: GoogleFonts.roboto(
                      color: colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          final cart = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _buildCartItem(item);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.dark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Items',
                          style: GoogleFonts.roboto(
                            color: colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          cart.totalItems.toString(),
                          style: GoogleFonts.roboto(
                            color: colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price',
                          style: GoogleFonts.roboto(
                            color: colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '\$${cart.totalPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.roboto(
                            color: colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ColoredButton(
                      text: 'Proceed to Booking',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingInformationScreen(cart: cart),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    final colors = AppColors(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: colors.dark,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        item.itemDetails['pictures']?[0]?['picturePath'] ?? '',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemDetails['name'] ?? 'No Name',
                        style: GoogleFonts.roboto(
                          color: colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _getItemDescription(item),
                        style: GoogleFonts.roboto(
                          color: colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\$${_getItemPrice(item).toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(
                          color: colors.yellow,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.minus, color: colors.white),
                      onPressed: item.quantity > 1
                          ? () => _updateQuantity(item.id, item.quantity - 1)
                          : null,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.white),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.quantity.toString(),
                        style: GoogleFonts.roboto(color: colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.plus, color: colors.white),
                      onPressed: () =>
                          _updateQuantity(item.id, item.quantity + 1),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.trash, color: colors.red),
                  onPressed: () => _removeItem(item.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getItemDescription(CartItem item) {
    switch (item.itemType) {
      case 'listing':
        return item.itemDetails['description'] ?? 'Listing';
      case 'product':
        return item.itemDetails['description'] ?? 'Product';
      case 'package':
        return item.itemDetails['description'] ?? 'Package';
      default:
        return '';
    }
  }

  double _getItemPrice(CartItem item) {
    switch (item.itemType) {
      case 'listing':
        return (item.itemDetails['priceMin'] ?? 0).toDouble() * item.quantity;
      case 'product':
        return (item.itemDetails['price'] ?? 0).toDouble() * item.quantity;
      case 'package':
        return (item.itemDetails['price'] ?? 0).toDouble() * item.quantity;
      default:
        return 0.0;
    }
  }
}
