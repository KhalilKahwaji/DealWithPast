// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/BadgeClass.dart' as badge_class;
import 'BadgePlaceholder.dart';

class BadgeDetailModal extends StatelessWidget {
  final badge_class.Badge badge;

  const BadgeDetailModal({
    Key? key,
    required this.badge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),

            const SizedBox(height: 8),

            // Badge icon (large)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: badge.isUnlocked
                      ? _hexToColor(badge.colorHex)
                      : const Color(0xFFBDBDBD),
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                      return BadgePlaceholder(
                        name: badge.nameAr,
                        color: badge.isUnlocked
                            ? _hexToColor(badge.colorHex)
                            : Colors.grey,
                        size: 60,
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Badge name
            Text(
              badge.nameAr,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
                fontFamily: 'Baloo',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Status chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? const Color(0xFF42A5F5)
                    : const Color(0xFFBDBDBD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.isUnlocked ? 'المستخدم' : 'مقفل',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Baloo',
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              badge.descriptionAr,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontFamily: 'Baloo',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Unlock requirements section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'طريقة الحصول عليه',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontFamily: 'Baloo',
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    badge.requirement.requirementTextAr,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      fontFamily: 'Baloo',
                    ),
                    textAlign: TextAlign.right,
                  ),

                  // Progress bar (if not unlocked)
                  if (!badge.isUnlocked) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: badge.progressPercentage,
                              backgroundColor: const Color(0xFFE5E7EB),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _hexToColor(badge.colorHex),
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${badge.currentProgress}/${badge.requirement.targetValue}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
          ],
        ),
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
