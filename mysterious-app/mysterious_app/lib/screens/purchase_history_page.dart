import 'package:flutter/material.dart';
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
          .select('id_pedido, data_pedido, valor_total, descricao_categoria, descricao_genero')
          .eq('id_mysterious_user', userId)
          .execute();

      if (response.error == null && response.data != null) {
        setState(() {
          purchaseHistory = (response.data as List)
              .map((e) => {
                    'id_pedido': e['id_pedido'],
                    'data_pedido': e['data_pedido'],
                    'valor_total': e['valor_total'],
                    'descricao_categoria': e['descricao_categoria'],
                    'descricao_genero': e['descricao_genero'],
                  })
              .toList();
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
                Text('Categoria: ${purchase['descricao_categoria']}'),
                Text('Gênero: ${purchase['descricao_genero']}'),
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