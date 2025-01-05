import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    Product(
      id: '1',
      name: 'Livro Romance',
      description: 'Apresenta uma história completa composta por narrador, enredo, temporalidade, ambientação e personagens definidos de maneira clara.',
      price: 80.00,
      imageUrl: 'https://m.media-amazon.com/images/G/32/apparel/rcxgs/tile._CB483369971_.gif',
      stock: 10,
    ),
    Product(
      id: '2',
      name: 'Livro Sci-Fi',
      description: 'Se baseia em conceitos científicos e tecnológicos para criar enredos ficcionais',
      price: 60.00,
      imageUrl: 'https://m.media-amazon.com/images/G/32/apparel/rcxgs/tile._CB483369971_.gif',
      stock: 5,
    ),
    Product(
      id: '3',
      name: 'Livro Terror',
      description: 'Tem como objetivo provocar medo e horror nos leitores',
      price: 70.00,
      imageUrl: 'https://m.media-amazon.com/images/G/32/apparel/rcxgs/tile._CB483369971_.gif',
      stock: 15,
    ),
  ];

  List<Product> get products => [..._products];

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }
}