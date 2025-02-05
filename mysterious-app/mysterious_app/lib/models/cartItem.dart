import 'package:mysterious_app/models/product.dart';

class Cartitem {
  final Product product;
  final int quantidade;

  Cartitem({
    required this.product,
    required this.quantidade,
  });

  factory Cartitem.fromJson(Map<String, dynamic> json) {
    return Cartitem(
      product: json['product'],
      quantidade: json['quantidade'],
    );
  }
}