import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import '../providers/cart_provider.dart';
import '../screens/app_theme.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int qty;

  const CartItem({super.key, required this.product, required this.qty});

  @override
  Widget build(BuildContext context) {
    final isTotalGas = product.name.toLowerCase().contains('total');
    final brandColor = isTotalGas 
        ? const Color(0xFF1B365D) 
        : const Color(0xFF2F855A);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: brandColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  brandColor.withOpacity(0.15),
                  brandColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: product.image.endsWith('.svg')
                  ? SvgPicture.asset(
                      product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.local_gas_station,
                      size: 40,
                      color: brandColor,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: brandColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isTotalGas ? 'TOTAL' : 'K-GAS',
                    style: TextStyle(
                      color: brandColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'KES ${product.price.toStringAsFixed(0)} each',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Column(
            children: [
              // Increase Button
              GestureDetector(
                onTap: () => context.read<CartProvider>().increase(product),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brandColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              
              // Quantity
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '$qty',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              
              // Decrease Button
              GestureDetector(
                onTap: () => context.read<CartProvider>().decrease(product),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
