import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/models/cart_model.dart';

class CartService {
  static Future<Cart> getCart(String token) async {
    final response = await MyApi.getRequest(
      endpoint: 'cart/',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response['status'] == 'error') {
      throw Exception(response['message']);
    }

    return Cart.fromJson(response);
  }

  static Future<CartItem> addToCart({
    required String token,
    required String itemType,
    required String itemId,
    int quantity = 1,
  }) async {
    final response = await MyApi.postRequest(
      endpoint: 'cart/items/',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'item_type': itemType,
        'item_id': itemId,
        'quantity': quantity,
      },
    );

    if (response['status'] == 'error') {
      throw Exception(response['message']);
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
