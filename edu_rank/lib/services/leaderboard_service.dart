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
      print('Updating score: $newScore');
      final tokens = await AuthService.getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        print('No access token found for score update');
        return {'success': false, 'message': 'No access token found'};
      }
      
      print('Sending score update request to: $baseUrl/update_score');
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
      
      print('Score update response status code: ${response.statusCode}');
      print('Score update response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        print('Score updated successfully: ${data['total_score']}');
        return {
          'success': true,
          'total_score': data['total_score'],
          'message': data['message'],
        };
      } else {
        if (response.statusCode == 401) {
          print('Unauthorized access, attempting to refresh token for score update');
          final refreshed = await AuthService.refreshToken();
          if (refreshed) {
            print('Token refreshed, retrying score update');
            return await updateScore(newScore);
          }
        }
        print('Failed to update score: ${data['message']}');
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update score',
        };
      }
    } catch (e) {
      print('Error updating score: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> updateTimeSpent(int newTimeSpent) async {
    try {
      print('Updating time spent: $newTimeSpent');
      final tokens = await AuthService.getTokens();
      final accessToken = tokens['access_token'];
      
      if (accessToken == null) {
        print('No access token found for time update');
        return {'success': false, 'message': 'No access token found'};
      }
      
      print('Sending time update request to: $baseUrl/update_time_spent');
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
      
      print('Time update response status code: ${response.statusCode}');
      print('Time update response body: ${response.body}');
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['status'] == 'success') {
        print('Time spent updated successfully: ${data['total_time_spent']}');
        return {
          'success': true,
          'total_time_spent': data['total_time_spent'],
          'message': data['message'],
        };
      } else {
        if (response.statusCode == 401) {
          print('Unauthorized access, attempting to refresh token for time update');
          final refreshed = await AuthService.refreshToken();
          if (refreshed) {
            print('Token refreshed, retrying time update');
            return await updateTimeSpent(newTimeSpent);
          }
        }
        print('Failed to update time spent: ${data['message']}');
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update time spent',
        };
      }
    } catch (e) {
      print('Error updating time spent: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}