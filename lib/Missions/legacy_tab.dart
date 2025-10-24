// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import '../widgets/MemorialPlaqueCard.dart';
import '../widgets/ImpactMetricsCard.dart';
import '../widgets/ShareLegacyButton.dart';

class LegacyTab extends StatefulWidget {
  final String? token;
  final int? userId;

  const LegacyTab({
    Key? key,
    this.token,
    this.userId,
  }) : super(key: key);

  @override
  State<LegacyTab> createState() => _LegacyTabState();
}

class _LegacyTabState extends State<LegacyTab> {
  // User data
  String userName = 'المستخدم'; // TODO: Fetch from user data
  String? userAvatar;
  DateTime? memberSince;

  // Story counts
  int totalStories = 0; // TODO: Fetch from API
  int storiesWithMedia = 0;

  // Mission counts
  int totalMissions = 0; // TODO: Fetch from API
  int missionsCreated = 0;
  int missionsParticipated = 0;

  // Other metrics
  int peopleInvited = 0;
  int themesExplored = 0;

  // Level data
  late Level currentLevel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    try {
      // Calculate current level based on story count
      currentLevel = Level.getLevelFromStoryCount(totalStories);

      // TODO: Implement API calls to fetch user legacy data
      // Example endpoints needed:
      // - GET /wp-json/dwp/v1/users/{userId}/legacy
      // Should return:
      // {
      //   "user_name": "...",
      //   "user_avatar": "...",
      //   "member_since": "...",
      //   "stories": {
      //     "total": 0,
      //     "with_media": 0
      //   },
      //   "missions": {
      //     "total": 0,
      //     "created": 0,
      //     "participated": 0
      //   },
      //   "community": {
      //     "people_invited": 0,
      //     "themes_explored": 0
      //   }
      // }

      if (widget.userId != null && widget.token != null) {
        // Future API implementation here
        // final response = await http.get(
        //   Uri.parse('$baseUrl/wp-json/dwp/v1/users/${widget.userId}/legacy'),
        //   headers: {'Authorization': 'Bearer ${widget.token}'},
        // );
        // Parse and set data
      }

      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading legacy data: $e');
      // Show default data on error
      currentLevel = Level.followerLevel;
      setState(() => isLoading = false);
    }
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
            const SizedBox(height: 8),

            // Memorial plaque card
            MemorialPlaqueCard(
              userName: userName,
              userAvatar: userAvatar,
              currentLevel: currentLevel,
              totalStories: totalStories,
              totalMissions: totalMissions,
              memberSince: memberSince,
            ),

            // Impact metrics
            ImpactMetricsCard(
              storiesContributed: totalStories,
              missionsCreated: missionsCreated,
              missionsParticipated: missionsParticipated,
              storiesWithMedia: storiesWithMedia,
              peopleInvited: peopleInvited,
              themesExplored: themesExplored,
            ),

            // Share button
            ShareLegacyButton(
              userName: userName,
              totalStories: totalStories,
              totalMissions: totalMissions,
              levelName: currentLevel.nameAr,
            ),

            const SizedBox(height: 16),

            // Legacy message
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Color(0xFFE57373),
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'كل مساهمة تحفظ جزءاً من ذاكرتنا',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontFamily: 'Baloo',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'إرثك هو شهادتك على التاريخ، ومساهمتك في بناء مستقبل يتعلم من الماضي.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Baloo',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
