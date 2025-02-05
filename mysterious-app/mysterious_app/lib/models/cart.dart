import 'package:mysterious_app/models/OrderItem.dart';
import 'package:mysterious_app/models/cartitem.dart';
import 'package:mysterious_app/models/product.dart';

class Cart {
  final List<Cartitem> items;

  Cart({
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: json['items'],
    );
  }
}