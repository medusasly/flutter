import 'package:flutter/material.dart';

class OrderSummaryPage extends StatefulWidget {
  final String method;

  const OrderSummaryPage({super.key, required this.method});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Payment Successful",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Method: ${widget.method}"),
            ],
          ),
        ),
      ),
    );
  }
}
