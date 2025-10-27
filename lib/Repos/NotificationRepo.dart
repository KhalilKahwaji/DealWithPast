// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'NotificationClass.dart';

class NotificationRepo {
  final String baseUrl = 'https://dwp.world/wp-json/dwp/v1';

  /// Get user notifications
  /// [token] - JWT authentication token
  /// [unreadOnly] - If true, only return unread notifications
  /// [limit] - Maximum number of notifications to return (default 50)
  Future<List<DWPNotification>> getNotifications({
    required String token,
    bool unreadOnly = false,
    int limit = 50,
  }) async {
    try {
      final url = '$baseUrl/notifications?unread_only=$unreadOnly&limit=$limit';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['notifications'] != null) {
          final notifications = (data['notifications'] as List)
              .map((json) => DWPNotification.fromJson(json))
              .toList();
          return notifications;
        }
      }

      print('Failed to load notifications: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Error loading notifications: $e');
      return [];
    }
  }

  /// Get count of unread notifications
  Future<int> getUnreadCount({required String token}) async {
    try {
      final url = '$baseUrl/notifications/unread-count';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      }

      return 0;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  /// Mark single notification as read
  Future<bool> markAsRead({
    required String token,
    required int notificationId,
  }) async {
    try {
      final url = '$baseUrl/notifications/$notificationId/read';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead({required String token}) async {
    try {
      final url = '$baseUrl/notifications/read-all';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error marking all as read: $e');
      return false;
    }
  }
}
