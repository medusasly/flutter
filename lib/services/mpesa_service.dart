import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MpesaService {
  // Load credentials from environment variables
  static String get consumerKey => dotenv.env['MPESA_CONSUMER_KEY'] ?? '';
  static String get consumerSecret => dotenv.env['MPESA_CONSUMER_SECRET'] ?? '';
  static String get shortCode => dotenv.env['MPESA_SHORTCODE'] ?? '174379';
  static String get passkey => dotenv.env['MPESA_PASSKEY'] ?? '';
  static String get environment => dotenv.env['MPESA_ENV'] ?? 'sandbox';
  
  // URLs
  static const String baseUrl = 'https://sandbox.safaricom.co.ke';
  static const String authUrl = '$baseUrl/oauth/v1/generate?grant_type=client_credentials';
  static const String stkPushUrl = '$baseUrl/mpesa/stkpush/v1/processrequest';

  /// Get OAuth access token
  static Future<String?> _getAccessToken() async {
    try {
      // Debug logging
      print('MPESA_DEBUG: Loading credentials from .env');
      print('MPESA_DEBUG: Consumer Key length: ${consumerKey.length}');
      print('MPESA_DEBUG: Consumer Secret length: ${consumerSecret.length}');
      print('MPESA_DEBUG: Environment: $environment');

      if (consumerKey.isEmpty || consumerSecret.isEmpty) {
        print('MPESA_ERROR: Consumer Key or Secret is empty');
        return null;
      }

      final credentials = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
      
      print('MPESA_DEBUG: Making auth request to $authUrl');
      
      final response = await http.get(
        Uri.parse(authUrl),
        headers: {
          'Authorization': 'Basic $credentials',
        },
      );

      print('MPESA_DEBUG: Auth response status: ${response.statusCode}');
      print('MPESA_DEBUG: Auth response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('MPESA_ERROR: Auth failed - ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('MPESA_ERROR: Auth Exception: $e');
      print('MPESA_ERROR: Stack trace: $stackTrace');
      return null;
    }
  }

  /// Generate password for STK push
  static String _generatePassword(String timestamp) {
    final data = base64Encode(utf8.encode('$shortCode$passkey$timestamp'));
    return data;
  }

  /// Get current timestamp in required format (yyyyMMddHHmmss)
  static String _getTimestamp() {
    final now = DateTime.now();
    return DateFormat('yyyyMMddHHmmss').format(now);
  }

  /// Format phone number to required format (2547XXXXXXXX)
  static String _formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    
    // If starts with 0, replace with 254
    if (cleaned.startsWith('0')) {
      cleaned = '254${cleaned.substring(1)}';
    }
    
    // If starts with +, remove it
    if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    }
    
    // If doesn't start with 254, add it
    if (!cleaned.startsWith('254')) {
      cleaned = '254$cleaned';
    }
    
    return cleaned;
  }

  /// Check if credentials are configured
  static bool get areCredentialsConfigured {
    return consumerKey.isNotEmpty &&
           consumerKey != 'YOUR_CONSUMER_KEY' &&
           consumerSecret.isNotEmpty &&
           consumerSecret != 'YOUR_CONSUMER_SECRET' &&
           passkey.isNotEmpty &&
           passkey != 'YOUR_PASSKEY';
  }

  /// Check if running on web (where CORS may block API calls)
  static bool get isWeb => kIsWeb;

  /// Initiate STK Push
  static Future<Map<String, dynamic>> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required String accountReference,
    String transactionDesc = 'Gas Order Payment',
  }) async {
    // Validate credentials are configured
    if (!areCredentialsConfigured) {
      // If on web and no credentials, use mock mode for testing
      if (isWeb) {
        print('MPESA_INFO: No credentials found, using MOCK mode for web testing');
        return _mockStkPush(phoneNumber, amount);
      }
      return {
        'success': false,
        'message': 'M-Pesa credentials not configured. Please check your .env file.',
      };
    }

    try {
      final accessToken = await _getAccessToken();
      
      if (accessToken == null) {
        // If on web and token failed, likely CORS issue - use mock mode
        if (isWeb) {
          print('MPESA_INFO: Access token failed on web, using MOCK mode');
          return _mockStkPush(phoneNumber, amount);
        }
        return {
          'success': false,
          'message': 'Failed to get access token. Check your Consumer Key and Secret.',
        };
      }

      final timestamp = _getTimestamp();
      final password = _generatePassword(timestamp);
      final formattedPhone = _formatPhoneNumber(phoneNumber);

      print('MPESA_DEBUG: Passkey length: ${passkey.length}');
      print('MPESA_DEBUG: Shortcode: $shortCode');
      print('MPESA_DEBUG: Timestamp: $timestamp');
      print('MPESA_DEBUG: Formatted Phone: $formattedPhone');
      print('MPESA_DEBUG: Amount: ${amount.ceil()}');
      print('MPESA_DEBUG: Access Token (first 20 chars): ${accessToken.substring(0, 20)}...');

      final requestBody = {
        'BusinessShortCode': shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount.ceil(), // M-Pesa requires whole numbers
        'PartyA': formattedPhone,
        'PartyB': shortCode,
        'PhoneNumber': formattedPhone,
        'CallBackURL': 'https://postman-echo.com/post', // Sandbox callback URL (replace with your actual callback)
        'AccountReference': accountReference,
        'TransactionDesc': transactionDesc,
      };

      print('MPESA_DEBUG: Request Body: $requestBody');

      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      print('MPESA_DEBUG: Request Headers: $headers');
      print('MPESA_DEBUG: Full URL: $stkPushUrl');

      final response = await http.post(
        Uri.parse(stkPushUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      print('MPESA_DEBUG: STK Push Response Status: ${response.statusCode}');
      print('MPESA_DEBUG: STK Push Response Body: ${response.body}');
      print('MPESA_DEBUG: Response Headers: ${response.headers}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['ResponseCode'] == '0') {
          return {
            'success': true,
            'message': 'STK push initiated successfully',
            'checkoutRequestId': responseData['CheckoutRequestID'],
            'merchantRequestId': responseData['MerchantRequestID'],
            'customerMessage': responseData['CustomerMessage'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['ResponseDescription'] ?? 'STK push failed',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'HTTP Error ${response.statusCode}: ${responseData['errorMessage'] ?? response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }

  /// Query STK Push status
  static Future<Map<String, dynamic>> queryStkPushStatus(String checkoutRequestId) async {
    try {
      final accessToken = await _getAccessToken();
      
      if (accessToken == null) {
        return {
          'success': false,
          'message': 'Failed to get access token',
        };
      }

      final timestamp = _getTimestamp();
      final password = _generatePassword(timestamp);

      final requestBody = {
        'BusinessShortCode': shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': checkoutRequestId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/stkpushquery/v1/query'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['errorMessage'] ?? 'Query failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Exception: $e',
      };
    }
  }

  /// Mock STK Push for web testing (CORS workaround)
  static Future<Map<String, dynamic>> _mockStkPush(String phoneNumber, double amount) async {
    print('MPESA_MOCK: Simulating STK push for $phoneNumber, amount: $amount');
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    return {
      'success': true,
      'message': 'STK push initiated successfully (MOCK MODE)',
      'checkoutRequestId': 'ws_CO_MOCK_${DateTime.now().millisecondsSinceEpoch}',
      'merchantRequestId': 'MOCK_${DateTime.now().millisecondsSinceEpoch}',
      'customerMessage': 'Check your phone for M-Pesa prompt (MOCK: No actual SMS sent)',
    };
  }
}
