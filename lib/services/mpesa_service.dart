import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MpesaService {
  // Sandbox credentials - Replace with your actual credentials
  static const String consumerKey = 'YOUR_CONSUMER_KEY';
  static const String consumerSecret = 'YOUR_CONSUMER_SECRET';
  static const String shortCode = '174379'; // Test shortcode for sandbox
  static const String passkey = 'YOUR_PASSKEY';
  
  // URLs
  static const String baseUrl = 'https://sandbox.safaricom.co.ke';
  static const String authUrl = '$baseUrl/oauth/v1/generate?grant_type=client_credentials';
  static const String stkPushUrl = '$baseUrl/mpesa/stkpush/v1/processrequest';

  /// Get OAuth access token
  static Future<String?> _getAccessToken() async {
    try {
      final credentials = base64Encode(utf8.encode('$consumerKey:$consumerSecret'));
      
      final response = await http.get(
        Uri.parse(authUrl),
        headers: {
          'Authorization': 'Basic $credentials',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        print('Auth Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Auth Exception: $e');
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

  /// Initiate STK Push
  static Future<Map<String, dynamic>> initiateStkPush({
    required String phoneNumber,
    required double amount,
    required String accountReference,
    String transactionDesc = 'Gas Order Payment',
  }) async {
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
      final formattedPhone = _formatPhoneNumber(phoneNumber);

      final requestBody = {
        'BusinessShortCode': shortCode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount.ceil(), // M-Pesa requires whole numbers
        'PartyA': formattedPhone,
        'PartyB': shortCode,
        'PhoneNumber': formattedPhone,
        'CallBackURL': 'https://your-callback-url.com/mpesa/callback', // Replace with your callback URL
        'AccountReference': accountReference,
        'TransactionDesc': transactionDesc,
      };

      final response = await http.post(
        Uri.parse(stkPushUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

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
}
