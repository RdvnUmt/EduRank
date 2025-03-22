import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/*
 * Kullanıcı kimlik doğrulama, giriş, kayıt ve token yönetimi işlemlerini gerçekleştiren servis.
 * Bu sınıf, backend API'si ile bağlantı kuruyor. Test ederken hem flask run ediyoruz hem de flutterı.
 * Metotlardaki isimleri flask ile aynı ayarlamak gerekiyormuş yoksa eşleşmediği için çalışmıyormuş.
 */
class AuthService {
  // Emülatör için 10.0.2.2:5000, gerçek cihaz için IP adresini kullanıyormuşuz.
  static const String baseUrl = 'http://10.0.2.2:5000'; 
  // static const String baseUrl = 'http://192.168.1.2:5000';
  
  // HTTP isteklerinin zaman aşımı süresi. Bu süre içinde yanıt alınmazsa istek başarısız olur.
  static const int timeoutDuration = 30;

  /*
   * Tokenlar cihaz hafızasına kaydediliyormuş.
   * Login yaparken başarılı kimlik doğrulama sonrası çağrılır.
   * Token demek kullanıcının belli süre boyunca uygulamayı kullanabilmesi için verilen bir şey.
   */
  static Future<void> storeTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  static Future<Map<String, String?>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'access_token': prefs.getString('access_token'),
      'refresh_token': prefs.getString('refresh_token'),
    };
  }

  // Kullanıcı çıkış yaptığında token'ları siler.
  static Future<void> removeTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  static Future<bool> refreshToken() async {
    try {
      final tokens = await getTokens();
      final refreshToken = tokens['refresh_token'];
      
      if (refreshToken == null) {
        return false;
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        await storeTokens(data['access_token'], refreshToken);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    try {
      print('Sending register request to: $baseUrl/register');
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      ).timeout(Duration(seconds: timeoutDuration));

      print('Register response status code: ${response.statusCode}');
      print('Register response body: ${response.body}');

      final data = jsonDecode(response.body);
      return {
        'success': data['status'] == 'success',
        'message': data['message'] ?? (data['status'] == 'success' ? 'Registration successful' : 'Registration failed'),
        'data': data['data'],
      };
    } catch (e) {
      print('Register error: $e');
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      print('Sending login request to: $baseUrl/login');
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier, 
          'password': password,
        }),
      ).timeout(Duration(seconds: timeoutDuration));

      print('Login response status code: ${response.statusCode}');
      print('Login response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        await storeTokens(data['access_token'], data['refresh_token']);
        return {
          'success': true,
          'message': 'Login successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  static Future<bool> logout() async {
    try {
      final tokens = await getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        return false;
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      
      await removeTokens();
      
      return response.statusCode == 200;
    } catch (e) {
      await removeTokens();
      return false;
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final tokens = await getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        return {'success': false, 'message': 'No access token found'};
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'username': data['username'],
          'email': data['email'],
        };
      } else {
        if (response.statusCode == 401) {
          final refreshed = await refreshToken();
          if (refreshed) {
            return await getProfile();
          }
        }        
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<bool> isLoggedIn() async {
    final tokens = await getTokens();
    return tokens['access_token'] != null;
  }
}