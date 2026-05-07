import 'package:flutter/material.dart';
import '../models/products.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final products = [
      Product(
        name: "Total Gas 13kg",
        price: 3510,
        image: "assets/images/total-13kg.png",
        brand: "Total",
        weight: "13kg",
      ),
      Product(
        name: "Total Gas 6kg",
        price: 1850,
        image: "assets/images/total6kg.png",
        brand: "Total",
        weight: "6kg",
      ),
      Product(
        name: "K-Gas 13kg",
        price: 3450,
        image: "assets/images/k-gas-13.png",
        brand: "K-Gas",
        weight: "13kg",
      ),
      Product(
        name: "K-Gas 6kg",
        price: 1620,
        image: "assets/images/k-gas.png",
        brand: "K-Gas",
        weight: "6kg",
      ),
      Product(
        name: "Shell Gas 13kg",
        price: 3600,
        image: "assets/images/shell-13kg.png",
        brand: "Shell",
        weight: "13kg",
      ),
      Product(
        name: "Shell Gas 6kg",
        price: 1900,
        image: "assets/images/shell-6kg.png",
        brand: "Shell",
        weight: "6kg",
      ),
      Product(
        name: "Gas Regulator",
        price: 850,
        image: "assets/images/regulator.png",
        brand: "Generic",
        weight: "",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: CustomScrollView(
        slivers: [
          // Warm, friendly header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF2D3436),
              ),
              child: Row(
                children: [
                  // Warm logo container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B4A).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFF6B4A),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gas-Ly",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Cooking gas delivered fast",
                          style: TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search bar - warm, inviting
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE8E4E0),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: const Color(0xFF2D3436).withOpacity(0.4),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Search gas brands...",
                    style: TextStyle(
                      color: const Color(0xFF2D3436).withOpacity(0.4),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Warm hero card
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B4A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "FREE DELIVERY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Fresh gas,\ndelivered fast",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "We deliver within 30 minutes",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section header with warm styling
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B4A),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Available Now",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid - more breathing room
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProductCard(product: products[index]),
                childCount: products.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),

          // Trust indicators
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE8E4E0),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTrustItem(Icons.timer, "30 min", "Delivery"),
                  _buildTrustItem(Icons.verified, "Certified", "Safe gas"),
                  _buildTrustItem(Icons.support_agent, "24/7", "Support"),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildTrustItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFFF6B4A),
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Color(0xFF2D3436),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF2D3436).withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
