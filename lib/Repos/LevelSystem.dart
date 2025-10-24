// ignore_for_file: file_names

import 'package:flutter/material.dart';

enum UserLevel {
  follower,         // متابع - Level 1
  contributor,      // مساهم - Level 2
  ambassador,       // سفير - Level 3
  foundingPartner,  // شريك مؤسس - Level 4
}

class Level {
  final UserLevel level;
  final String nameAr;
  final String nameEn;
  final int minStories;
  final int maxStories;
  final String iconAsset;
  final String colorHex;

  Level({
    required this.level,
    required this.nameAr,
    required this.nameEn,
    required this.minStories,
    required this.maxStories,
    required this.iconAsset,
    required this.colorHex,
  });

  static Level getLevelFromStoryCount(int storyCount) {
    if (storyCount < 5) return followerLevel;
    if (storyCount < 15) return contributorLevel;
    if (storyCount < 30) return ambassadorLevel;
    return foundingPartnerLevel;
  }

  static final Level followerLevel = Level(
    level: UserLevel.follower,
    nameAr: 'متابع',
    nameEn: 'Follower',
    minStories: 0,
    maxStories: 4,
    iconAsset: 'assets/levels/follower.png',
    colorHex: '#9CA3AF',
  );

  static final Level contributorLevel = Level(
    level: UserLevel.contributor,
    nameAr: 'مساهم',
    nameEn: 'Contributor',
    minStories: 5,
    maxStories: 14,
    iconAsset: 'assets/levels/contributor.png',
    colorHex: '#4A7C59',
  );

  static final Level ambassadorLevel = Level(
    level: UserLevel.ambassador,
    nameAr: 'سفير',
    nameEn: 'Ambassador',
    minStories: 15,
    maxStories: 29,
    iconAsset: 'assets/levels/ambassador.png',
    colorHex: '#D4AF37',
  );

  static final Level foundingPartnerLevel = Level(
    level: UserLevel.foundingPartner,
    nameAr: 'شريك مؤسس',
    nameEn: 'Founding Partner',
    minStories: 30,
    maxStories: 999,
    iconAsset: 'assets/levels/founding_partner.png',
    colorHex: '#8B1538',
  );

  Level? get nextLevel {
    switch (level) {
      case UserLevel.follower:
        return contributorLevel;
      case UserLevel.contributor:
        return ambassadorLevel;
      case UserLevel.ambassador:
        return foundingPartnerLevel;
      case UserLevel.foundingPartner:
        return null; // Max level
    }
  }

  int get requiredStories => maxStories + 1;

  Color get color {
    final buffer = StringBuffer();
    if (colorHex.length == 6 || colorHex.length == 7) buffer.write('ff');
    buffer.write(colorHex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static List<Level> get allLevels => [
    followerLevel,
    contributorLevel,
    ambassadorLevel,
    foundingPartnerLevel,
  ];
}
