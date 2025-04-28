class CartItem {
  final String id;
  final String itemType; // 'listing', 'product', or 'package'
  final String itemId;
  final int quantity;
  final DateTime addedAt;
  final dynamic itemDetails; // Will contain the full item details

  CartItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.quantity,
    required this.addedAt,
    required this.itemDetails,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      itemType: json['item_type'],
      itemId: json['item_id'].toString(),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['added_at']),
      itemDetails: json['item_details'],
    );
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final int totalItems;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalItems,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: json['user'].toString(),
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalItems: json['total_items'],
      totalPrice: json['total_price'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
