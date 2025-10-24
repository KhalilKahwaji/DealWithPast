// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import 'BadgePlaceholder.dart';

class CurrentLevelCard extends StatelessWidget {
  final Level currentLevel;
  final int currentStoryCount;

  const CurrentLevelCard({
    Key? key,
    required this.currentLevel,
    required this.currentStoryCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nextLevel = currentLevel.nextLevel;
    final isMaxLevel = nextLevel == null;

    // Calculate progress to next level
    final storiesInCurrentLevel = currentStoryCount - currentLevel.minStories;
    final storiesRequiredForLevel = currentLevel.maxStories - currentLevel.minStories + 1;
    final progressPercentage = (storiesInCurrentLevel / storiesRequiredForLevel).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            currentLevel.color,
            currentLevel.color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Level icon
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                currentLevel.iconAsset,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return BadgePlaceholder(
                    name: currentLevel.nameAr,
                    color: currentLevel.color,
                    size: 40,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Level name
          Text(
            currentLevel.nameAr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Baloo',
            ),
          ),

          const SizedBox(height: 8),

          // Progress text
          if (!isMaxLevel) ...[
            const Text(
              'التقدم في المستوى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$currentStoryCount/${currentLevel.maxStories + 1} قصة',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Baloo',
              ),
            ),
            const SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ] else ...[
            const Text(
              'المستوى الأقصى!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Baloo',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
