// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/BadgeClass.dart' as badge_class;
import 'BadgePlaceholder.dart';

class BadgeGrid extends StatelessWidget {
  final List<badge_class.Badge> badges;
  final Function(badge_class.Badge) onBadgeTap;

  const BadgeGrid({
    Key? key,
    required this.badges,
    required this.onBadgeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group badges by category
    final foundationBadges = badges
        .where((b) => b.category == badge_class.BadgeCategory.foundation)
        .toList();
    final communityBadges = badges
        .where((b) => b.category == badge_class.BadgeCategory.community)
        .toList();
    final legacyBadges = badges
        .where((b) => b.category == badge_class.BadgeCategory.legacy)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (foundationBadges.isNotEmpty) ...[
            _buildCategorySection(
              context,
              'أوسمة الأساسيات',
              foundationBadges,
            ),
            const SizedBox(height: 24),
          ],
          if (communityBadges.isNotEmpty) ...[
            _buildCategorySection(
              context,
              'أوسمة المجتمع',
              communityBadges,
            ),
            const SizedBox(height: 24),
          ],
          if (legacyBadges.isNotEmpty) ...[
            _buildCategorySection(
              context,
              'أوسمة الإرث',
              legacyBadges,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<badge_class.Badge> categoryBadges,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: categoryBadges.length,
          itemBuilder: (context, index) {
            return _buildBadgeItem(categoryBadges[index]);
          },
        ),
      ],
    );
  }

  Widget _buildBadgeItem(badge_class.Badge badge) {
    return GestureDetector(
      onTap: () => onBadgeTap(badge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge icon container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isUnlocked
                  ? Colors.white
                  : const Color(0xFFF5F5F5),
              border: Border.all(
                color: badge.isUnlocked
                    ? _hexToColor(badge.colorHex)
                    : const Color(0xFFBDBDBD),
                width: 2,
              ),
              boxShadow: badge.isUnlocked
                  ? [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ColorFiltered(
                colorFilter: badge.isUnlocked
                    ? const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : ColorFilter.matrix(const [
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                child: Image.asset(
                  badge.iconAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Colored placeholder with badge initials
                    return BadgePlaceholder(
                      name: badge.nameAr,
                      color: badge.isUnlocked
                          ? _hexToColor(badge.colorHex)
                          : Colors.grey,
                      size: 40,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Badge name
          Text(
            badge.nameAr,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
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

  // Helper to convert hex color string to Color
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
