import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class LeaderboardService {
  static const String baseUrl = AuthService.baseUrl;
  static const int timeoutDuration = AuthService.timeoutDuration;

  static Future<Map<String, dynamic>> getScoreLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/leaderboard'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: timeoutDuration));
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'leaderboard': data['leaderboard'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get score leaderboard',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }


  static Future<Map<String, dynamic>> getTimeLeaderboard() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/leaderboard2'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: timeoutDuration));
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'leaderboard': data['leaderboard'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get time leaderboard',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }
  static Future<Map<String, dynamic>> updateScore(double newScore) async {
    try {
      final tokens = await AuthService.getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        return {'success': false, 'message': 'No access token found'};
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/update_score'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'new_score': newScore,
        }),
      ).timeout(Duration(seconds: timeoutDuration));
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'total_score': data['total_score'],
          'message': data['message'],
        };
      } else {
        if (response.statusCode == 401) {
          final refreshed = await AuthService.refreshToken();
          if (refreshed) {
            return await updateScore(newScore);
          }
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update score',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> updateTimeSpent(int newTimeSpent) async {
    try {
      final tokens = await AuthService.getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        return {'success': false, 'message': 'No access token found'};
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/update_time_spent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'new_time_spent': newTimeSpent,
        }),
      ).timeout(Duration(seconds: timeoutDuration));
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        return {
          'success': true,
          'total_time_spent': data['total_time_spent'],
          'message': data['message'],
        };
      } else {
        if (response.statusCode == 401) {
          final refreshed = await AuthService.refreshToken();
          if (refreshed) {
            return await updateTimeSpent(newTimeSpent);
          }
        }
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update time spent',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}