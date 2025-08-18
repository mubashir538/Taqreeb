import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/models/cart_model.dart';

class CartService {
static Future<Cart> getCart(String token) async {
  final response = await MyApi.getRequest(
    endpoint: 'cart/',
    refresh: true,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response['status'] == 'error') {
    throw Exception(response['message']);
  }

  // Parse the items
  final items = (response['items'] as List).map((item) {
    return CartItem(
      id: item['id'].toString(),
      itemType: item['item_type'],
      itemId: item['item_id'].toString(),
      quantity: item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 1,
      addedAt: DateTime.parse(item['added_at']),
      itemDetails: item['item_details'],
    );
  }).toList();

  return Cart(
    id: response['id'].toString(),
    userId: response['user'].toString(),
    items: items,
    totalItems: response['total_items'] is int ? response['total_items'] : int.tryParse(response['total_items'].toString()) ?? 0,
    totalPrice: response['total_price'] is double ? response['total_price'] : double.tryParse(response['total_price'].toString()) ?? 0.0,
    createdAt: DateTime.parse(response['created_at']),
    updatedAt: DateTime.parse(response['updated_at']),
  );
}

  static Future<CartItem> addToCart({
    required String token,
    required String itemType,
    required String itemId,
    int quantity = 1,
  }) async {
    final response = await MyApi.postRequest(
      endpoint: 'cart/items/add_item/', // POST to the items endpoint
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'item_type': itemType,
        'item_id': itemId,
        'quantity': quantity,
        // Don't include cart_id - it will be set automatically by the ViewSet
      },
    );

    if (response['status'] == 'error') {
      throw Exception('Already Added to Cart');
    }

    return CartItem.fromJson(response);
  }

  static Future<void> removeFromCart({
    required String token,
    required String itemId,
  }) async {
    final response = await MyApi.deleteRequest(
      endpoint: 'cart/items/$itemId/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response['status'] == 'error') {
      throw Exception(response['message']);
    }
  }

  static Future<CartItem> updateQuantity({
    required String token,
    required String itemId,
    required int quantity,
  }) async {
    final response = await MyApi.putRequest(
      endpoint: 'cart/items/$itemId/',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'quantity': quantity,
      },
    );

    if (response['status'] == 'error') {
      throw Exception(response['message']);
    }

    return CartItem.fromJson(response);
  }

  static Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> data) async {
    final response = await MyApi.postRequest(
      endpoint: 'create_order/',
      body: data,
    );
    return response;
  }

  static Future<Map<String, dynamic>> processPayment(
      Map<String, dynamic> data) async {
    final response = await MyApi.postRequest(
      endpoint: 'process_payment/',
      body: data,
    );
    return response;
  }
}
