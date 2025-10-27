// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';

class ImpactMetricsCard extends StatelessWidget {
  final int storiesContributed;
  final int missionsCreated;
  final int missionsParticipated;
  final int storiesWithMedia;
  final int peopleInvited;
  final int themesExplored;

  const ImpactMetricsCard({
    Key? key,
    required this.storiesContributed,
    required this.missionsCreated,
    required this.missionsParticipated,
    required this.storiesWithMedia,
    required this.peopleInvited,
    required this.themesExplored,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: Color(0xFF4A7C59),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'تأثيرك على المجتمع',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  fontFamily: 'Baloo',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Metrics grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildMetricItem(
                icon: Icons.history_edu,
                value: storiesContributed,
                label: 'قصة مساهمة',
                color: const Color(0xFF4A7C59),
              ),
              _buildMetricItem(
                icon: Icons.explore,
                value: missionsCreated,
                label: 'مهمة مُنشأة',
                color: const Color(0xFF6366F1),
              ),
              _buildMetricItem(
                icon: Icons.group_work,
                value: missionsParticipated,
                label: 'مهمة مشارك بها',
                color: const Color(0xFFF59E0B),
              ),
              _buildMetricItem(
                icon: Icons.perm_media,
                value: storiesWithMedia,
                label: 'قصة بوسائط',
                color: const Color(0xFFEC4899),
              ),
              _buildMetricItem(
                icon: Icons.person_add,
                value: peopleInvited,
                label: 'شخص مدعو',
                color: const Color(0xFF8B5CF6),
              ),
              _buildMetricItem(
                icon: Icons.category,
                value: themesExplored,
                label: 'موضوع مستكشف',
                color: const Color(0xFF14B8A6),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Baloo',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontFamily: 'Baloo',
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
