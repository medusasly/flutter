import 'package:flutter/material.dart';
import 'order_summary.dart';

class MpesaPage extends StatelessWidget {
  const MpesaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("M-Pesa Payment")),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Phone Number"),
          ),
          ElevatedButton(
            onPressed: () {
              // simulate STK push
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderSummaryPage(method: "M-Pesa"),
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
