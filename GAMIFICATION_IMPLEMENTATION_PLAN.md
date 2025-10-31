# Gamification Implementation Plan
## DealWithPast - Phase 2 & 3 Alignment

**Created:** October 24, 2025
**Status:** Planning Complete - Ready for Implementation
**Approach:** Hybrid (Figma Design + Documentation Specs)

---

## 📊 Executive Summary

This document outlines the complete implementation plan for integrating the gamification system into the DealWithPast Flutter app. The plan aligns Figma UI designs with the detailed gamification documentation, creating a cohesive 3-tab achievement system (المهام، الإنجازات، الإرث).

### Key Decisions Made:
- ✅ **Use Figma's 3-tab structure** (cleaner than docs' single evolving page)
- ✅ **Implement 12-badge system** from documentation
- ✅ **Skip 3-stage progressive legacy** (use Figma's simpler single design)
- ✅ **Keep profile legacy preview** (teaser widget, not duplication)
- ✅ **Add level progression system** (4 levels: متابع → مساهم → سفير → شريك مؤسس)

---

## 🎯 Final Architecture

```
Bottom Navigation:
├── الصفحة الرئيسية (Home)
├── استكشاف الخريطة (Map) ← Phase 1 Complete ✅
├── القصص (Stories)
├── الخريطة (Missions & Achievements) ← NEW 3-TAB SCREEN
│   ├── Tab 1: المهام (Missions) ← Phase 1 Complete ✅
│   ├── Tab 2: الإنجازات (Achievements) ← Phase 2 NEW
│   └── Tab 3: الإرث (Legacy) ← Phase 3 NEW
└── الملف الشخصي (Profile)
    └── Legacy Preview Widget ← Phase 5
```

---

## 📸 Figma Snapshot Analysis

### Snapshot 0: Map with Top Filter
**Status:** ✅ Phase 1 Complete (needs enhancement)
- Map with mission/story toggle working
- Search bar implemented
- Pin clustering functional
- **MISSING:** Mission creator info (avatar + name)

### Snapshots 1-2: Profile Page
**Current Design:**
```
Profile Structure:
├── User Header (avatar, name, level badge, join date)
├── Edit Profile + Settings
├── Three Stats Cards (Achievements, Missions, Stories)
├── Legacy Preview Card (progress + share button) ← TEASER
└── Recent Contributions + Settings
```

### Snapshot 3: Legacy Tab
**Design Specs:**
```
Legacy Tab:
├── Cedar Tree Icon 🌲
├── "لوحة إرثك" Header
├── Memorial Card (white, rounded):
│   ├── Title with emojis
│   ├── Level badge
│   ├── Stats: 12 قصص, 3 شهام, 5 مؤسسة
│   ├── Description
│   └── "شارك إرثك" button (burgundy)
└── "تأثيرك" Impact Metrics Section
```

### Snapshot 4: Mission Detail
**Key Feature:** Creator info section
```
Creator Section:
├── Avatar (circular, 40px)
├── Name: "ليلى حسين"
└── Context: "عائلة لايم"
```
**Action:** Use this design for Phase 1 completion!

### Snapshots 5-6: Badge System
**Badge Categories:**
```
أوسمة الأساسيات (Foundation - 3 badges):
├── 1. صوت (Voice) - Pink/Red, Microphone
├── 2. شاهد (Witness) - Purple, Camera
└── 3. حافظ الذاكرة (Memory Keeper) - Gold, Flame

أوسمة المجتمع (Community - 4 badges):
├── 4. بناء الجسور (Bridge Builder)
├── 5. بناء الشبكة (Network Builder)
├── 6. صناعة الشهام (Mission Creator)
└── 7. سفير (Ambassador)

أوسمة الإرث (Legacy - 5 badges):
├── 8. حارس (Guardian)
├── 9. صوت موثوق (Trusted Voice)
├── 10. صانع السلام (Peacemaker)
├── 11. حافظ التراث (Heritage Keeper)
└── 12. قائد المجتمع (Community Leader)
```

**Badge Detail Modal:**
```
├── Large badge icon (120px)
├── Badge name + status chip ("المستخدم" or "مقفل")
├── Description text
├── Unlock requirements ("شارك 3 قصص مع صور")
├── Progress indicator
└── Related badges section
```

---

## 🎨 Design System Specifications

### Color Palette
```dart
class GameColors {
  // Primary Colors
  static const cedarGreen = Color(0xFF4A7C59);      // Level badges, primary buttons
  static const burgundy = Color(0xFF7D5A50);        // Share buttons, accents
  static const beigeTan = Color(0xFFF5E6D3);        // Card backgrounds
  static const gold = Color(0xFFD4AF37);            // Badge accents, progress
  static const offWhite = Color(0xFFF8F8F8);        // Main background

  // Badge Colors (Foundation)
  static const badgeRed = Color(0xFFE57373);        // Voice badge
  static const badgePurple = Color(0xFF9575CD);     // Witness badge
  static const badgeYellow = Color(0xFFFFD54F);     // Memory Keeper badge

  // Badge Colors (Community)
  static const badgeBlue = Color(0xFF42A5F5);       // Bridge Builder
  static const badgeTeal = Color(0xFF26A69A);       // Network Builder
  static const badgeOrange = Color(0xFFFF9800);     // Mission Creator
  static const badgeCyan = Color(0xFF00BCD4);       // Ambassador

  // Badge Colors (Legacy)
  static const badgeBurgundy = Color(0xFF8B1538);   // Guardian
  static const badgeRoyalBlue = Color(0xFF4169E1);  // Trusted Voice
  static const badgeOliveGreen = Color(0xFF808000); // Peacemaker
  static const badgeStone = Color(0xFFD2B48C);      // Heritage Keeper
  static const badgeForestGreen = Color(0xFF0F5132);// Community Leader

  // Status Colors
  static const unlockedBlue = Color(0xFF42A5F5);    // "المستخدم" status chip
  static const lockedGray = Color(0xFFBDBDBD);      // Locked badge backgrounds
  static const progressGreen = Color(0xFF4CAF50);   // Progress bars
}
```

### Typography
```dart
// Arabic Font: Noto Sans Arabic (already in app)

class GameTextStyles {
  // Headers
  static const pageTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1F2937),
  );

  static const sectionHeader = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1F2937),
  );

  // Badge Names
  static const badgeName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1F2937),
  );

  // Body Text
  static const bodyText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF4B5563),
  );

  // Small Text (metadata)
  static const smallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFF6B7280),
  );

  // Level Badge
  static const levelBadge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
```

---

## 📐 Asset Specifications

### Badge Icons

#### Technical Requirements:
```
Format: PNG ONLY with transparency (RGBA)
Color Mode: Full color with transparency
Background: Transparent
Export Quality: @1x, @2x, @3x

Icon Sizes:
├── Grid Display: 80x80 dp (logical pixels)
│   ├── @1x: 80x80 px
│   ├── @2x: 160x160 px
│   └── @3x: 240x240 px
│
├── Detail Modal: 120x120 dp
│   ├── @1x: 120x120 px
│   ├── @2x: 240x240 px
│   └── @3x: 360x360 px
│
└── Small Display (profile): 40x40 dp
    ├── @1x: 40x40 px
    ├── @2x: 80x80 px
    └── @3x: 120x120 px
```

#### File Organization:
```
DealWithPast/assets/badges/
├── foundation/
│   ├── voice.png (80x80)
│   ├── voice@2x.png (160x160)
│   ├── voice@3x.png (240x240)
│   ├── witness.png
│   ├── witness@2x.png
│   ├── witness@3x.png
│   ├── memory_keeper.png
│   ├── memory_keeper@2x.png
│   └── memory_keeper@3x.png
│
├── community/
│   ├── bridge_builder.png
│   ├── bridge_builder@2x.png
│   ├── bridge_builder@3x.png
│   ├── network_builder.png
│   ├── network_builder@2x.png
│   ├── network_builder@3x.png
│   ├── mission_creator.png
│   ├── mission_creator@2x.png
│   ├── mission_creator@3x.png
│   ├── ambassador.png
│   ├── ambassador@2x.png
│   └── ambassador@3x.png
│
└── legacy/
    ├── guardian.png
    ├── guardian@2x.png
    ├── guardian@3x.png
    ├── trusted_voice.png
    ├── trusted_voice@2x.png
    ├── trusted_voice@3x.png
    ├── peacemaker.png
    ├── peacemaker@2x.png
    ├── peacemaker@3x.png
    ├── heritage_keeper.png
    ├── heritage_keeper@2x.png
    ├── heritage_keeper@3x.png
    ├── community_leader.png
    ├── community_leader@2x.png
    └── community_leader@3x.png
```

#### Naming Convention:
```
Format: [category]_[badge_name]_[state]_[size].png

Examples:
- foundation_voice_unlocked_80.png
- foundation_voice_locked_80.png
- community_ambassador_unlocked_120.png
- legacy_guardian_locked_40.png
```

#### Icon States:
```
Unlocked State:
├── Full color badge icon
├── Colored border (2px, badge color)
├── Shadow: elevation 2
└── Opacity: 1.0

Locked State:
├── Grayscale icon (desaturated)
├── Dashed border (2px, gray)
├── No shadow
└── Opacity: 0.5
```

### User Avatars

#### Technical Requirements:
```
Format: PNG, JPEG
Shape: Circular (will be clipped in UI)
Background: Any (will be cropped to circle)

Avatar Sizes:
├── Profile Header: 80x80 dp
│   ├── @1x: 80x80 px
│   ├── @2x: 160x160 px
│   └── @3x: 240x240 px
│
├── Mission Creator: 40x40 dp
│   ├── @1x: 40x40 px
│   ├── @2x: 80x80 px
│   └── @3x: 120x120 px
│
└── Small (lists): 32x32 dp
    ├── @1x: 32x32 px
    ├── @2x: 64x64 px
    └── @3x: 96x96 px
```

#### Default Avatar (when user has no image):
```
Type: Generated initial badge
Style: Circular with initials
Background: Beige (#F5E6D3)
Text: First 2 letters of name
Font Size: 24px (80dp), 16px (40dp), 12px (32dp)
Text Color: #7D5A50 (burgundy)
```

### Level Icons

#### Technical Requirements:
```
Format: PNG ONLY with transparency
Sizes: Same as badge icons (80dp, 120dp, 40dp)
Export Quality: @1x, @2x, @3x

Level Icon Files:
assets/levels/
├── follower.png (80x80)
├── follower@2x.png (160x160)
├── follower@3x.png (240x240)
├── contributor.png
├── contributor@2x.png
├── contributor@3x.png
├── ambassador.png
├── ambassador@2x.png
├── ambassador@3x.png
├── founding_partner.png
├── founding_partner@2x.png
└── founding_partner@3x.png
```

### Mission Icons

#### Technical Requirements:
```
Format: PNG ONLY with transparency
Size: 48x48 dp (for mission cards)
Export Quality: @1x, @2x, @3x
Background: Transparent or colored circle

Mission Icon Files:
assets/missions/
├── social.png (48x48)
├── social@2x.png (96x96)
├── social@3x.png (144x144)
├── personal.png
├── personal@2x.png
├── personal@3x.png
├── community.png
├── community@2x.png
└── community@3x.png
```

---

## 🏗️ Implementation Phases

### ✅ PHASE 1 COMPLETION: Mission Creator Info (1-2 days)

#### Overview:
Add creator information (avatar, name, context) to mission discovery cards on the Map screen.

#### Tasks:

**1.1 WordPress API Enhancement**
- **File:** `wordpress-plugin/dwp-gamification/includes/class-api-endpoints.php`
- **Method:** `format_mission_data()`
- **Change:** Add author data to mission response

```php
// Add to format_mission_data() method around line 540
$author_id = get_post_field('post_author', $mission_id);
$author_data = array(
    'id' => $author_id,
    'name' => get_the_author_meta('display_name', $author_id),
    'avatar_url' => get_avatar_url($author_id, array('size' => 80)),
    'family_context' => get_user_meta($author_id, 'family_name', true) // Optional
);

// Add to mission data array
$mission_data['creator'] = $author_data;
```

**1.2 Flutter Mission Model Update**
- **File:** `DealWithPast/lib/Repos/MissionRepo.dart` (or wherever Mission class is)
- **Add:** Creator data fields

```dart
class Mission {
  // Existing fields...
  final Creator? creator;

  Mission.fromJson(Map<String, dynamic> json)
      : // existing fields...
        creator = json['creator'] != null
            ? Creator.fromJson(json['creator'])
            : null;
}

class Creator {
  final int id;
  final String name;
  final String avatarUrl;
  final String? familyContext;

  Creator.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] ?? '',
        avatarUrl = json['avatar_url'] ?? '',
        familyContext = json['family_context'];
}
```

**1.3 Map Screen UI Update**
- **File:** `DealWithPast/lib/Map/map.dart`
- **Location:** Mission card widget (around line 1200-1400)
- **Add:** Creator info section below mission title

```dart
// Inside mission card widget, after mission title:
if (mission.creator != null) ...[
  SizedBox(height: 8),
  Row(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(mission.creator!.avatarUrl),
        backgroundColor: AppColors.surface,
      ),
      SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mission.creator!.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          if (mission.creator!.familyContext != null)
            Text(
              mission.creator!.familyContext!,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.muted,
              ),
            ),
        ],
      ),
    ],
  ),
],
```

**1.4 Testing Checklist:**
- [ ] API returns creator data for all missions
- [ ] Avatar images load correctly
- [ ] Default avatar appears when user has no image
- [ ] Creator name displays in Arabic RTL correctly
- [ ] Family context displays when available
- [ ] Mission cards without creator data don't crash

---

### 🆕 PHASE 2: Badge System (3-4 days)

#### Overview:
Implement the complete 12-badge system with unlock logic, badge grid display, and detail modals.

#### Tasks:

**2.1 Badge Data Models**
- **Create:** `DealWithPast/lib/Repos/BadgeClass.dart`

```dart
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

class Badge {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final BadgeCategory category;
  final String iconAsset;      // Path to icon file
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
}

class BadgeRequirement {
  final BadgeRequirementType type;
  final int targetValue;
  final String requirementTextAr;  // e.g., "شارك 3 قصص مع صور"
  final String requirementTextEn;

  BadgeRequirement({
    required this.type,
    required this.targetValue,
    required this.requirementTextAr,
    required this.requirementTextEn,
  });
}
```

**2.2 Badge Repository**
- **Create:** `DealWithPast/lib/Repos/BadgeRepo.dart`

```dart
class BadgeRepo {
  // Static badge definitions (12 badges)
  static final List<Badge> allBadges = [
    // FOUNDATION BADGES
    Badge(
      id: 'voice',
      nameAr: 'صوت',
      nameEn: 'Voice',
      descriptionAr: 'منحت لإضافة شهادة صوتية أو فيديو',
      descriptionEn: 'Awarded for submitting audio or video testimony',
      category: BadgeCategory.foundation,
      iconAsset: 'assets/badges/foundation/voice.png',
      colorHex: '#E57373',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.storyWithMedia,
        targetValue: 1,
        requirementTextAr: 'أضف شهادة صوتية أو فيديو',
        requirementTextEn: 'Add audio or video testimony',
      ),
    ),

    Badge(
      id: 'witness',
      nameAr: 'شاهد',
      nameEn: 'Witness',
      descriptionAr: 'منحت لإضافة صور أو وثائق مع القصص',
      descriptionEn: 'Awarded for adding photos or documents to stories',
      category: BadgeCategory.foundation,
      iconAsset: 'assets/badges/foundation/witness.png',
      colorHex: '#9575CD',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.storyWithMedia,
        targetValue: 3,
        requirementTextAr: 'شارك 3 قصص مع صور',
        requirementTextEn: 'Share 3 stories with photos',
      ),
    ),

    Badge(
      id: 'memory_keeper',
      nameAr: 'حافظ الذاكرة',
      nameEn: 'Memory Keeper',
      descriptionAr: 'منحت لمشاركة أول قصة معتمدة',
      descriptionEn: 'Awarded for sharing your first approved story',
      category: BadgeCategory.foundation,
      iconAsset: 'assets/badges/foundation/memory_keeper.png',
      colorHex: '#FFD54F',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.storyCount,
        targetValue: 1,
        requirementTextAr: 'شارك قصتك الأولى',
        requirementTextEn: 'Share your first story',
      ),
    ),

    // COMMUNITY BADGES
    Badge(
      id: 'bridge_builder',
      nameAr: 'بناء الجسور',
      nameEn: 'Bridge Builder',
      descriptionAr: 'منحت للمساهمة في مهمة شخص آخر',
      descriptionEn: 'Awarded for contributing to someone else\'s mission',
      category: BadgeCategory.community,
      iconAsset: 'assets/badges/community/bridge_builder.png',
      colorHex: '#42A5F5',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.missionContribute,
        targetValue: 1,
        requirementTextAr: 'ساهم في مهمة شخص آخر',
        requirementTextEn: 'Contribute to someone\'s mission',
      ),
    ),

    Badge(
      id: 'network_builder',
      nameAr: 'بناء الشبكة',
      nameEn: 'Network Builder',
      descriptionAr: 'منحت لدعوة أشخاص يساهمون في القصص',
      descriptionEn: 'Awarded for inviting others who contribute stories',
      category: BadgeCategory.community,
      iconAsset: 'assets/badges/community/network_builder.png',
      colorHex: '#26A69A',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.userInvite,
        targetValue: 3,
        requirementTextAr: 'ادعُ 3 أشخاص يساهمون',
        requirementTextEn: 'Invite 3 people who contribute',
      ),
    ),

    Badge(
      id: 'mission_creator',
      nameAr: 'صناعة الشهام',
      nameEn: 'Mission Creator',
      descriptionAr: 'منحت لإنشاء مهمة ناجحة',
      descriptionEn: 'Awarded for creating a successful mission',
      category: BadgeCategory.community,
      iconAsset: 'assets/badges/community/mission_creator.png',
      colorHex: '#FF9800',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.missionCreate,
        targetValue: 1,
        requirementTextAr: 'أنشئ مهمة واحدة',
        requirementTextEn: 'Create one mission',
      ),
    ),

    Badge(
      id: 'ambassador',
      nameAr: 'سفير',
      nameEn: 'Ambassador',
      descriptionAr: 'منحت لتحقيق مكانة القيادة في مهمة نشطة',
      descriptionEn: 'Awarded for achieving leadership status in active mission',
      category: BadgeCategory.community,
      iconAsset: 'assets/badges/community/ambassador.png',
      colorHex: '#00BCD4',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.ambassadorStatus,
        targetValue: 1,
        requirementTextAr: 'حقق مكانة السفير',
        requirementTextEn: 'Achieve ambassador status',
      ),
    ),

    // LEGACY BADGES
    Badge(
      id: 'guardian',
      nameAr: 'حارس',
      nameEn: 'Guardian',
      descriptionAr: 'منحت لحفظ تاريخ العائلة أو المجتمع',
      descriptionEn: 'Awarded for preserving family or community history',
      category: BadgeCategory.legacy,
      iconAsset: 'assets/badges/legacy/guardian.png',
      colorHex: '#8B1538',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.familyHistory,
        targetValue: 1,
        requirementTextAr: 'احفظ تاريخ عائلتك',
        requirementTextEn: 'Preserve family history',
      ),
    ),

    Badge(
      id: 'trusted_voice',
      nameAr: 'صوت موثوق',
      nameEn: 'Trusted Voice',
      descriptionAr: 'منحت للمساهمات المستمرة عبر مواضيع متعددة',
      descriptionEn: 'Awarded for sustained contributions across themes',
      category: BadgeCategory.legacy,
      iconAsset: 'assets/badges/legacy/trusted_voice.png',
      colorHex: '#4169E1',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.multiThemeStories,
        targetValue: 5,
        requirementTextAr: 'شارك 5 قصص معتمدة',
        requirementTextEn: 'Share 5 approved stories',
      ),
    ),

    Badge(
      id: 'peacemaker',
      nameAr: 'صانع السلام',
      nameEn: 'Peacemaker',
      descriptionAr: 'منحت لمشاركة قصص المصالحة والتفاهم',
      descriptionEn: 'Awarded for sharing reconciliation stories',
      category: BadgeCategory.legacy,
      iconAsset: 'assets/badges/legacy/peacemaker.png',
      colorHex: '#808000',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.reconciliationStory,
        targetValue: 1,
        requirementTextAr: 'شارك قصة مصالحة',
        requirementTextEn: 'Share a reconciliation story',
      ),
    ),

    Badge(
      id: 'heritage_keeper',
      nameAr: 'حافظ التراث',
      nameEn: 'Heritage Keeper',
      descriptionAr: 'منحت لإنشاء مهام حفظ التراث اللبناني',
      descriptionEn: 'Awarded for creating cultural preservation missions',
      category: BadgeCategory.legacy,
      iconAsset: 'assets/badges/legacy/heritage_keeper.png',
      colorHex: '#D2B48C',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.culturalMission,
        targetValue: 1,
        requirementTextAr: 'أنشئ مهمة ثقافية',
        requirementTextEn: 'Create cultural mission',
      ),
    ),

    Badge(
      id: 'community_leader',
      nameAr: 'قائد المجتمع',
      nameEn: 'Community Leader',
      descriptionAr: 'منحت لقيادة مهام متعددة ناجحة',
      descriptionEn: 'Awarded for multiple successful missions',
      category: BadgeCategory.legacy,
      iconAsset: 'assets/badges/legacy/community_leader.png',
      colorHex: '#0F5132',
      requirement: BadgeRequirement(
        type: BadgeRequirementType.multipleMissions,
        targetValue: 3,
        requirementTextAr: 'أنشئ 3 مهام ناجحة',
        requirementTextEn: 'Create 3 successful missions',
      ),
    ),
  ];

  // Fetch user's badge progress from backend
  Future<List<Badge>> getUserBadges(int userId) async {
    // TODO: Call WordPress API to get user's badge unlock status
    // API endpoint: /wp-json/dwp/v1/users/{userId}/badges

    // For now, return static data with mock progress
    return allBadges;
  }

  // Get badges by category
  static List<Badge> getBadgesByCategory(BadgeCategory category) {
    return allBadges.where((b) => b.category == category).toList();
  }

  // Get unlocked badges count
  static int getUnlockedCount(List<Badge> badges) {
    return badges.where((b) => b.isUnlocked).length;
  }
}
```

**2.3 Badge Grid Widget**
- **Create:** `DealWithPast/lib/widgets/BadgeGrid.dart`

```dart
import 'package:flutter/material.dart';
import '../Repos/BadgeClass.dart';

class BadgeGrid extends StatelessWidget {
  final List<Badge> badges;
  final Function(Badge) onBadgeTap;

  const BadgeGrid({
    Key? key,
    required this.badges,
    required this.onBadgeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group badges by category
    final foundationBadges = badges
        .where((b) => b.category == BadgeCategory.foundation)
        .toList();
    final communityBadges = badges
        .where((b) => b.category == BadgeCategory.community)
        .toList();
    final legacyBadges = badges
        .where((b) => b.category == BadgeCategory.legacy)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySection(
            context,
            'أوسمة الأساسيات',
            foundationBadges,
          ),
          SizedBox(height: 24),
          _buildCategorySection(
            context,
            'أوسمة المجتمع',
            communityBadges,
          ),
          SizedBox(height: 24),
          _buildCategorySection(
            context,
            'أوسمة الإرث',
            legacyBadges,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<Badge> categoryBadges,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

  Widget _buildBadgeItem(Badge badge) {
    return GestureDetector(
      onTap: () => onBadgeTap(badge),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badge.isUnlocked
                  ? Colors.white
                  : Color(0xFFF5F5F5),
              border: Border.all(
                color: badge.isUnlocked
                    ? Color(int.parse('0xFF${badge.colorHex.substring(1)}'))
                    : Color(0xFFBDBDBD),
                width: 2,
                style: badge.isUnlocked
                    ? BorderStyle.solid
                    : BorderStyle.none,
              ),
              boxShadow: badge.isUnlocked
                  ? [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ColorFiltered(
                colorFilter: badge.isUnlocked
                    ? ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : ColorFilter.matrix([
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                child: Image.asset(
                  badge.iconAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback icon if image not found
                    return Icon(
                      Icons.emoji_events,
                      size: 40,
                      color: badge.isUnlocked
                          ? Color(int.parse('0xFF${badge.colorHex.substring(1)}'))
                          : Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            badge.nameAr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
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
```

**2.4 Badge Detail Modal**
- **Create:** `DealWithPast/lib/widgets/BadgeDetailModal.dart`

```dart
import 'package:flutter/material.dart';
import '../Repos/BadgeClass.dart';

class BadgeDetailModal extends StatelessWidget {
  final Badge badge;

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
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),

            SizedBox(height: 8),

            // Badge icon (large)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: badge.isUnlocked
                      ? Color(int.parse('0xFF${badge.colorHex.substring(1)}'))
                      : Color(0xFFBDBDBD),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: ColorFiltered(
                  colorFilter: badge.isUnlocked
                      ? ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                      : ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0, 0, 0, 1, 0,
                        ]),
                  child: Image.asset(
                    badge.iconAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.emoji_events,
                        size: 60,
                        color: badge.isUnlocked
                            ? Color(int.parse('0xFF${badge.colorHex.substring(1)}'))
                            : Colors.grey,
                      );
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Badge name
            Text(
              badge.nameAr,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            // Status chip
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? Color(0xFF42A5F5)
                    : Color(0xFFBDBDBD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.isUnlocked ? 'المستخدم' : 'مقفل',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Description
            Text(
              badge.descriptionAr,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24),

            // Unlock requirements section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طريقة الحصول عليه',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    badge.requirement.requirementTextAr,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                    ),
                  ),

                  // Progress bar (if not unlocked)
                  if (!badge.isUnlocked) ...[
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: badge.progressPercentage,
                              backgroundColor: Color(0xFFE5E7EB),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(int.parse('0xFF${badge.colorHex.substring(1)}')),
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${badge.currentProgress}/${badge.requirement.targetValue}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
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
}
```

**2.5 WordPress API for Badges**
- **File:** `wordpress-plugin/dwp-gamification/includes/class-api-endpoints.php`
- **Add:** New endpoint for user badges

```php
// Add to register_routes() method
register_rest_route('dwp/v1', '/users/(?P<id>\d+)/badges', array(
    'methods' => 'GET',
    'callback' => array($this, 'get_user_badges'),
    'permission_callback' => '__return_true',
));

// New method to get user badges
public function get_user_badges($request) {
    $user_id = $request['id'];

    // Get user's story count, mission count, etc.
    $user_stats = $this->get_user_stats($user_id);

    // Calculate badge unlock status based on user stats
    $badges = array(
        array(
            'id' => 'memory_keeper',
            'is_unlocked' => $user_stats['story_count'] >= 1,
            'current_progress' => min($user_stats['story_count'], 1),
            'unlocked_at' => $this->get_badge_unlock_date($user_id, 'memory_keeper'),
        ),
        array(
            'id' => 'witness',
            'is_unlocked' => $user_stats['stories_with_media'] >= 3,
            'current_progress' => min($user_stats['stories_with_media'], 3),
            'unlocked_at' => $this->get_badge_unlock_date($user_id, 'witness'),
        ),
        // ... other badges
    );

    return rest_ensure_response($badges);
}
```

**2.6 Testing Checklist:**
- [ ] All 12 badges display in grid
- [ ] Badges grouped correctly by category
- [ ] Locked badges show grayscale
- [ ] Unlocked badges show in color
- [ ] Badge detail modal opens on tap
- [ ] Progress bars show correct percentage
- [ ] API returns correct unlock status
- [ ] Placeholder icons work as fallback

---

### 🆕 PHASE 3: Achievements Tab (2-3 days)

#### Overview:
Build the Achievements tab with level progression system and badge showcase.

#### Tasks:

**3.1 Level System**
- **Create:** `DealWithPast/lib/Repos/LevelSystem.dart`

```dart
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
}
```

**3.2 Current Level Card Widget**
- **Create:** `DealWithPast/lib/widgets/CurrentLevelCard.dart`

```dart
import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';

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
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(int.parse('0xFF${currentLevel.colorHex.substring(1)}')),
            Color(int.parse('0xFF${currentLevel.colorHex.substring(1)}'))
                .withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Image.asset(
                currentLevel.iconAsset,
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.emoji_events,
                    size: 40,
                    color: Color(int.parse('0xFF${currentLevel.colorHex.substring(1)}')),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 12),

          // Level name
          Text(
            currentLevel.nameAr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8),

          // Progress text
          if (!isMaxLevel) ...[
            Text(
              'التقدم في المستوى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 4),
            Text(
              '$storiesInCurrentLevel/${storiesRequiredForLevel} قصة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ] else ...[
            Text(
              'المستوى الأقصى!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

**3.3 Level Progression Path Widget**
- **Create:** `DealWithPast/lib/widgets/LevelProgressionPath.dart`

```dart
import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';

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
    final levels = [
      Level.followerLevel,
      Level.contributorLevel,
      Level.ambassadorLevel,
      Level.foundingPartnerLevel,
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مسار',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16),
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
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Level icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked
                  ? Color(0xFFF3F4F6)
                  : Color(int.parse('0xFF${level.colorHex.substring(1)}')).withOpacity(0.1),
              border: Border.all(
                color: isCurrent
                    ? Color(int.parse('0xFF${level.colorHex.substring(1)}'))
                    : isCompleted
                        ? Color(0xFF10B981)
                        : Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Color(0xFF10B981), size: 24)
                  : isLocked
                      ? Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 24)
                      : Image.asset(
                          level.iconAsset,
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.emoji_events,
                              color: Color(int.parse('0xFF${level.colorHex.substring(1)}')),
                              size: 24,
                            );
                          },
                        ),
            ),
          ),

          SizedBox(width: 12),

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
                        ? Color(0xFF1F2937)
                        : isLocked
                            ? Color(0xFF9CA3AF)
                            : Color(0xFF4B5563),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  isCompleted
                      ? 'مكتمل'
                      : isCurrent
                          ? 'المستوى الحالي'
                          : 'قصص مقبولة ${level.minStories}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Status indicator
          if (isCurrent)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${level.colorHex.substring(1)}')),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'الآن',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

**3.4 Achievements Tab Screen**
- **Create:** `DealWithPast/lib/Missions/achievements_tab.dart`

```dart
import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import '../Repos/BadgeClass.dart';
import '../Repos/BadgeRepo.dart';
import '../widgets/CurrentLevelCard.dart';
import '../widgets/LevelProgressionPath.dart';
import '../widgets/BadgeGrid.dart';
import '../widgets/BadgeDetailModal.dart';

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({Key? key}) : super(key: key);

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  int currentStoryCount = 7; // TODO: Fetch from user data
  late Level currentLevel;
  List<Badge> userBadges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    // Calculate current level
    currentLevel = Level.getLevelFromStoryCount(currentStoryCount);

    // Load badges from repository
    userBadges = await BadgeRepo().getUserBadges(1); // TODO: Use actual user ID

    setState(() => isLoading = false);
  }

  void _showBadgeDetail(Badge badge) {
    showDialog(
      context: context,
      builder: (context) => BadgeDetailModal(badge: badge),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
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

          SizedBox(height: 8),

          // Badges section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'إنجازاتك',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),

          // Badge grid
          BadgeGrid(
            badges: userBadges,
            onBadgeTap: _showBadgeDetail,
          ),
        ],
      ),
    );
  }
}
```

**3.5 Testing Checklist:**
- [ ] Current level displays correctly
- [ ] Progress bar shows accurate percentage
- [ ] Level progression path shows all 4 levels
- [ ] Current level is highlighted
- [ ] Completed levels show checkmark
- [ ] Locked levels show lock icon
- [ ] Badge grid displays below level system
- [ ] All components scroll smoothly

---

### 🆕 PHASE 4: Legacy Tab (2-3 days)

#### Overview:
Build the Legacy tab with memorial plaque and impact metrics.

#### Tasks:

**4.1 Memorial Card Widget**
- **Create:** `DealWithPast/lib/widgets/MemorialCard.dart`

```dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../Repos/BadgeClass.dart';
import '../Repos/LevelSystem.dart';

class MemorialCard extends StatelessWidget {
  final String userName;
  final Level userLevel;
  final int storyCount;
  final int missionCount;
  final int foundationCount;
  final List<Badge> unlockedBadges;

  const MemorialCard({
    Key? key,
    required this.userName,
    required this.userLevel,
    required this.storyCount,
    required this.missionCount,
    required this.foundationCount,
    required this.unlockedBadges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          // Cedar icon
          Icon(
            Icons.park,
            size: 48,
            color: Color(0xFF0F5132),
          ),

          SizedBox(height: 12),

          Text(
            'لوحة إرثك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),

          SizedBox(height: 4),

          Text(
            'رمز لمساهماتك في التسليم',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),

          SizedBox(height: 20),

          // Memorial plaque card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black05,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Title section
                Text(
                  'منذج الإرث',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),

                SizedBox(height: 8),

                // Custom title with emojis
                Text(
                  'نور ❤️🕊️🕊️ الذكرى',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12),

                // Level badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${userLevel.colorHex.substring(1)}')),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    userLevel.nameAr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('القصص', storyCount),
                    _buildStatItem('الشهام', missionCount),
                    _buildStatItem('المؤسسة', foundationCount),
                  ],
                ),

                SizedBox(height: 20),

                // Description
                Text(
                  'يتم التسليم من خلال القصص المشتركة من الخبرات الشخصية',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // Badge showcase
                if (unlockedBadges.isNotEmpty) ...[
                  Divider(),
                  SizedBox(height: 12),
                  Text(
                    'الأوسمة المكتسبة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: unlockedBadges.take(6).map((badge) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse('0xFF${badge.colorHex.substring(1)}')).withOpacity(0.1),
                        ),
                        child: Center(
                          child: Image.asset(
                            badge.iconAsset,
                            width: 28,
                            height: 28,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.emoji_events,
                                size: 24,
                                color: Color(int.parse('0xFF${badge.colorHex.substring(1)}')),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12),
                ],
              ],
            ),
          ),

          SizedBox(height: 16),

          // Share button
          ElevatedButton.icon(
            onPressed: _shareLegacy,
            icon: Icon(Icons.share, size: 18),
            label: Text(
              'شارك إرثك',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7D5A50),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  void _shareLegacy() {
    final message = '''
لقد ساهمت في حفظ $storyCount قصة من الذاكرة اللبنانية في تطبيق "خارطة وذاكرة".

شاهد إرثي وانضم لحفظ ذاكرتنا المشتركة.
''';

    Share.share(message);
  }
}
```

**4.2 Impact Metrics Widget**
- **Create:** `DealWithPast/lib/widgets/ImpactMetrics.dart`

```dart
import 'package:flutter/material.dart';

class ImpactMetrics extends StatelessWidget {
  final int totalReach;
  final DateTime memberSince;
  final double participationPercentage;

  const ImpactMetrics({
    Key? key,
    required this.totalReach,
    required this.memberSince,
    required this.participationPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تأثيرك',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),

          SizedBox(height: 16),

          _buildMetricRow(
            Icons.people,
            'الشخاص الذين تم الوصول إليهم',
            totalReach.toString(),
          ),

          SizedBox(height: 12),

          _buildMetricRow(
            Icons.calendar_today,
            'عضو منذ',
            _formatDate(memberSince),
          ),

          SizedBox(height: 12),

          _buildMetricRow(
            Icons.show_chart,
            'التزامك في المجتمع',
            '${participationPercentage.toStringAsFixed(0)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Color(0xFF6B7280)),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'إبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
```

**4.3 Legacy Tab Screen**
- **Create:** `DealWithPast/lib/Missions/legacy_tab.dart`

```dart
import 'package:flutter/material.dart';
import '../Repos/LevelSystem.dart';
import '../Repos/BadgeClass.dart';
import '../Repos/BadgeRepo.dart';
import '../widgets/MemorialCard.dart';
import '../widgets/ImpactMetrics.dart';

class LegacyTab extends StatefulWidget {
  const LegacyTab({Key? key}) : super(key: key);

  @override
  State<LegacyTab> createState() => _LegacyTabState();
}

class _LegacyTabState extends State<LegacyTab> {
  // TODO: Fetch from user data
  String userName = 'سيارة الجور';
  int storyCount = 12;
  int missionCount = 3;
  int foundationCount = 5;
  Level currentLevel = Level.contributorLevel;
  List<Badge> unlockedBadges = [];

  int totalReach = 1247;
  DateTime memberSince = DateTime(2024, 3, 15);
  double participationPercentage = 15.0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);

    // Load user badges
    final allBadges = await BadgeRepo().getUserBadges(1); // TODO: Use actual user ID
    unlockedBadges = allBadges.where((b) => b.isUnlocked).toList();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          MemorialCard(
            userName: userName,
            userLevel: currentLevel,
            storyCount: storyCount,
            missionCount: missionCount,
            foundationCount: foundationCount,
            unlockedBadges: unlockedBadges,
          ),

          ImpactMetrics(
            totalReach: totalReach,
            memberSince: memberSince,
            participationPercentage: participationPercentage,
          ),

          SizedBox(height: 24),
        ],
      ),
    );
  }
}
```

**4.4 Testing Checklist:**
- [ ] Memorial card displays correctly
- [ ] Stats show accurate values
- [ ] Unlocked badges appear in showcase
- [ ] Share button triggers sharing
- [ ] Impact metrics display correctly
- [ ] Date formatting works in Arabic
- [ ] All components scroll smoothly

---

### 🆕 PHASE 5: Profile Integration (1 day)

#### Overview:
Add legacy preview widget to profile page and make stats cards navigable.

#### Tasks:

**5.1 Legacy Preview Widget**
- **Create:** `DealWithPast/lib/widgets/LegacyPreviewWidget.dart`

```dart
import 'package:flutter/material.dart';

class LegacyPreviewWidget extends StatelessWidget {
  final int currentProgress;  // Current badge count
  final int totalBadges;      // Total available badges
  final VoidCallback onTap;

  const LegacyPreviewWidget({
    Key? key,
    required this.currentProgress,
    required this.totalBadges,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progressPercentage = (currentProgress / totalBadges).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5E6D3),
              Color(0xFFE8D5C0),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.chevron_left, color: Color(0xFF7D5A50)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'لوحة إرثك',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'مكتمل $currentProgress/$totalBadges',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.lightbulb, color: Color(0xFFD4AF37), size: 32),
              ],
            ),

            SizedBox(height: 16),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  // Background (full width)
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4CAF50),
                          Color(0xFFD4AF37),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Overlay to show progress
                  FractionallySizedBox(
                    widthFactor: 1 - progressPercentage,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Share button
            ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(Icons.share, size: 16),
              label: Text(
                'شارك مع العائلة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7D5A50),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**5.2 Update Profile Page**
- **File:** `DealWithPast/lib/profilePage.dart` (or relevant profile file)
- **Add:** Legacy preview widget and stats navigation

```dart
// Add this import
import '../widgets/LegacyPreviewWidget.dart';
import '../widgets/app_bottom_nav.dart'; // For navigation

// Inside profile build method, after stats cards:
LegacyPreviewWidget(
  currentProgress: 6,  // TODO: Get from user data
  totalBadges: 12,
  onTap: () {
    // Navigate to Legacy tab
    // Assuming parent widget has tab switching function
    widget.goTo(AppTab.missions); // Then switch to legacy sub-tab
  },
),

// Make stats cards tappable:
// Wrap each stat card with GestureDetector:
GestureDetector(
  onTap: () => widget.goTo(AppTab.missions), // Navigate to achievements
  child: _buildStatCard(
    icon: Icons.emoji_events,
    label: 'الإنجازات',
    // ... rest of card
  ),
),
```

**5.3 Testing Checklist:**
- [ ] Legacy preview displays on profile
- [ ] Progress bar shows correct percentage
- [ ] Tapping preview navigates to Legacy tab
- [ ] Stats cards navigate to correct tabs
- [ ] All navigation works smoothly

---

## 📦 Assets TODO List

### Priority 1: Badge Icons (Required for Phase 2)
- [ ] Upload 12 badge placeholder icons
- [ ] Organize in assets/badges/ structure
- [ ] Update pubspec.yaml with asset paths
- [ ] Test all icons load correctly

### Priority 2: Level Icons (Required for Phase 3)
- [ ] Create/upload 4 level icons
- [ ] Place in assets/levels/
- [ ] Update pubspec.yaml

### Priority 3: Mission Icons (Optional)
- [ ] Create mission category icons
- [ ] Place in assets/missions/

---

## 🔧 pubspec.yaml Updates

Add to `DealWithPast/pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies...
  share_plus: ^7.2.1  # For sharing legacy

flutter:
  assets:
    # Badge icons
    - assets/badges/foundation/
    - assets/badges/community/
    - assets/badges/legacy/

    # Level icons
    - assets/levels/

    # Mission icons (optional)
    - assets/missions/
```

---

## 📊 Progress Tracking

### Phase Completion Checklist:
- [ ] Phase 1 Complete: Mission creator info
- [ ] Phase 2 Complete: Badge system
- [ ] Phase 3 Complete: Achievements tab
- [ ] Phase 4 Complete: Legacy tab
- [ ] Phase 5 Complete: Profile integration

### Testing Milestones:
- [ ] All screens render without errors
- [ ] RTL layout works correctly
- [ ] API integration functional
- [ ] Sharing works on real devices
- [ ] Performance acceptable on low-end devices

---

## 📝 Notes & Decisions

**Design Alignment:**
- Using Figma's 3-tab structure (simpler than docs' progressive system)
- Implementing 12-badge system from documentation
- Skipping 3-stage progressive legacy (using single memorial design)
- Keeping profile legacy preview (not duplication)

**Technical Approach:**
- Start with placeholder icons, upgrade later
- Mock API data initially, integrate WordPress backend progressively
- Build UI first, add backend integration second

**Next Steps:**
1. Approve this implementation plan
2. Upload placeholder badge icons
3. Start Phase 1 completion (mission creator info)
4. Continue through phases sequentially

---

**Last Updated:** October 24, 2025
**Status:** Ready for Implementation
**Estimated Completion:** 9-13 days
