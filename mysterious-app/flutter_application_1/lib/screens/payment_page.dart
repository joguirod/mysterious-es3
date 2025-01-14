import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../authentication.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, String>> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'Cartão';
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final String _pixKey = Uuid().v4();

  double _calculateTotal() {
    double total = 0.0;
    for (var item in widget.cartItems) {
      total += double.parse(item["price"]!.replaceAll(RegExp(r'[^\d.]'), '').replaceAll(',', '.'));
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);
    double total = _calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Finalizar Compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valor Total: R\$ ${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Selecione o método de pagamento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Cartão'),
              leading: Radio<String>(
                value: 'Cartão',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Pix'),
              leading: Radio<String>(
                value: 'Pix',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Boleto'),
              leading: Radio<String>(
                value: 'Boleto',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            if (_paymentMethod == 'Cartão') ...[
              TextField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Número do Cartão',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _expiryDateController,
                decoration: InputDecoration(
                  labelText: 'Data de Validade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _cvvController,
                decoration: InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ] else if (_paymentMethod == 'Pix') ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      'Chave Pix para pagamento:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    SelectableText(
                      _pixKey,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ] else if (_paymentMethod == 'Boleto') ...[
              ElevatedButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  pdf.addPage(
                    pw.Page(
                      build: (pw.Context context) => pw.Center(
                        child: pw.Text('Boleto Falso\nValor: R\$ ${total.toStringAsFixed(2)}'),
                      ),
                    ),
                  );
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdf.save(),
                  );
                },
                child: Text('Gerar Boleto'),
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Lógica para finalizar a compra
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Compra finalizada com sucesso!')),
                );
              },
              child: Text('Finalizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}