// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../services/NotificationService.dart';
import '../Repos/NotificationClass.dart';
import 'RejectionDialog.dart';
import 'package:timeago/timeago.dart' as timeago;

// Arabic locale for timeago
class ArMessages implements timeago.LookupMessages {
  @override String prefixAgo() => '';
  @override String prefixFromNow() => '';
  @override String suffixAgo() => '';
  @override String suffixFromNow() => 'من الآن';
  @override String lessThanOneMinute(int seconds) => 'منذ لحظات';
  @override String aboutAMinute(int minutes) => 'منذ دقيقة';
  @override String minutes(int minutes) => 'منذ $minutes دقيقة';
  @override String aboutAnHour(int minutes) => 'منذ ساعة';
  @override String hours(int hours) => 'منذ $hours ساعة';
  @override String aDay(int hours) => 'منذ يوم';
  @override String days(int days) => 'منذ $days يوم';
  @override String aboutAMonth(int days) => 'منذ شهر';
  @override String months(int months) => 'منذ $months شهر';
  @override String aboutAYear(int year) => 'منذ سنة';
  @override String years(int years) => 'منذ $years سنة';
  @override String wordSeparator() => ' ';
}

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  final NotificationService _notificationService = NotificationService();
  List<DWPNotification> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Register Arabic locale for timeago
    timeago.setLocaleMessages('ar', ArMessages());

    // Listen to notifications stream
    _notificationService.notificationsStream.listen((notifications) {
      if (mounted) {
        setState(() {
          _notifications = notifications;
        });
      }
    });

    // Initialize with cached value
    _notifications = _notificationService.currentNotifications;

    // Refresh on page load
    _refreshNotifications();
  }

  Future<void> _refreshNotifications() async {
    setState(() => _isLoading = true);
    await _notificationService.refresh();
    setState(() => _isLoading = false);
  }

  void _handleNotificationTap(DWPNotification notification) async {
    // Mark as read if unread
    if (!notification.isRead) {
      await _notificationService.markAsRead(notification.id);
    }

    // Handle different notification types
    if (notification.isMissionRejected) {
      // Show rejection dialog
      if (!mounted) return;
      RejectionDialog.show(
        context: context,
        missionTitle: notification.data?['mission_title'] ?? 'مهمة',
        rejectionReason: notification.rejectionReason ?? 'لم يتم توفير سبب',
        missionId: notification.missionId,
      );
    } else if (notification.isMissionApproved) {
      // Could navigate to mission detail or show success dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('مهمتك "${notification.data?['mission_title']}" تمت الموافقة عليها!'),
          backgroundColor: const Color(0xFF5A7C59),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        backgroundColor: const Color(0xFFF5F0E8),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () async {
                await _notificationService.markAllAsRead();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم وضع علامة مقروء على جميع الإشعارات'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text(
                'قراءة الكل',
                style: TextStyle(
                  color: Color(0xFF5A7C59),
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5A7C59)))
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              color: const Color(0xFF5A7C59),
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(_notifications[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3A3534),
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'سيتم عرض إشعاراتك هنا',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(DWPNotification notification) {
    IconData icon;
    Color iconColor;

    // Determine icon based on notification type
    if (notification.isMissionApproved) {
      icon = Icons.check_circle;
      iconColor = const Color(0xFF5A7C59);
    } else if (notification.isMissionRejected) {
      icon = Icons.cancel;
      iconColor = const Color(0xFF8B4555);
    } else if (notification.isAchievementUnlocked) {
      icon = Icons.emoji_events;
      iconColor = const Color(0xFFD4AF37);
    } else {
      icon = Icons.info;
      iconColor = const Color(0xFF5A7C59);
    }

    return GestureDetector(
      onTap: () => _handleNotificationTap(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? const Color(0x1A3A3534)
                : const Color(0xFFD4AF37),
            width: notification.isRead ? 0.7 : 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: const Color(0xFF3A3534),
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Tajawal',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeago.format(notification.sentAt, locale: 'ar'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
