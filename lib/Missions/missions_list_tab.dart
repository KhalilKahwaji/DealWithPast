// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/MissionRepo.dart';

class MissionsListTab extends StatefulWidget {
  final String? token;
  final int? userId;

  const MissionsListTab({
    Key? key,
    this.token,
    this.userId,
  }) : super(key: key);

  @override
  State<MissionsListTab> createState() => _MissionsListTabState();
}

class _MissionsListTabState extends State<MissionsListTab> {
  List<Map<String, dynamic>> missions = [];
  bool isLoading = true;
  final MissionRepo _missionRepo = MissionRepo();

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    setState(() => isLoading = true);

    try {
      // TODO: Fetch missions from API
      // For now, showing placeholder
      // Future implementation could fetch:
      // - Nearby missions
      // - User's participated missions
      // - Featured missions

      // Example API call:
      // missions = await _missionRepo.getNearbyMissions(
      //   latitude: userLatitude,
      //   longitude: userLongitude,
      //   radius: 50000,
      // );

      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading missions: $e');
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

    if (missions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadMissions,
      color: const Color(0xFFC9A961), // Gold color
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: missions.length,
        itemBuilder: (context, index) {
          return _buildMissionCard(missions[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد مهام حالياً',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
              fontFamily: 'Baloo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'استكشف الخريطة لإيجاد مهام قريبة منك',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Baloo',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to map
              Navigator.pop(context);
            },
            icon: const Icon(Icons.map, size: 20),
            label: const Text(
              'افتح الخريطة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Baloo',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4555), // Burgundy button
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    final String title = mission['title'] ?? 'بدون عنوان';
    final String description = mission['description'] ?? '';
    final String? creatorName = mission['creator_name'];
    final String? creatorAvatar = mission['creator_avatar'];
    final int storyCount = mission['story_count'] ?? 0;
    final int targetStories = mission['target_stories'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to mission details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mission title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  fontFamily: 'Baloo',
                ),
                textAlign: TextAlign.right,
              ),

              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Baloo',
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$storyCount/$targetStories قصة',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A7C59),
                          fontFamily: 'Baloo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: targetStories > 0 ? storyCount / targetStories : 0,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF4A7C59),
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),

              // Creator info
              if (creatorName != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: creatorAvatar != null
                          ? NetworkImage(creatorAvatar)
                          : null,
                      child: creatorAvatar == null
                          ? const Icon(Icons.person, size: 16)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      creatorName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Baloo',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
