// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../services/NotificationService.dart';
import 'NotificationListPage.dart';

class NotificationBellIcon extends StatefulWidget {
  const NotificationBellIcon({Key? key}) : super(key: key);

  @override
  _NotificationBellIconState createState() => _NotificationBellIconState();
}

class _NotificationBellIconState extends State<NotificationBellIcon> {
  final NotificationService _notificationService = NotificationService();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();

    // Listen to unread count stream
    _notificationService.unreadCountStream.listen((count) {
      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    });

    // Initialize with cached value
    _unreadCount = _notificationService.currentUnreadCount;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationListPage(),
              ),
            );
          },
          tooltip: 'الإشعارات',
        ),
        // Badge showing unread count
        if (_unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                _unreadCount > 99 ? '99+' : '$_unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
