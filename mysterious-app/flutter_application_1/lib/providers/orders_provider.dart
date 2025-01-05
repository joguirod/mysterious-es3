import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/cart_item.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => [..._orders];

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        userId: 'demo-user',
        items: cartItems,
        total: total,
        createdAt: DateTime.now(),
        status: OrderStatus.pending,
        shippingAddress: 'Endereço de demonstração',
      ),
    );
    notifyListeners();
  }

  fetchOrders() {}
}