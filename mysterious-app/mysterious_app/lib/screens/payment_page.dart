import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;

  const PaymentPage({Key? key, required this.cart}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPaymentMethod;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardExpiryController = TextEditingController();
  final TextEditingController cardCVCController = TextEditingController();

  double getTotalAmount() {
    double total = 0.0;
    for (var item in widget.cart) {
      total += item['preco'] * item['quantidade'];
    }
    return total;
  }

  Future<void> _generateBoletoPdf() async {
    final pdf = pw.Document();
    final totalAmount = getTotalAmount();

    final image = await networkImage('https://via.placeholder.com/200x100.png?text=Boleto+Falso');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Boleto Gerado', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Valor: R\$ ${totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Image(image, height: 100),
              pw.SizedBox(height: 10),
              pw.Text(
                'Código de Barras: 12345.67890 12345.678901 12345.678901 1 23456789012345',
                style: pw.TextStyle(fontSize: 16),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'boleto.pdf');
  }

  Future<String?> criarPedido(String usuarioId, double valorTotal) async {
    final response = await Supabase.instance.client.from('pedido').insert([
      {
        'id_pedido': Uuid().v4(), // Gerar um UUID para o pedido
        'id_mysterious_user': usuarioId,
        'data_pedido': DateTime.now().toIso8601String(),
        'data_finalizacao': DateTime.now().toIso8601String(),
        'valor_total': valorTotal,
        'id_categoria': widget.cart.isNotEmpty ? widget.cart[0]['categoria_id'] : null,
        'id_genero': widget.cart.isNotEmpty ? widget.cart[0]['genero_id'] : null,
        'descricao_categoria': widget.cart.isNotEmpty ? widget.cart[0]['categoria_descricao'] : null,
        'descricao_genero': widget.cart.isNotEmpty ? widget.cart[0]['genero_descricao'] : null,
      }
    ]).execute();

    if (response.error != null) {
      print('Erro ao criar pedido: ${response.error!.message}');
      return null;
    } else {
      print('Pedido criado com sucesso!');
      return response.data[0]['id_pedido'];
    }
  }

  Future<void> _processPayment() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado')),
        );
      }
      return;
    }

    final totalAmount = getTotalAmount();

    if (selectedPaymentMethod == 'credit_card') {
      if (cardNumberController.text.isEmpty || cardExpiryController.text.isEmpty || cardCVCController.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor, preencha todos os campos do cartão de crédito')),
          );
        }
        return;
      }
    }
    final pedidoId = await criarPedido(userId, totalAmount);

    if (pedidoId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar pedido')),
        );
      }
      return;
    }

    
    for (var item in widget.cart) {
      final itemPedidoResponse = await Supabase.instance.client
          .from('itempedido')
          .insert({
            'id_pedido': pedidoId,
            'id_produto': item['id_produto'],
            'quantidade': item['quantidade'],
            'preco': item['preco'],
            'id_categoria': item['categoria_id'],
            'id_genero': item['genero_id'],
          })
          .execute();

      if (itemPedidoResponse.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao adicionar item ao pedido: ${itemPedidoResponse.error!.message}')),
          );
        }
        return;
      }
    }

    if (selectedPaymentMethod == 'boleto') {
      await _generateBoletoPdf();
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Aguardando pagamento'),
            content: const Text('Por favor, aguarde enquanto processamos seu pagamento.'),
          );
        },
      );
    }

    Future.delayed(const Duration(seconds: 10), () async {
      if (mounted) {
        Navigator.of(context).pop(); 
      }

     
      final updateResponse = await Supabase.instance.client
          .from('pedido')
          .update({
            'data_finalizacao': DateTime.now().toIso8601String(),
          })
          .eq('id_pedido', pedidoId)
          .execute();

      if (updateResponse.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar status do pedido: ${updateResponse.error!.message}')),
          );
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pagamento efetuado com sucesso!')),
        );
        Navigator.pop(context); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = getTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecione o método de pagamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Cartão de Crédito'),
              leading: Radio<String>(
                value: 'credit_card',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('PIX'),
              leading: Radio<String>(
                value: 'pix',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Boleto'),
              leading: Radio<String>(
                value: 'boleto',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Valor Total: R\$ ${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (selectedPaymentMethod == 'credit_card') ...[
              const Text(
                'Informações do Cartão de Crédito:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número do Cartão',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cardExpiryController,
                decoration: const InputDecoration(
                  labelText: 'Validade (MM/AA)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cardCVCController,
                decoration: const InputDecoration(
                  labelText: 'CVC',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Pagar'),
              ),
            ] else if (selectedPaymentMethod == 'pix') ...[
              const Text(
                'Pagamento via PIX:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: SelectableText(
                  'Chave PIX Aleatória: 1234567890',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Confirmar Pagamento'),
              ),
            ] else if (selectedPaymentMethod == 'boleto') ...[
              const Text(
                'Pagamento via Boleto:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  color: Colors.grey[300],
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Boleto Gerado',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Valor: R\$ ${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Image.network(
                        'https://via.placeholder.com/200x100.png?text=Boleto+Falso',
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      const SelectableText(
                        'Código de Barras: 12345.67890 12345.678901 12345.678901 1 23456789012345',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _processPayment,
                child: const Text('Confirmar Pagamento'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}