// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import 'BadgePlaceholder.dart';

class LevelProgressionPath extends StatelessWidget {
  final Level currentLevel;
  final int currentStoryCount;

  const LevelProgressionPath({
    Key? key,
    required this.currentLevel,
    required this.currentStoryCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levels = Level.allLevels;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مسار',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
              fontFamily: 'Baloo',
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 16),
          ...levels.map((level) => _buildLevelItem(level)).toList(),
        ],
      ),
    );
  }

  Widget _buildLevelItem(Level level) {
    final isCompleted = currentStoryCount > level.maxStories;
    final isCurrent = level.level == currentLevel.level;
    final isLocked = currentStoryCount < level.minStories;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Level icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked
                  ? const Color(0xFFF3F4F6)
                  : level.color.withOpacity(0.1),
              border: Border.all(
                color: isCurrent
                    ? level.color
                    : isCompleted
                        ? const Color(0xFF10B981)
                        : const Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Color(0xFF10B981), size: 24)
                  : isLocked
                      ? const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 24)
                      : Image.asset(
                          level.iconAsset,
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return BadgePlaceholder(
                              name: level.nameAr,
                              color: level.color,
                              size: 24,
                            );
                          },
                        ),
            ),
          ),

          const SizedBox(width: 12),

          // Level info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  level.nameAr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                    color: isCurrent
                        ? const Color(0xFF1F2937)
                        : isLocked
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF4B5563),
                    fontFamily: 'Baloo',
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 2),
                Text(
                  isCompleted
                      ? 'مكتمل'
                      : isCurrent
                          ? 'المستوى الحالي'
                          : 'قصص مقبولة ${level.minStories}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Baloo',
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          // Status indicator
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: level.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'الآن',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Baloo',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
