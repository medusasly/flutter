import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';
import 'orders.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF2D3436),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Info Card
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE8E8E8),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B4A), Color(0xFFFF8A6B)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    auth.userName ?? 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    auth.userEmail ?? 'user@example.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF666666),
                    ),
                  ),
                  if (auth.phoneNumber != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      auth.phoneNumber!,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Menu Items
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE8E8E8),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    subtitle: "View order history",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersPage()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 70),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: "Delivery Address",
                    subtitle: "Manage addresses",
                    onTap: () {
                      _showAddressDialog(context);
                    },
                  ),
                  const Divider(height: 1, indent: 70),
                  _buildMenuItem(
                    icon: Icons.payment_outlined,
                    title: "Payment Methods",
                    subtitle: "M-Pesa & Cash on Delivery",
                    onTap: () {
                      _showPaymentMethodsDialog(context);
                    },
                  ),
                  const Divider(height: 1, indent: 70),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    subtitle: "Manage alerts",
                    onTap: () {
                      _showNotificationsDialog(context);
                    },
                  ),
                  const Divider(height: 1, indent: 70),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    subtitle: "Contact us",
                    onTap: () {
                      _showHelpDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          // Logout Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B4A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B4A).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF6B4A),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF1A1A2E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: const Color(0xFF666666),
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFFCCCCCC),
        size: 18,
      ),
    );
  }

  void _showAddressDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delivery Address",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "123 Main Street, Nairobi",
                      style: TextStyle(
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      "Phone: 0712345678",
                      style: TextStyle(
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Add New Address"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B4A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentMethodsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payment Methods",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _buildPaymentMethodTile(
                icon: Icons.phone_android,
                title: "M-Pesa",
                subtitle: "Default payment method",
                isDefault: true,
              ),
              const SizedBox(height: 12),
              _buildPaymentMethodTile(
                icon: Icons.payments_outlined,
                title: "Cash on Delivery",
                subtitle: "Pay when you receive",
                isDefault: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDefault ? const Color(0xFFFFF5F3) : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault ? const Color(0xFFFF6B4A) : const Color(0xFFE8E8E8),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFFF6B4A),
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B4A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Default",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildNotificationToggle(
                    title: "Order Updates",
                    subtitle: "Get notified about your order status",
                    value: true,
                    onChanged: (val) {},
                  ),
                  const Divider(),
                  _buildNotificationToggle(
                    title: "Promotions",
                    subtitle: "Receive offers and discounts",
                    value: true,
                    onChanged: (val) {},
                  ),
                  const Divider(),
                  _buildNotificationToggle(
                    title: "Delivery Alerts",
                    subtitle: "Know when your order arrives",
                    value: true,
                    onChanged: (val) {},
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF666666),
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFF6B4A),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Help & Support",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _buildHelpItem(
                icon: Icons.phone,
                title: "Phone Support",
                subtitle: "+254 700 123 456",
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.email,
                title: "Email",
                subtitle: "support@gasly.com",
              ),
              const SizedBox(height: 12),
              _buildHelpItem(
                icon: Icons.chat_bubble_outline,
                title: "Live Chat",
                subtitle: "Available 24/7",
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat),
                  label: const Text("Start Chat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B4A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B4A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF6B4A),
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
