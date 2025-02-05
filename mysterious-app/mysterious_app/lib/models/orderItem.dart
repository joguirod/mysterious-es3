import 'package:mysterious_app/models/MysteriousOrder.dart';
import 'package:mysterious_app/models/category.dart';
import 'package:mysterious_app/models/genre.dart';
import 'package:mysterious_app/models/product.dart';
import 'package:uuid/uuid.dart';

class OrderItem {
  final Uuid id_item_pedido;
  final MysteriousOrder mysteriousOrder;
  final CategoryProduct categoryProduct;
  final Genre genre;
  final int quantidade;
  final double preco;

  OrderItem ({
    required this.id_item_pedido,
    required this.mysteriousOrder,
    required this.categoryProduct,
    required this.genre,
    required this.quantidade,
    required this.preco,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id_item_pedido: json['id_item_pedido'],
      mysteriousOrder: json['mysteriousOrder'],
      categoryProduct: json['categoryProduct'],
      genre: json['genre'],
      quantidade: json['quantidade'],
      preco: json['preco'],
    );
  }
}