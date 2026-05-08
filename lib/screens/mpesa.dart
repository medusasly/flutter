import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mpesa_stk/flutter_mpesa_stk.dart';
import 'package:flutter_mpesa_stk/models/Mpesa.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../providers/cart_provider.dart';
import 'order_summary.dart';

class MpesaPage extends StatefulWidget {
  const MpesaPage({super.key});

  @override
  State<MpesaPage> createState() => _MpesaPageState();
}

class _MpesaPageState extends State<MpesaPage> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _statusMessage;

  Future<void> _initiatePayment() async {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      setState(() => _statusMessage = 'Please enter your phone number');
      return;
    }

    final cart = context.read<CartProvider>();
    final amount = cart.total;

    if (amount <= 0) {
      setState(() => _statusMessage = 'Cart is empty');
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Initiating M-Pesa STK push...';
    });

    // Get credentials from .env
    final consumerKey = dotenv.env['MPESA_CONSUMER_KEY'] ?? '';
    final consumerSecret = dotenv.env['MPESA_CONSUMER_SECRET'] ?? '';
    final passkey = dotenv.env['MPESA_PASSKEY'] ?? '';
    final shortCode = dotenv.env['MPESA_SHORTCODE'] ?? '174379';
    
    // Generate STK password (base64 of shortcode+passkey+timestamp)
    final timestamp = DateTime.now().toString().replaceAll(RegExp(r'[^0-9]'), '').substring(0, 14);
    final password = base64Encode(utf8.encode('$shortCode$passkey$timestamp'));
    
    final response = await FlutterMpesaSTK(
      consumerKey,
      consumerSecret,
      password,
      shortCode,
      'https://postman-echo.com/post', // Callback URL
      'Payment failed. Please try again.',
      env: 'testing', // Use 'production' for live
    ).stkPush(
      Mpesa(
        amount.ceil(),
        phone,
        accountReference: 'GasLy${DateTime.now().millisecondsSinceEpoch}',
        transactionDesc: 'Gas Order Payment - KES ${amount.toStringAsFixed(0)}',
      ),
    );

    setState(() {
      _isLoading = false;
      _statusMessage = response.status 
          ? 'STK push sent! Check your phone and enter M-Pesa PIN'
          : 'Payment failed: ${response.body}';
    });

    if (response.status == true) {
      // Payment initiated successfully
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check your phone for M-Pesa prompt and enter PIN'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        // Navigate to success page after a short delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          cart.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const OrderSummaryPage(method: "M-Pesa"),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final total = cart.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text("M-Pesa Payment"),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'KES ${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cart.items.length} items in cart',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Phone Number Input
            const Text(
              'Enter M-Pesa Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'e.g., 0712345678 or 254712345678',
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0D1B2A), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You will receive an M-Pesa prompt on this number',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),

            // Status Message
            if (_statusMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.blue.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isLoading ? Colors.blue.shade200 : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D1B2A)),
                        ),
                      ),
                    if (_isLoading) const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: TextStyle(
                          fontSize: 14,
                          color: _isLoading ? Colors.blue.shade800 : Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _initiatePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : const Text(
                        'Pay with M-Pesa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Mode Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sandbox Mode: Use test credentials from Safaricom Daraja Portal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
