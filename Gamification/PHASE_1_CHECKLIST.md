# Phase 1 Implementation Checklist
## Mission Discovery Foundation (Weeks 3-5)

**Goal:** Build the foundation for mission discovery on the map
**Developer:** Ziad (WordPress) + Flutter Team
**Status:** Ready to Start

---

## Pre-Phase Setup (Week 2 - Current Week)

### Git & Environment
- [ ] Create `feature/gamification` branch
  ```bash
  git checkout -b feature/gamification
  git push -u origin feature/gamification
  ```
- [ ] Verify Flutter 3.10.6 installed and active
  ```bash
  flutter --version  # Should show 3.10.6
  ```
- [ ] WordPress local environment ready (XAMPP/MAMP/LocalWP)
- [ ] WordPress admin access verified (dwp.world or local)
- [ ] Postman installed and configured

### Documentation Review
- [ ] Read `FEATURE_SETUP_PLAN.md`
- [ ] Read `WORDPRESS_DEV_ROADMAP.md`
- [ ] Read `WORDPRESS_BACKEND_REQUIREMENTS.md` (from Oct 10)
- [ ] Review `TECHNICAL_ARCHITECTURE_ANALYSIS.md` (from Oct 10)

### Artist Assets (Phase 1 Priority)
- [ ] Commission artist/designer
- [ ] Send Artist Brief (from `ARTIST_ASSET_PIPELINE.md`)
- [ ] Request Phase 1 assets (5 mission icons + 3 achievement badges + quest banner)
- [ ] Set delivery date: End of Week 2

### Mock API Server (Optional but Recommended)
- [ ] Set up Node.js Express mock server (I can provide code)
- [ ] Configure mock endpoints for Phase 1:
  - `GET /wp-json/dwp/v1/missions/nearby`
  - `GET /wp-json/dwp/v1/missions/:id`
  - `POST /wp-json/dwp/v1/missions/start`
  - `POST /wp-json/dwp/v1/missions/complete`
  - `GET /wp-json/dwp/v1/missions/my-missions`
- [ ] Test mock server returns realistic JSON

---

## Week 3: WordPress Backend Foundation

### Day 1-2: Plugin Structure (10 hours)

#### Task 1.1: Create Plugin Directory
- [ ] Create folder: `wp-content/plugins/dwp-gamification/`
- [ ] Create main plugin file: `dwp-gamification.php`
- [ ] Add plugin header comment block
- [ ] Create folder structure:
  ```
  dwp-gamification/
  ├── dwp-gamification.php
  ├── includes/
  │   ├── class-mission-cpt.php
  │   ├── class-api-endpoints.php
  │   ├── class-achievement-manager.php
  │   └── class-notification-handler.php
  ├── database/
  │   └── schema.php
  └── admin/
      └── views/
  ```
- [ ] Add activation hook
- [ ] Add plugin initialization code
- [ ] Test: Activate plugin via WP Admin (no errors)

#### Task 1.2: Custom Post Type - Missions
- [ ] Create `includes/class-mission-cpt.php`
- [ ] Register `mission` custom post type
- [ ] Configure post type supports (title, editor, author, thumbnail)
- [ ] Enable REST API (`show_in_rest => true`)
- [ ] Test: Create test mission via WP Admin
- [ ] Test: View mission in REST API `/wp-json/wp/v2/mission`

#### Task 1.3: ACF Fields for Missions
- [ ] Register ACF field group `group_mission_details`
- [ ] Add field: `latitude` (number, required)
- [ ] Add field: `longitude` (number, required)
- [ ] Add field: `address` (text)
- [ ] Add field: `story_id` (post_object, links to story CPT)
- [ ] Add field: `difficulty` (select: easy/medium/hard)
- [ ] Add field: `mission_type` (select: visit/interview/photograph/research/memorial)
- [ ] Add field: `completion_count` (number, default 0, readonly)
- [ ] Add field: `is_active` (true_false, default true)
- [ ] Test: Edit mission, verify all fields save correctly
- [ ] Test: Check fields appear in REST API response

### Day 3: Database Tables (4 hours)

#### Task 1.4: Create Database Schema
- [ ] Create `database/schema.php`
- [ ] Write function `dwp_create_gamification_tables()`
- [ ] Create table: `wp_user_missions`
  - Fields: id, user_id, mission_id, status, started_at, completed_at, progress, proof_media
  - Indexes: user_id, mission_id, status
  - Unique key: (user_id, mission_id)
- [ ] Create table: `wp_user_achievements`
  - Fields: id, user_id, achievement_slug, unlocked_at, notification_sent
  - Indexes: user_id, achievement_slug
  - Unique key: (user_id, achievement_slug)
- [ ] Create table: `wp_dwp_notifications`
  - Fields: id, user_id, type, title, body, data, read_status, sent_at, fcm_sent
  - Indexes: user_id, type, read_status
- [ ] Hook schema function to plugin activation
- [ ] Test: Deactivate and reactivate plugin
- [ ] Test: Verify tables created in phpMyAdmin
- [ ] Test: Manually insert/select records to verify schema

### Day 4-5: Create Test Data (4 hours)

#### Task 1.5: Populate Test Missions
- [ ] Create 10 test missions in Beirut area
  - Mission 1: "Visit Martyrs' Square" (lat: 33.8938, lng: 35.5018)
  - Mission 2: "Photograph National Museum" (lat: 33.8869, lng: 35.5161)
  - Mission 3: "Interview Elder at Hamra" (lat: 33.8977, lng: 35.4814)
  - [Continue with 7 more diverse missions...]
- [ ] Assign different mission types to each
- [ ] Assign different difficulty levels
- [ ] Upload placeholder thumbnail images
- [ ] Link missions to existing stories (if available)
- [ ] Test: View all missions in WP Admin
- [ ] Test: GET `/wp-json/wp/v2/mission` returns all missions

**Checkpoint:** WordPress Foundation Complete
- [ ] Plugin activated successfully
- [ ] Custom post type registered
- [ ] ACF fields working
- [ ] Database tables created
- [ ] 10 test missions created
- [ ] No PHP errors in WP debug log

---

## Week 4: Mission API Endpoints

### Day 1-2: Nearby Missions Endpoint (6 hours)

#### Task 1.6: Implement Haversine Distance Query
- [ ] Create `includes/class-api-endpoints.php`
- [ ] Add constructor with REST API init hook
- [ ] Register route: `GET /dwp/v1/missions/nearby`
  - Parameters: lat (required), lng (required), radius (default 10km)
- [ ] Implement `get_nearby_missions()` callback
- [ ] Write Haversine formula SQL query
- [ ] Fetch ACF fields for each mission
- [ ] Format response JSON
- [ ] Test with Postman:
  ```bash
  GET https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=10
  ```
- [ ] Expected: Returns 10 missions sorted by distance
- [ ] Test edge cases:
  - [ ] Large radius (100km)
  - [ ] Small radius (1km)
  - [ ] Location with no nearby missions
  - [ ] Invalid lat/lng values

### Day 2-3: Mission Details Endpoint (3 hours)

#### Task 1.7: Get Mission Details
- [ ] Register route: `GET /dwp/v1/missions/:id`
- [ ] Implement `get_mission_details()` callback
- [ ] Fetch mission post by ID
- [ ] Return 404 if not found or not mission type
- [ ] Include all ACF fields in response
- [ ] Check current user's mission status (started/completed/not_started)
- [ ] Include user progress percentage
- [ ] Test with Postman:
  ```bash
  GET https://dwp.world/wp-json/dwp/v1/missions/123
  Headers: Authorization: Bearer YOUR_JWT_TOKEN
  ```
- [ ] Test edge cases:
  - [ ] Invalid mission ID
  - [ ] Draft mission (should not return)
  - [ ] Mission without authentication (should work)

### Day 3-4: Start Mission Endpoint (2 hours)

#### Task 1.8: Start Mission Tracking
- [ ] Register route: `POST /dwp/v1/missions/start`
  - Parameters: mission_id (required)
- [ ] Implement `start_mission()` callback
- [ ] Check authentication (user must be logged in)
- [ ] Check if mission already started
- [ ] Insert record into `wp_user_missions` table
- [ ] Set status = 'active', progress = 0
- [ ] Return success message
- [ ] Test with Postman:
  ```bash
  POST https://dwp.world/wp-json/dwp/v1/missions/start
  Headers: Authorization: Bearer YOUR_JWT_TOKEN
  Body: {"mission_id": 123}
  ```
- [ ] Test edge cases:
  - [ ] Start same mission twice (should error)
  - [ ] Start without authentication (should error 401)
  - [ ] Start with invalid mission_id

### Day 4-5: Complete Mission & My Missions Endpoints (5 hours)

#### Task 1.9: Complete Mission
- [ ] Register route: `POST /dwp/v1/missions/complete`
  - Parameters: mission_id (required), proof_media (optional, JSON array)
- [ ] Implement `complete_mission()` callback
- [ ] Update `wp_user_missions` record:
  - status = 'completed'
  - completed_at = current timestamp
  - progress = 100
  - proof_media = JSON array of image URLs
- [ ] Increment mission's `completion_count` ACF field
- [ ] Fire action hook: `do_action('dwp_mission_completed', $user_id, $mission_id)`
- [ ] Return success message
- [ ] Test with Postman:
  ```bash
  POST https://dwp.world/wp-json/dwp/v1/missions/complete
  Headers: Authorization: Bearer YOUR_JWT_TOKEN
  Body: {
    "mission_id": 123,
    "proof_media": ["https://example.com/photo1.jpg"]
  }
  ```
- [ ] Test edge cases:
  - [ ] Complete mission not started (should error)
  - [ ] Complete same mission twice (should error)

#### Task 1.10: Get User's Missions
- [ ] Register route: `GET /dwp/v1/missions/my-missions`
- [ ] Implement `get_user_missions()` callback
- [ ] Query `wp_user_missions` for current user
- [ ] Join with missions CPT to get mission details
- [ ] Sort by started_at DESC (most recent first)
- [ ] Return array of missions with status/progress
- [ ] Test with Postman:
  ```bash
  GET https://dwp.world/wp-json/dwp/v1/missions/my-missions
  Headers: Authorization: Bearer YOUR_JWT_TOKEN
  ```
- [ ] Expected: Returns user's active and completed missions

**Checkpoint:** Mission API Complete
- [ ] All 5 endpoints functional
- [ ] Postman collection created with all tests
- [ ] Authentication working (JWT)
- [ ] Error handling tested
- [ ] Response format documented

---

## Week 5: Achievement System Backend

### Day 1-2: Achievement Manager (6 hours)

#### Task 1.11: Define Achievements
- [ ] Create `includes/class-achievement-manager.php`
- [ ] Add constructor
- [ ] Create `define_achievements()` method
- [ ] Define 7 achievements in array:
  - first_mission (1 mission completed)
  - five_missions (5 missions)
  - ten_missions (10 missions)
  - first_memorial (1 memorial created)
  - story_teller (3 stories created)
  - community_builder (10 followers)
  - guardian (25 missions)
- [ ] Include: title, description, icon URL, criteria
- [ ] Test: var_dump achievements array

#### Task 1.12: Achievement Unlock Logic
- [ ] Create `unlock_achievement($user_id, $achievement_slug)` method
- [ ] Check if achievement already unlocked (query `wp_user_achievements`)
- [ ] If not unlocked, insert record
- [ ] Set unlocked_at timestamp
- [ ] Call notification method
- [ ] Return true/false
- [ ] Test manually:
  ```php
  $manager = new DWP_Achievement_Manager();
  $manager->unlock_achievement(1, 'first_mission');
  ```
- [ ] Verify record inserted in database

#### Task 1.13: Mission Completion Hook
- [ ] Add action: `add_action('dwp_mission_completed', array($this, 'check_mission_achievements'), 10, 2)`
- [ ] Implement `check_mission_achievements($user_id, $mission_id)` method
- [ ] Query count of user's completed missions
- [ ] Check thresholds:
  - 1 mission → unlock 'first_mission'
  - 5 missions → unlock 'five_missions'
  - 10 missions → unlock 'ten_missions'
  - 25 missions → unlock 'guardian'
- [ ] Test: Complete a mission, verify achievement unlocks automatically

### Day 3: Achievement Notification (3 hours)

#### Task 1.14: Achievement Notification
- [ ] Create `send_achievement_notification($user_id, $achievement)` method
- [ ] Insert record into `wp_dwp_notifications` table
- [ ] Set type = 'achievement_unlocked'
- [ ] Set title = "Achievement Unlocked!"
- [ ] Set body = achievement title + description
- [ ] Set data = JSON with achievement details
- [ ] Test: Unlock achievement, verify notification created
- [ ] Test: Query notifications table to confirm

### Day 4: Achievement API Endpoint (2 hours)

#### Task 1.15: Get Achievements Endpoint
- [ ] Add to `class-api-endpoints.php`
- [ ] Register route: `GET /dwp/v1/achievements`
- [ ] Implement `get_user_achievements()` callback
- [ ] Query user's unlocked achievements from database
- [ ] Merge with defined achievements (add details)
- [ ] Return array with:
  - Unlocked achievements (with unlock timestamp)
  - Locked achievements (with progress toward unlock)
- [ ] Test with Postman:
  ```bash
  GET https://dwp.world/wp-json/dwp/v1/achievements
  Headers: Authorization: Bearer YOUR_JWT_TOKEN
  ```
- [ ] Expected: Returns all achievements, marked unlocked/locked

### Day 5: Integration Testing (3 hours)

#### Task 1.16: End-to-End Achievement Flow
- [ ] Test full flow:
  1. Start mission (POST /missions/start)
  2. Complete mission (POST /missions/complete)
  3. Check achievements (GET /achievements)
  4. Verify "First Steps" unlocked
- [ ] Test multi-mission flow:
  1. Complete 5 missions
  2. Verify "Explorer" unlocked
  3. Check notification created
- [ ] Test edge cases:
  - [ ] Achievement doesn't unlock twice
  - [ ] Progress calculation correct (3/5 missions)
- [ ] Document any bugs in BUGS.md

**Checkpoint:** Achievement System Complete
- [ ] 7 achievements defined
- [ ] Auto-unlock on mission completion working
- [ ] Notifications generated
- [ ] GET /achievements endpoint functional
- [ ] End-to-end tested

---

## Phase 1 Completion Checklist

### WordPress Backend (All Tasks)
- [ ] Plugin created and activated
- [ ] Custom post type: `mission` registered
- [ ] ACF fields: 9 fields configured
- [ ] Database tables: 3 tables created
- [ ] Test data: 10 missions created
- [ ] API endpoints: 6 endpoints functional
  - [ ] GET /missions/nearby
  - [ ] GET /missions/:id
  - [ ] POST /missions/start
  - [ ] POST /missions/complete
  - [ ] GET /missions/my-missions
  - [ ] GET /achievements
- [ ] Achievement system: 7 achievements defined
- [ ] Achievement auto-unlock working
- [ ] Notifications: Database table + logic

### Testing & Documentation
- [ ] Postman collection created with all endpoints
- [ ] All endpoints tested with JWT authentication
- [ ] Error handling verified
- [ ] Edge cases tested
- [ ] WORDPRESS_BACKEND_REQUIREMENTS.md updated with any changes
- [ ] Code commented and readable
- [ ] No PHP errors in WP debug log

### Artist Assets (Phase 1)
- [ ] Mission type icons received (5 SVG icons)
- [ ] Achievement badges Tier 1 received (3 badges, @1x/2x/3x)
- [ ] Quest banner backgrounds received (3 variants)
- [ ] Assets uploaded to WordPress Media Library
- [ ] Asset URLs documented

### Git & Deployment
- [ ] All changes committed to `feature/gamification` branch
- [ ] Commit messages follow convention (feat/fix/docs)
- [ ] Code pushed to remote repository
- [ ] CHANGELOG.md updated with Phase 1 completion
- [ ] No merge conflicts with main branch

### Handoff to Flutter Team
- [ ] API documentation shared (endpoints + response formats)
- [ ] Postman collection exported and shared
- [ ] Test user accounts created (for Flutter testing)
- [ ] Mock API server updated to match real API responses (if used)
- [ ] Flutter team notified: "Phase 1 backend ready for integration"

---

## Phase 1 Success Criteria

### Functional Requirements
✅ **Mission Discovery:**
- User can query nearby missions by location
- Missions return accurate distance calculation
- Mission details include all required fields

✅ **Mission Tracking:**
- User can start a mission (status tracked)
- User can complete a mission (proof_media saved)
- Mission completion count increments

✅ **Achievement System:**
- Achievements auto-unlock on mission completion
- Achievement unlock triggers notification
- User can view all achievements (locked/unlocked)

### Technical Requirements
✅ **API Quality:**
- All endpoints return proper JSON format
- JWT authentication enforced
- Error responses follow REST standards (404, 400, 401, 500)

✅ **Database Integrity:**
- No orphaned records
- Foreign key relationships respected
- Unique constraints prevent duplicates

✅ **Performance:**
- Nearby missions query < 500ms (for 50 results)
- No N+1 query problems
- ACF fields efficiently loaded

---

## Troubleshooting Guide

### Issue: Plugin won't activate
- **Check:** PHP version (7.4+ required)
- **Check:** WordPress version (6.0+ required)
- **Check:** Syntax errors in PHP files
- **Solution:** Enable WP_DEBUG in wp-config.php, check error logs

### Issue: ACF fields not appearing
- **Check:** ACF Pro installed and activated
- **Check:** Field group location rules correct (post_type = mission)
- **Solution:** Flush rewrite rules (Settings > Permalinks > Save)

### Issue: REST API returns 404
- **Check:** Permalink structure (must be "Post name" not "Plain")
- **Check:** .htaccess file writable
- **Solution:** Go to Settings > Permalinks, click Save

### Issue: JWT authentication fails
- **Check:** JWT plugin installed and configured
- **Check:** .htaccess has JWT rewrite rules
- **Check:** HTTP Authorization header enabled
- **Solution:** Test with: `curl -X POST https://dwp.world/wp-json/jwt-auth/v1/token -d '{"username":"test","password":"test"}'`

### Issue: Nearby missions returns empty
- **Check:** Test missions have latitude/longitude ACF fields filled
- **Check:** SQL query not throwing errors (check WP debug log)
- **Check:** Radius parameter large enough
- **Solution:** Manually query database to verify data exists

---

## Daily Standup Template (Copy-paste for each day)

```
### Phase 1 - Day [X] Update

**Completed:**
- [ ] Task X.X: [Task name]
- [ ] Tested: [What was tested]

**In Progress:**
- [ ] Task X.X: [Task name] (75% done)

**Next:**
- [ ] Task X.X: [Next task]

**Blockers:**
- [None / Describe blocker]

**Notes:**
- [Any important findings, decisions, or questions]
```

---

## Ready to Start?

**Pre-flight Checklist:**
- [ ] This checklist printed or open in browser
- [ ] WordPress environment running
- [ ] Code editor open
- [ ] Postman ready
- [ ] CHANGELOG.md open (for logging progress)
- [ ] BUGS.md ready (for logging issues)
- [ ] Coffee/tea prepared ☕

**Start with:** Week 3, Day 1, Task 1.1 - Create Plugin Directory

---

**Need help?** Ping me in Slack/Discord with:
1. What task you're on
2. What error you're seeing (paste error message)
3. What you've tried already

Let's build this! 🚀
