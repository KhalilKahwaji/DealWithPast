// ignore_for_file: file_names

import 'BadgeClass.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BadgeRepo {
  // Static badge definitions (12 badges)
  static final List<Badge> allBadges = [
    // ====================
    // FOUNDATION BADGES (3)
    // ====================

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

    // ====================
    // COMMUNITY BADGES (4)
    // ====================

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

    // ====================
    // LEGACY BADGES (5)
    // ====================

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

  // Get all badges (with default locked state)
  static List<Badge> getAllBadges() {
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

  // Get badge by ID
  static Badge? getBadgeById(String id) {
    try {
      return allBadges.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // Fetch user's badge progress from WordPress API
  Future<List<Badge>> getUserBadges(int userId, String? token) async {
    try {
      final response = await http.get(
        Uri.parse('https://dwp.world/wp-json/dwp/v1/users/$userId/badges'),
        headers: {
          "connection": "keep-alive",
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Merge API data with static badge definitions
        List<Badge> userBadges = [];

        for (var badge in allBadges) {
          // Find matching badge data from API
          var apiData = (data as List).firstWhere(
            (item) => item['id'] == badge.id,
            orElse: () => null,
          );

          if (apiData != null) {
            // Update badge with user progress
            userBadges.add(badge.copyWith(
              isUnlocked: apiData['is_unlocked'] ?? false,
              currentProgress: apiData['current_progress'] ?? 0,
              unlockedAt: apiData['unlocked_at'] != null
                  ? DateTime.parse(apiData['unlocked_at'])
                  : null,
            ));
          } else {
            // Badge not yet tracked, use default
            userBadges.add(badge);
          }
        }

        return userBadges;
      } else {
        print('Error fetching user badges: ${response.statusCode}');
        // Return default badges if API fails
        return allBadges;
      }
    } catch (e) {
      print('Exception fetching user badges: $e');
      // Return default badges if network error
      return allBadges;
    }
  }
}
