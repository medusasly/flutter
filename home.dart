import 'package:flutter/material.dart';
import '../models/products.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(
        name: "Total 13kg Refill",
        price: 3510,
        image: "assets/total.jpg",
      ),
      Product(name: "K-Gas 6kg", price: 1620, image: "assets/kgas.jgp"),
    ];

    return Column(
      children: [
        // HEADER
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
              "Gas-Ly",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // GRID
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          ),
        ),
      ],
    );
  }
}
