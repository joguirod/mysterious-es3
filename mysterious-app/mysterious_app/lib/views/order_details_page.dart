import 'package:flutter/material.dart';
import 'package:mysterious_app/models/MysteriousOrder.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido'),
      ),
      body: ListView.builder(
        itemCount: order['items'].length,
        itemBuilder: (context, index) {
          final item = order['items'][index];
          return ListTile(
            title: Text(item['categoryProduct'].descricao),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gênero: ${item['genre'].descricao}'),
                Text('Preço: R\$ ${item['preco']}'),
                Text('Quantidade: ${item['quantidade']}'),
              ],
            ),
          );
        },
    ),
    );
  }
}