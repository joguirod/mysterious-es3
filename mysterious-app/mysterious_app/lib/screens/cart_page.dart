import 'package:flutter/material.dart';
import 'payment_page.dart';
import 'login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({Key? key, required this.cart}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void removeFromCart(int index) {
    setState(() {
      widget.cart.removeAt(index);
    });
  }

  void _finalizePurchase() {
    if (widget.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você deve colocar algum item para finalizar a compra')),
      );
    } else {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(cart: widget.cart)),
        ).then((result) {
          if (result == true) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentPage(cart: widget.cart)),
            );
          }
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentPage(cart: widget.cart)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.cart.fold(0, (sum, item) => sum + item['preco'] * item['quantidade']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: widget.cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '🛒',
                    style: TextStyle(fontSize: 64),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ainda sem compras',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Itens no Carrinho:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: widget.cart.length,
                        itemBuilder: (context, index) {
                          final item = widget.cart[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.network(
                                item['imagem_url'],
                                height: 50,
                                width: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              ),
                              title: Text('Produto ID: ${item['produto_id']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Categoria ID: ${item['categoria_id']}'),
                                  Text('Quantidade: ${item['quantidade']}'),
                                  Text('Preço: R\$ ${item['preco'].toStringAsFixed(2)}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  removeFromCart(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Total: R\$ ${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Continuar Comprando'),
            ),
            TextButton(
              onPressed: _finalizePurchase,
              child: const Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}