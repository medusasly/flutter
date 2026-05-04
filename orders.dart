import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF0D1B2A),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Orders",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ),

        const Expanded(child: Center(child: Text("No orders yet"))),
      ],
    );
  }
}
