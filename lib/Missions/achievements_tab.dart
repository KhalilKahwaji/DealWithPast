// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import '../Repos/BadgeClass.dart' as badge_class;
import '../Repos/BadgeRepo.dart';
import '../widgets/CurrentLevelCard.dart';
import '../widgets/LevelProgressionPath.dart';
import '../widgets/BadgeGrid.dart';
import '../widgets/BadgeDetailModal.dart';

class AchievementsTab extends StatefulWidget {
  final String? token;
  final int? userId;

  const AchievementsTab({
    Key? key,
    this.token,
    this.userId,
  }) : super(key: key);

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  int currentStoryCount = 0; // TODO: Fetch from user data
  late Level currentLevel;
  List<badge_class.Badge> userBadges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      // Calculate current level
      currentLevel = Level.getLevelFromStoryCount(currentStoryCount);

      // Load badges from repository
      if (widget.userId != null) {
        userBadges = await BadgeRepo().getUserBadges(widget.userId!, widget.token);
      } else {
        // If no user ID, show default badges (all locked)
        userBadges = BadgeRepo.getAllBadges();
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading achievements data: $e');
      // Show default data on error
      currentLevel = Level.followerLevel;
      userBadges = BadgeRepo.getAllBadges();
      setState(() => isLoading = false);
    }
  }

  void _showBadgeDetail(badge_class.Badge badge) {
    showDialog(
      context: context,
      builder: (context) => BadgeDetailModal(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC9A961)), // Gold color
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFFC9A961), // Gold color
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Current level card
            CurrentLevelCard(
              currentLevel: currentLevel,
              currentStoryCount: currentStoryCount,
            ),

            // Level progression path
            LevelProgressionPath(
              currentLevel: currentLevel,
              currentStoryCount: currentStoryCount,
            ),

            const SizedBox(height: 8),

            // Badges section header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'إنجازاتك',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    fontFamily: 'Baloo',
                  ),
                ),
              ),
            ),

            // Badge grid
            BadgeGrid(
              badges: userBadges,
              onBadgeTap: _showBadgeDetail,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
