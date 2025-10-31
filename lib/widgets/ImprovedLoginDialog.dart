// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../Backend/Login.dart';

class ImprovedLoginDialog extends StatelessWidget {
  final String actionText; // e.g., "إضافة قصة", "إنشاء مهمة", "الانضمام إلى المهمة"

  const ImprovedLoginDialog({
    Key? key,
    required this.actionText,
  }) : super(key: key);

  static Future<bool?> show(BuildContext context, {required String actionText}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ImprovedLoginDialog(actionText: actionText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4A7C59).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_person,
                size: 40,
                color: Color(0xFF4A7C59),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'سجل دخولك لتبدأ المساهمة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: Color(0xFF3A3534),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Benefits list
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBenefit('احفظ ذكرياتك وقصصك', Icons.auto_stories),
                  const SizedBox(height: 12),
                  _buildBenefit('شارك في المهام الجماعية', Icons.people),
                  const SizedBox(height: 12),
                  _buildBenefit('اربح نقاط وشارات', Icons.emoji_events),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Login button (styled like Google button)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true); // Return true to navigate to login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF3A3534),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
                icon: Image.asset(
                  'assets/google_logo.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image doesn't exist
                    return const Icon(Icons.login, size: 20);
                  },
                ),
                label: const Text(
                  'تسجيل الدخول بـ Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Continue as guest button
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Return false to continue as guest
              },
              child: const Text(
                'أكمل كضيف',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF6B7280),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Tajawal',
              color: Color(0xFF3A3534),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF4A7C59).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: const Color(0xFF4A7C59),
          ),
        ),
      ],
    );
  }
}
