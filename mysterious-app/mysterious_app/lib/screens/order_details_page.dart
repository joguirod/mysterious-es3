import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID do Pedido: ${order['id_pedido']}'),
            Text('Data do Pedido: ${order['data_pedido']}'),
            Text('Valor Total: R\$ ${order['valor_total']}'),
            Text('Categoria: ${order['descricao']}'),
            Text('Gênero: ${order['descricao']}'),
            
          ],
        ),
      ),
    );
  }
}