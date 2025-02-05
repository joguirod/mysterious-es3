import 'package:flutter/foundation.dart';
import 'package:mysterious_app/models/category.dart';
import 'package:mysterious_app/models/genre.dart';

class Product {
  final int id_produto;
  final int quantidade_estoque;
  final CategoryProduct categoria;
  final Genre genero;

  Product({
    required this.id_produto,
    required this.quantidade_estoque,
    required this.genero,
    required this.categoria,
  });

  Product.namedConstructor({
    required this.genero,
    required this.categoria,
  }) : id_produto = 0, quantidade_estoque = 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id_produto: json['id_produto'],
      quantidade_estoque: json['quantidade_estoque'],
      genero: json['genero'],
      categoria: json['categoria'],
    );
  }
}