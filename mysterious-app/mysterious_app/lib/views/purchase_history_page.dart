import 'package:flutter/material.dart';
import 'package:mysterious_app/models/MysteriousOrder.dart';
import 'package:mysterious_app/models/OrderItem.dart';
import 'package:mysterious_app/models/category.dart';
import 'package:mysterious_app/models/genre.dart';
import 'package:mysterious_app/models/mysteriousUser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_details_page.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  List<Map<String, dynamic>> purchaseHistory = [];

  @override
  void initState() {
    super.initState();
    fetchPurchaseHistory();
  }

  Future<void> fetchPurchaseHistory() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final userId = session.user!.id;
      final response = await Supabase.instance.client
        .from('pedido')
        .select('id_pedido, data_pedido, data_finalizacao, valor_total')
        .eq('id_mysterious_user', userId)
        .execute();

      if (response.error == null && response.data != null) {
        List<Map<String, dynamic>> orders = [];
        for (var e in response.data!) {
          orders.add({
            'id_pedido': e['id_pedido'],
            'data_pedido': e['data_pedido'],
            'data_finalizacao': e['data_finalizacao'] ?? '',
            'id_mysterious_user': e['id_mysterious_user'] ?? '',
            'valor_total': e['valor_total'],
          });

          final responseItems = await Supabase.instance.client
        .from('itempedido')
        .select('id_item_pedido, id_categoria, id_genero, categoriaproduto!inner(descricao), genero!inner(descricao), preco, quantidade')
        .eq('id_pedido', e['id_pedido'])
        .execute();

          List<Map<String, dynamic>> items = [];
          if (responseItems.error == null && responseItems.data != null) {
            print(responseItems.data);
        items = (responseItems.data as List<dynamic>)
          .map((item) => {
            'id_item_pedido': item['id_item_pedido'],
            'mysteriousOrder': orders.last,
            'categoryProduct': CategoryProduct.withDescricao(descricao: item['categoriaproduto']['descricao'] ?? '', id_categoria: item['id_categoria'] ?? ''),
            'genre': Genre.withDescricao(descricao: item['genero']['descricao'] ?? '', id_genero: item['id_genero'] ?? ''),
            'preco': item['preco'],
            'quantidade': item['quantidade'],
          }).toList();
          }

          orders.last['items'] = items;
        }

        setState(() {
          purchaseHistory = orders;
        });
      } else {
        print('Erro ao buscar histórico de compras: ${response.error?.message}');
      }
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Compras'),
      ),
      body: ListView.builder(
        itemCount: purchaseHistory.length,
        itemBuilder: (context, index) {
          final purchase = purchaseHistory[index];
          return ListTile(
            title: Text('Pedido #${purchase['id_pedido']}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data: ${purchase['data_pedido']}'),
                Text('Valor: R\$ ${purchase['valor_total']}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsPage(order: purchase),
                ),
              );
            },
          );
        },
      ),
    );
  }
}