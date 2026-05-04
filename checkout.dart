import 'package:flutter/material.dart';
import 'mpesa.dart';
import 'card.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _tile(context, "M-Pesa", Icons.phone_android, const MpesaPage()),
            _tile(context, "Card", Icons.credit_card, const CardPage()),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String text, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [Icon(icon), const SizedBox(width: 12), Text(text)],
        ),
      ),
    );
  }
}
