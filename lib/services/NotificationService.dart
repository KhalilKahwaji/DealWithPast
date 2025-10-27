// ignore_for_file: file_names, avoid_print

import 'dart:async';
import '../Repos/NotificationRepo.dart';
import '../Repos/NotificationClass.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final NotificationRepo _repo = NotificationRepo();
  Timer? _pollingTimer;
  String? _token;

  // Streams for reactive updates
  final _unreadCountController = StreamController<int>.broadcast();
  final _notificationsController = StreamController<List<DWPNotification>>.broadcast();

  Stream<int> get unreadCountStream => _unreadCountController.stream;
  Stream<List<DWPNotification>> get notificationsStream => _notificationsController.stream;

  int _cachedUnreadCount = 0;
  List<DWPNotification> _cachedNotifications = [];

  int get currentUnreadCount => _cachedUnreadCount;
  List<DWPNotification> get currentNotifications => _cachedNotifications;

  /// Start polling for notifications
  /// [token] - JWT authentication token
  /// [intervalSeconds] - Polling interval (default 60 seconds)
  void startPolling({required String token, int intervalSeconds = 60}) {
    _token = token;

    // Fetch immediately
    _fetchNotifications();

    // Then poll at intervals
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      Duration(seconds: intervalSeconds),
      (_) => _fetchNotifications(),
    );

    print('NotificationService: Polling started (every ${intervalSeconds}s)');
  }

  /// Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    print('NotificationService: Polling stopped');
  }

  /// Manually fetch notifications (useful for pull-to-refresh)
  Future<void> refresh() async {
    if (_token != null) {
      await _fetchNotifications();
    }
  }

  /// Internal method to fetch notifications and update streams
  Future<void> _fetchNotifications() async {
    if (_token == null) return;

    try {
      // Fetch unread count
      final unreadCount = await _repo.getUnreadCount(token: _token!);
      if (unreadCount != _cachedUnreadCount) {
        _cachedUnreadCount = unreadCount;
        _unreadCountController.add(unreadCount);
      }

      // Fetch recent notifications (last 20)
      final notifications = await _repo.getNotifications(
        token: _token!,
        unreadOnly: false,
        limit: 20,
      );

      _cachedNotifications = notifications;
      _notificationsController.add(notifications);
    } catch (e) {
      print('NotificationService: Error fetching notifications - $e');
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    if (_token == null) return false;

    final success = await _repo.markAsRead(
      token: _token!,
      notificationId: notificationId,
    );

    if (success) {
      // Update cached data
      _cachedUnreadCount = (_cachedUnreadCount - 1).clamp(0, 999);
      _unreadCountController.add(_cachedUnreadCount);

      // Update notification in cache
      final index = _cachedNotifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        // Create a new list with updated notification
        final updatedNotifications = List<DWPNotification>.from(_cachedNotifications);
        final oldNotification = updatedNotifications[index];
        updatedNotifications[index] = DWPNotification(
          id: oldNotification.id,
          userId: oldNotification.userId,
          type: oldNotification.type,
          title: oldNotification.title,
          body: oldNotification.body,
          data: oldNotification.data,
          isRead: true,
          sentAt: oldNotification.sentAt,
        );
        _cachedNotifications = updatedNotifications;
        _notificationsController.add(_cachedNotifications);
      }
    }

    return success;
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    if (_token == null) return false;

    final success = await _repo.markAllAsRead(token: _token!);

    if (success) {
      _cachedUnreadCount = 0;
      _unreadCountController.add(0);

      // Refresh notifications to get updated read status
      await _fetchNotifications();
    }

    return success;
  }

  /// Dispose streams (call when app is closing)
  void dispose() {
    stopPolling();
    _unreadCountController.close();
    _notificationsController.close();
  }
}
