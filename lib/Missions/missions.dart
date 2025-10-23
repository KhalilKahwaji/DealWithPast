import 'package:flutter/material.dart';

class MissionsPage extends StatelessWidget {
  const MissionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.emoji_events_outlined, size: 64),
          SizedBox(height: 16),
          Text('المهام قادمة قريباً',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          SizedBox(height: 8),
          Text('سنضيف نظام مهام وإنجازات لتحفيز المستخدمين.',
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
