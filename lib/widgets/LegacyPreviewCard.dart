// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import 'BadgePlaceholder.dart';

class LegacyPreviewCard extends StatelessWidget {
  final Level currentLevel;
  final int totalStories;
  final int totalMissions;
  final VoidCallback onTap;

  const LegacyPreviewCard({
    Key? key,
    required this.currentLevel,
    required this.totalStories,
    required this.totalMissions,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1F2937),
              const Color(0xFF374151),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View details button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'عرض التفاصيل',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'Baloo',
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Title
                const Text(
                  'لوحة الإرث',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD4AF37), // Gold
                    fontFamily: 'Baloo',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

            const SizedBox(height: 16),

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
                  height: 30,
                  color: Colors.white24,
                ),
                _buildStatItem(
                  icon: Icons.explore,
                  value: totalMissions.toString(),
                  label: 'مهمة',
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Legacy message
            Text(
              'شكراً لمساهمتك في حفظ الذاكرة اللبنانية',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
                fontFamily: 'Baloo',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Baloo',
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
            fontFamily: 'Baloo',
          ),
        ),
      ],
    );
  }
}
