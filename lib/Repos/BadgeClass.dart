// ignore_for_file: file_names

enum BadgeCategory {
  foundation,  // أوسمة الأساسيات
  community,   // أوسمة المجتمع
  legacy,      // أوسمة الإرث
}

enum BadgeRequirementType {
  storyCount,           // Submit X stories
  storyWithMedia,       // Submit story with photo/video
  missionCreate,        // Create a mission
  missionContribute,    // Contribute to someone's mission
  userInvite,           // Invite X users who contribute
  ambassadorStatus,     // Achieve ambassador status
  multiThemeStories,    // Stories across multiple themes
  familyHistory,        // Multi-generational content
  reconciliationStory,  // Peace-building content
  culturalMission,      // Create cultural preservation mission
  multipleMissions,     // Multiple successful missions
}

class BadgeRequirement {
  final BadgeRequirementType type;
  final int targetValue;
  final String requirementTextAr;
  final String requirementTextEn;

  BadgeRequirement({
    required this.type,
    required this.targetValue,
    required this.requirementTextAr,
    required this.requirementTextEn,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'targetValue': targetValue,
      'requirementTextAr': requirementTextAr,
      'requirementTextEn': requirementTextEn,
    };
  }

  factory BadgeRequirement.fromJson(Map<String, dynamic> json) {
    return BadgeRequirement(
      type: BadgeRequirementType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => BadgeRequirementType.storyCount,
      ),
      targetValue: json['targetValue'] ?? 0,
      requirementTextAr: json['requirementTextAr'] ?? '',
      requirementTextEn: json['requirementTextEn'] ?? '',
    );
  }
}

class Badge {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final BadgeCategory category;
  final String iconAsset;      // Path to local icon file
  final String colorHex;        // Badge primary color
  final BadgeRequirement requirement;

  // User-specific data (fetched from backend)
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentProgress;

  Badge({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.category,
    required this.iconAsset,
    required this.colorHex,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  String get categoryNameAr {
    switch (category) {
      case BadgeCategory.foundation:
        return 'أوسمة الأساسيات';
      case BadgeCategory.community:
        return 'أوسمة المجتمع';
      case BadgeCategory.legacy:
        return 'أوسمة الإرث';
    }
  }

  double get progressPercentage {
    if (isUnlocked) return 1.0;
    if (requirement.targetValue == 0) return 0.0;
    return (currentProgress / requirement.targetValue).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'category': category.toString(),
      'iconAsset': iconAsset,
      'colorHex': colorHex,
      'requirement': requirement.toJson(),
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'currentProgress': currentProgress,
    };
  }

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      descriptionEn: json['descriptionEn'] ?? '',
      category: BadgeCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => BadgeCategory.foundation,
      ),
      iconAsset: json['iconAsset'] ?? '',
      colorHex: json['colorHex'] ?? '#000000',
      requirement: BadgeRequirement.fromJson(json['requirement'] ?? {}),
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }

  // Create a copy with updated user progress
  Badge copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? currentProgress,
  }) {
    return Badge(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      category: category,
      iconAsset: iconAsset,
      colorHex: colorHex,
      requirement: requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }
}
