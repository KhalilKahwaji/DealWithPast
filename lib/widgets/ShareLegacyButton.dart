// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareLegacyButton extends StatelessWidget {
  final String userName;
  final int totalStories;
  final int totalMissions;
  final String levelName;

  const ShareLegacyButton({
    Key? key,
    required this.userName,
    required this.totalStories,
    required this.totalMissions,
    required this.levelName,
  }) : super(key: key);

  void _shareLegacy(BuildContext context) {
    final message = '''
🏛️ إرثي في "التعامل مع الماضي"

أنا $userName - $levelName
🎖️ $totalStories قصة ساهمت بها
🗺️ $totalMissions مهمة شاركت فيها

أحفظ الذاكرة اللبنانية معنا!
انضم إلى مشروع "التعامل مع الماضي"

#التعامل_مع_الماضي #لبنان #الذاكرة
''';

    Share.share(
      message,
      subject: 'إرثي في مشروع التعامل مع الماضي',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () => _shareLegacy(context),
        icon: const Icon(
          Icons.share,
          size: 20,
        ),
        label: const Text(
          'شارك إرثك',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Baloo',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A7C59),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
