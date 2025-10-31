# Feature Branch Setup Plan
## DealWithPast Gamification System

**Created:** 2025-10-12
**Status:** Ready for Implementation
**Lead Developer:** Ziad (Lebanese Cultural Lead + WordPress Developer)
**Branch:** `feature/gamification`

---

## 1. Git Branch Strategy

### Main Branch Protection
```bash
# Current branch: main
# DO NOT commit directly to main during development
```

### Feature Branch Setup
```bash
# 1. Create and switch to feature branch
git checkout -b feature/gamification

# 2. Push to remote and set upstream
git push -u origin feature/gamification

# 3. Verify branch
git branch -vv
```

### Branch Organization
```
main (protected)
└── feature/gamification (active development)
    ├── Phase 1: Mission Discovery (Weeks 3-5)
    ├── Phase 2: Community & Achievements (Weeks 6-7)
    ├── Phase 3: Legacy & Memorial (Weeks 8-9)
    └── Phase 4: Polish & Launch (Week 10)
```

### Commit Convention
```
feat(wordpress): Add missions custom post type
feat(flutter): Implement mission discovery map
fix(api): Resolve mission query pagination bug
docs(gamification): Update API endpoint documentation
style(memorial): Adjust plaque typography per cultural review
test(achievements): Add unit tests for achievement unlock logic
```

---

## 2. WordPress Development Environment

### Local Setup Requirements
```bash
# Required on your machine:
- PHP 7.4+ (ideally 8.0+)
- MySQL 5.7+ or MariaDB 10.3+
- WordPress 6.0+ installation
- ACF Pro plugin installed
- WP REST API authentication (JWT Auth plugin)
```

### WordPress Directory Structure
```
wp-content/
├── plugins/
│   ├── advanced-custom-fields-pro/  (existing)
│   ├── jwt-authentication-for-wp-rest-api/  (existing)
│   └── dwp-gamification/  ← NEW PLUGIN WE'LL CREATE
│       ├── dwp-gamification.php
│       ├── includes/
│       │   ├── class-mission-cpt.php
│       │   ├── class-achievement-manager.php
│       │   ├── class-notification-handler.php
│       │   └── class-api-endpoints.php
│       ├── database/
│       │   └── schema.sql
│       └── admin/
│           └── views/
└── themes/
    └── [your-theme]/  (existing)
```

### Development Workflow
1. **Local WordPress site** for development/testing
2. **Staging server** for team testing (if available)
3. **Production (dwp.world)** for final deployment

---

## 3. Flutter Development Environment

### Current Setup (Verified)
```bash
Flutter 3.10.6 (Dart 3.0.6)  ← LOCKED VERSION
Platform: Windows Desktop + Chrome (web)
```

### New Dependencies to Add
```yaml
# pubspec.yaml additions (test compatibility first!)
dependencies:
  # Existing (already in project)
  firebase_auth: 4.1.1
  firebase_core: 2.4.1
  google_maps_flutter: 2.1.1

  # NEW for Gamification
  firebase_messaging: ^14.0.0  # Push notifications
  flutter_local_notifications: ^15.0.0  # Local notification display
  qr_flutter: ^4.0.0  # QR code generation for memorial plaques
  share_plus: ^7.0.0  # Share memorial plaques
  cached_network_image: ^3.2.0  # Achievement badge caching
  badges: ^3.0.0  # Notification badges on bottom nav
  confetti: ^0.7.0  # Achievement unlock celebration animation
```

### Flutter Directory Structure (New Files)
```
lib/
├── models/
│   ├── mission.dart  ← NEW
│   ├── achievement.dart  ← NEW
│   ├── follow_relationship.dart  ← NEW
│   └── memorial_plaque.dart  ← NEW
├── repositories/
│   ├── mission_repo.dart  ← NEW
│   ├── achievement_repo.dart  ← NEW
│   └── notification_repo.dart  ← NEW
├── screens/
│   ├── gamification/  ← NEW FOLDER
│   │   ├── mission_discovery_map.dart
│   │   ├── mission_detail_screen.dart
│   │   ├── mission_creation_wizard.dart
│   │   ├── achievements_screen.dart
│   │   ├── following_feed_screen.dart
│   │   └── memorial_plaque_screen.dart
├── widgets/
│   ├── gamification/  ← NEW FOLDER
│   │   ├── quest_banner.dart
│   │   ├── mission_marker.dart
│   │   ├── achievement_card.dart
│   │   ├── memorial_plaque_generator.dart
│   │   └── confetti_overlay.dart
└── services/
    ├── fcm_service.dart  ← NEW (Firebase Cloud Messaging)
    └── achievement_service.dart  ← NEW
```

---

## 4. Parallel Development Strategy

### Mock API Server (Critical!)
Since WordPress backend takes time, we'll use a **mock API server** so Flutter development can proceed in parallel.

```javascript
// mock-api/server.js (Node.js Express server)
// Run locally on localhost:3000
// Simulates all 23 WordPress REST API endpoints
// Returns realistic JSON responses

Example endpoints:
GET  /wp-json/dwp/v1/missions/nearby
POST /wp-json/dwp/v1/missions/create
GET  /wp-json/dwp/v1/achievements
POST /wp-json/dwp/v1/achievements/unlock
```

**Setup Steps:**
1. I'll create the mock API server specification
2. You can run it locally while building WordPress
3. Flutter team uses mock API until WordPress is ready
4. Swap to real API when WordPress endpoints are complete

---

## 5. Testing Strategy

### WordPress Testing
```bash
# Unit tests for PHP functions
PHPUnit tests for achievement logic

# API endpoint testing
Postman collection with all 23 endpoints
Test with mock data before Flutter integration

# Database testing
Test data migration script
Verify ACF field retrieval
```

### Flutter Testing
```bash
# Widget tests
Quest banner display logic
Mission marker clustering

# Integration tests
Mock API → Flutter data flow
Achievement unlock flow

# Manual testing
Web (Chrome) ✅
Android emulator (if available)
iOS simulator (if available)
```

### Cultural Review Checkpoints
- **Checkpoint 1:** Memorial plaque design mockup (after artist delivers assets)
- **Checkpoint 2:** Mission creation flow UX (you review before coding)
- **Checkpoint 3:** Achievement badge language/imagery (you approve all text/icons)

---

## 6. Version Control Checkpoints

### Merge to Main Criteria
```
✅ All WordPress endpoints functional
✅ Flutter app compiles on web + Android
✅ No P0/P1 bugs remaining
✅ Cultural review approved by Ziad
✅ Achievement system tested end-to-end
✅ Push notifications working
✅ Code review completed
✅ CHANGELOG.md updated
```

### Phase Completion Commits
```bash
# After Phase 1 (Mission Discovery)
git add .
git commit -m "feat(phase1): Complete mission discovery foundation"
git push origin feature/gamification

# After Phase 2 (Community & Achievements)
git add .
git commit -m "feat(phase2): Complete community building & achievements"
git push origin feature/gamification

# After Phase 3 (Legacy & Memorial)
git add .
git commit -m "feat(phase3): Complete legacy system & memorial plaque"
git push origin feature/gamification

# After Phase 4 (Polish & Launch)
git pull origin main  # Merge any main branch updates
git push origin feature/gamification
# Create Pull Request: feature/gamification → main
```

---

## 7. Communication Protocol

### Daily Standup (Async)
Post in project channel:
- **Yesterday:** What I completed
- **Today:** What I'm working on
- **Blockers:** Anything stopping progress

### Cultural Review Requests
When you need Ziad's approval:
1. Tag with `@ziad-cultural-review`
2. Include context (what, why, screenshot/mockup)
3. Wait for approval before proceeding

### WordPress ↔ Flutter Sync Points
**Every 2-3 days:** Check if API contracts still match
- WordPress: "I added field X to missions endpoint"
- Flutter: "Updated mission model to include field X"

---

## 8. Risk Mitigation

### Risk #1: WordPress Backend Delays
- **Mitigation:** Mock API server keeps Flutter moving
- **Fallback:** Prioritize critical endpoints first (missions, achievements)

### Risk #2: Flutter 3.10.6 Package Compatibility
- **Mitigation:** Test all new packages BEFORE adding to pubspec.yaml
- **Fallback:** Find alternative packages or write custom implementation

### Risk #3: Push Notification Setup Complexity
- **Mitigation:** Tackle FCM setup in Phase 2 (not Phase 1)
- **Fallback:** Use in-app notifications only if FCM blocks progress

### Risk #4: Map Performance with 100+ Missions
- **Mitigation:** Implement clustering from day 1
- **Fallback:** Pagination or "load nearby only" approach

---

## 9. Success Metrics

### Phase 1 Success (Mission Discovery)
- [ ] 50+ test missions created in WordPress
- [ ] Mission map displays all markers with clustering
- [ ] Mission detail screen shows all data
- [ ] Mission creation wizard saves to WordPress

### Phase 2 Success (Community & Achievements)
- [ ] 10+ achievements defined and unlockable
- [ ] Following system works (follow/unfollow)
- [ ] Feed shows followed users' activities
- [ ] Achievement unlock triggers confetti animation

### Phase 3 Success (Legacy & Memorial)
- [ ] Memorial plaque generator creates culturally appropriate design
- [ ] QR code links to memorial page
- [ ] Sharing works (social media + direct link)
- [ ] Memorial analytics tracked

### Phase 4 Success (Polish & Launch)
- [ ] Zero P0 bugs
- [ ] Performance < 2s load time for mission map
- [ ] Cultural review 100% approved
- [ ] App Store/Play Store submission ready

---

## Next Steps (Start Here!)

1. **Create feature branch** (5 minutes)
   ```bash
   git checkout -b feature/gamification
   git push -u origin feature/gamification
   ```

2. **Review WordPress roadmap** (I'll create next)
   - Read `WORDPRESS_DEV_ROADMAP.md`
   - Confirm WordPress environment is ready

3. **Review artist asset pipeline** (I'll create next)
   - Read `ARTIST_ASSET_PIPELINE.md`
   - Prepare asset specifications for artist

4. **Set up mock API server** (30 minutes)
   - I'll provide Node.js Express server code
   - Run locally on localhost:3000

5. **Phase 1 kickoff** (Week 3)
   - Start WordPress: Missions CPT
   - Start Flutter: Mission map screen

---

**Questions before we proceed?**
