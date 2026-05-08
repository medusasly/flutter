import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true;
  bool _isLoading = false;
  String? _errorMessage;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = context.read<AuthProvider>();
    bool success;

    if (_isSignIn) {
      success = await auth.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Passwords do not match';
        });
        return;
      }
      success = await auth.signUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _passwordController.text,
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      setState(() => _errorMessage = _isSignIn 
        ? 'Invalid email or password' 
        : 'Email already registered');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Logo
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B4A).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFF6B4A),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Gas-Ly",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Welcome text
              Text(
                _isSignIn ? "Welcome back" : "Create account",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3436),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignIn 
                  ? "Sign in to order gas quickly" 
                  : "Join us for fast gas delivery",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF2D3436).withOpacity(0.6),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Form fields
              if (!_isSignIn) ...[
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone Number",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
              ],
              
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              
              if (!_isSignIn) ...[
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
              ],
              
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B4A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFFFF6B4A),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFFF6B4A),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B4A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isSignIn ? "Sign In" : "Create Account",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignIn ? "Don't have an account? " : "Already have an account? ",
                    style: TextStyle(
                      color: const Color(0xFF2D3436).withOpacity(0.6),
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _isSignIn = !_isSignIn;
                      _errorMessage = null;
                    }),
                    child: Text(
                      _isSignIn ? "Sign Up" : "Sign In",
                      style: const TextStyle(
                        color: Color(0xFFFF6B4A),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              if (_isSignIn) ...[
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "Demo: demo@gasly.com / password123",
                    style: TextStyle(
                      color: const Color(0xFF2D3436).withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8E4E0),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: const Color(0xFF2D3436).withOpacity(0.5),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF2D3436).withOpacity(0.4),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
