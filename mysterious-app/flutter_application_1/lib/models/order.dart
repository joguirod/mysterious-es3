import 'package:ecommerce_app/models/cart_item.dart';

enum OrderStatus { pending, confirmed, shipped, delivered, cancelled }

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final OrderStatus status;
  final String shippingAddress;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.status,
    required this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      total: json['total'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values.firstWhere((e) => e.toString() == json['status']),
      shippingAddress: json['shippingAddress'],
    );
  }
}