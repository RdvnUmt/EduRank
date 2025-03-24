import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edu_rank/data/quizzes_data.dart' as quiz_data;

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

  // Yeni bir kullanıcı giriş yaptığında quiz verilerini sıfırlayan metod
  static void _resetUserQuizData() {
    try {
      // Kullanıcı değiştiğinde global verileri sıfırla
      quiz_data.totalScore = 0;
      quiz_data.totalTime = 0;
      
      // Eğer quiz listesi varsa, içindeki quiz'lerin skorlarını sıfırla
      if (quiz_data.quizzes.isNotEmpty) {
        for (var quiz in quiz_data.quizzes) {
          quiz.score = 0;
          quiz.lastTime = 0;
          quiz.bestTime = '0:00';
        }
      }
      
      print('Quiz data reset for new user login');
      print('New total score: ${quiz_data.totalScore}, new total time: ${quiz_data.totalTime}');
    } catch (e) {
      print('Error resetting quiz data: $e');
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
      
      _resetUserQuizData();
      
      return response.statusCode == 200;
    } catch (e) {
      await removeTokens();
      
      _resetUserQuizData();
      
      return false;
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final tokens = await getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        print('No access token found');
        return {'success': false, 'message': 'No access token found'};
      }
      
      print('Sending profile request to: $baseUrl/profile');
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      
      print('Profile response status code: ${response.statusCode}');
      print('Profile response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        print('Profile data successful: ${data['total_score']}, ${data['total_time_spent']}');
        return {
          'success': true,
          'username': data['username'],
          'email': data['email'],
          'total_score': data['total_score'],
          'total_time_spent': data['total_time_spent'],
        };
      } else {
        if (response.statusCode == 401) {
          print('Unauthorized access, attempting to refresh token');
          final refreshed = await refreshToken();
          if (refreshed) {
            print('Token refreshed, retrying profile request');
            return await getProfile();
          }
        }        
        print('Failed to get profile: ${data['message']}');
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      print('Error getting profile: $e');
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