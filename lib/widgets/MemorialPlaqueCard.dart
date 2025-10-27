// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import 'BadgePlaceholder.dart';

class MemorialPlaqueCard extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final Level currentLevel;
  final int totalStories;
  final int totalMissions;
  final DateTime? memberSince;

  const MemorialPlaqueCard({
    Key? key,
    required this.userName,
    this.userAvatar,
    required this.currentLevel,
    required this.totalStories,
    required this.totalMissions,
    this.memberSince,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1F2937),
            const Color(0xFF374151),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          const Text(
            'لوحة الإرث',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD4AF37), // Gold
              fontFamily: 'Baloo',
            ),
          ),

          const SizedBox(height: 20),

          // User avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: currentLevel.color,
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: userAvatar != null
                  ? Image.network(
                      userAvatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // User name
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Baloo',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Level badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: currentLevel.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  currentLevel.iconAsset,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return BadgePlaceholder(
                      name: currentLevel.nameAr,
                      color: Colors.white,
                      size: 20,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  currentLevel.nameAr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Baloo',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Divider
          Container(
            height: 1,
            color: Colors.white24,
          ),

          const SizedBox(height: 24),

          // Legacy message
          const Text(
            'شكراً لمساهمتك في حفظ الذاكرة اللبنانية',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'Baloo',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.history_edu,
                value: totalStories.toString(),
                label: 'قصة',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white24,
              ),
              _buildStatItem(
                icon: Icons.explore,
                value: totalMissions.toString(),
                label: 'مهمة',
              ),
            ],
          ),

          if (memberSince != null) ...[
            const SizedBox(height: 20),
            Text(
              'عضو منذ ${_formatDate(memberSince!)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white60,
                fontFamily: 'Baloo',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFFD4AF37), // Gold
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Baloo',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontFamily: 'Baloo',
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
