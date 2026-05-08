import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables with fallback for different platforms
  try {
    // Try loading from root (works on web/desktop)
    await dotenv.load(fileName: ".env");
    print('ENV_LOADED: .env loaded from root');
  } catch (e) {
    try {
      // Try loading from assets (works on mobile devices)
      await dotenv.load(fileName: "assets/.env");
      print('ENV_LOADED: .env loaded from assets');
    } catch (e) {
      print('ENV_ERROR: Failed to load .env file: $e');
      print('ENV_ERROR: M-Pesa credentials will not be available');
    }
  }
  
  // Debug: Print loaded values (masked for security)
  final key = dotenv.env['MPESA_CONSUMER_KEY'] ?? '';
  print('ENV_DEBUG: Consumer Key loaded: ${key.isNotEmpty ? "Yes (length: ${key.length})" : "No"}');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Gas-Ly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    
    if (auth.isAuthenticated) {
      return const MainScreen();
    }
    return const AuthScreen();
  }
}
