import 'package:mysterious_app/models/OrderItem.dart';
import 'package:uuid/uuid.dart';

class MysteriousOrder {
  final Uuid id_pedido;
  final Uuid id_mysterious_user;
  final String data_pedido;
  final String data_finalizacao;
  final double valor_total;
  List<OrderItem> items;

  MysteriousOrder({
    required this.id_pedido,
    required this.id_mysterious_user,
    required this.data_pedido,
    required this.data_finalizacao,
    required this.valor_total,
    required this.items,
  });

  MysteriousOrder.withoutItems({
    required this.id_pedido,
    required this.id_mysterious_user,
    required this.data_pedido,
    required this.data_finalizacao,
    required this.valor_total,
  }) : items = [];

  factory MysteriousOrder.fromJson(Map<String, dynamic> json) {
    return MysteriousOrder(
      id_pedido: json['id_pedido'],
      id_mysterious_user: json['id_mysterious_user'],
      data_pedido: json['data_pedido'],
      data_finalizacao: json['data_finalizacao'],
      valor_total: json['valor_total'],
      items: json['items'],
    );
  }
}

