import 'package:flutter/material.dart';
import 'order_summary.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Card Payment")),
      body: Column(
        children: [
          TextField(
            controller: cardController,
            decoration: const InputDecoration(labelText: "Card Number"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderSummaryPage(method: "Card"),
                ),
              );
            },
            child: const Text("Pay"),
          ),
        ],
      ),
    );
  }
}
