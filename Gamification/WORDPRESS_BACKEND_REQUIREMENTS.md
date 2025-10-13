# WordPress Backend Requirements - Gamification System
**Date:** October 10, 2025
**For:** WordPress Developer / Backend Team
**Project:** DealWithPast 2-Pillar Gamification System
**Priority:** CRITICAL - All Flutter development blocked until endpoints ready

---

## Executive Summary

This document specifies all WordPress backend development required for the gamification system. The Flutter mobile app depends entirely on these REST API endpoints. **Development must start immediately to avoid blocking mobile development.**

**Estimated Development Time:** 3-4 weeks (parallel with Flutter development using mocks)
**Required WordPress Knowledge:** Custom post types, ACF, REST API, JWT Auth

---

## Current WordPress Setup

### Site Details
- **URL:** http://dwp.world
- **WordPress Version:** Unknown (needs verification)
- **Current Custom Post Types:** `stories`
- **Current Plugins:**
  - Advanced Custom Fields (ACF)
  - JWT Authentication for WP REST API
  - Better Featured Image

### Current API Endpoints (Already Working)
```
✅ POST /wp-json/jwt-auth/v1/token                  (authentication)
✅ POST /wp-json/wp/v2/users/register               (user registration)
✅ GET  /wp-json/wp/v2/stories/                     (fetch stories)
✅ POST /wp-json/wp/v2/stories/                     (create story)
```

---

## NEW Components Needed

### Overview
1. **Custom Post Type:** `missions`
2. **Custom Database Tables:** 3 tables
3. **REST API Endpoints:** 23 new endpoints
4. **ACF Field Groups:** 2 new groups
5. **Notification System:** Firebase Cloud Messaging integration
6. **Achievement Logic:** Server-side calculation hooks

---

## Part 1: Custom Post Type - Missions

### Register Custom Post Type

**File:** `wp-content/themes/{your-theme}/functions.php`
**Or:** Create custom plugin: `wp-content/plugins/dwp-gamification/`

```php
function dwp_register_missions_post_type() {
    $args = array(
        'label' => __('Missions', 'dwp'),
        'labels' => array(
            'name' => __('Missions', 'dwp'),
            'singular_name' => __('Mission', 'dwp'),
            'add_new' => __('Add New Mission', 'dwp'),
            'add_new_item' => __('Add New Mission', 'dwp'),
            'edit_item' => __('Edit Mission', 'dwp'),
            'new_item' => __('New Mission', 'dwp'),
            'view_item' => __('View Mission', 'dwp'),
            'search_items' => __('Search Missions', 'dwp'),
            'not_found' => __('No missions found', 'dwp'),
        ),
        'public' => true,
        'show_in_rest' => true,  // CRITICAL: Enable REST API
        'rest_base' => 'missions',
        'rest_controller_class' => 'WP_REST_Posts_Controller',
        'supports' => array('title', 'editor', 'author', 'thumbnail'),
        'has_archive' => true,
        'menu_icon' => 'dashicons-flag',
        'capability_type' => 'post',
        'rewrite' => array('slug' => 'missions'),
    );

    register_post_type('missions', $args);
}
add_action('init', 'dwp_register_missions_post_type');
```

---

## Part 2: ACF Field Groups

### ACF Group: Mission Details

**Create via:** WordPress Admin → Custom Fields → Add New
**Or:** Export/import JSON configuration below

```json
{
  "key": "group_mission_details",
  "title": "Mission Details",
  "fields": [
    {
      "key": "field_creator_id",
      "label": "Creator ID",
      "name": "creator_id",
      "type": "number",
      "required": 1,
      "default_value": ""
    },
    {
      "key": "field_goal_count",
      "label": "Goal Count",
      "name": "goal_count",
      "type": "number",
      "required": 1,
      "default_value": 10,
      "min": 1,
      "max": 100
    },
    {
      "key": "field_current_count",
      "label": "Current Count",
      "name": "current_count",
      "type": "number",
      "required": 0,
      "default_value": 0,
      "readonly": 1
    },
    {
      "key": "field_start_date",
      "label": "Start Date",
      "name": "start_date",
      "type": "date_picker",
      "required": 1,
      "display_format": "Y-m-d",
      "return_format": "Y-m-d"
    },
    {
      "key": "field_end_date",
      "label": "End Date",
      "name": "end_date",
      "type": "date_picker",
      "required": 0,
      "display_format": "Y-m-d",
      "return_format": "Y-m-d"
    },
    {
      "key": "field_status",
      "label": "Status",
      "name": "status",
      "type": "select",
      "required": 1,
      "choices": {
        "active": "Active",
        "completed": "Completed",
        "expired": "Expired"
      },
      "default_value": "active"
    },
    {
      "key": "field_target_area",
      "label": "Target Geographic Area",
      "name": "target_area",
      "type": "group",
      "sub_fields": [
        {
          "key": "field_region",
          "label": "Region",
          "name": "region",
          "type": "text",
          "required": 1
        },
        {
          "key": "field_center_lat",
          "label": "Center Latitude",
          "name": "center_lat",
          "type": "number",
          "required": 1
        },
        {
          "key": "field_center_lng",
          "label": "Center Longitude",
          "name": "center_lng",
          "type": "number",
          "required": 1
        },
        {
          "key": "field_radius_km",
          "label": "Radius (km)",
          "name": "radius_km",
          "type": "number",
          "required": 0,
          "default_value": 5
        },
        {
          "key": "field_neighborhoods",
          "label": "Neighborhoods",
          "name": "neighborhoods",
          "type": "text",
          "required": 0,
          "instructions": "Comma-separated neighborhood names"
        }
      ]
    },
    {
      "key": "field_target_period",
      "label": "Target Time Period",
      "name": "target_period",
      "type": "group",
      "sub_fields": [
        {
          "key": "field_start_year",
          "label": "Start Year",
          "name": "start_year",
          "type": "number",
          "required": 1,
          "min": 1975,
          "max": 1990
        },
        {
          "key": "field_end_year",
          "label": "End Year",
          "name": "end_year",
          "type": "number",
          "required": 1,
          "min": 1975,
          "max": 2000
        },
        {
          "key": "field_decade_label",
          "label": "Decade Label",
          "name": "decade_label",
          "type": "text",
          "required": 0,
          "default_value": "Early War Period"
        }
      ]
    },
    {
      "key": "field_tags",
      "label": "Tags",
      "name": "tags",
      "type": "text",
      "required": 0,
      "instructions": "Comma-separated tags (e.g., civil_war, displacement)"
    },
    {
      "key": "field_linked_story_ids",
      "label": "Linked Story IDs",
      "name": "linked_story_ids",
      "type": "text",
      "required": 0,
      "readonly": 1,
      "instructions": "Comma-separated story IDs (auto-updated)"
    }
  ],
  "location": [
    [
      {
        "param": "post_type",
        "operator": "==",
        "value": "missions"
      }
    ]
  ]
}
```

---

## Part 3: Custom Database Tables

### Table 1: wp_user_missions (Follow Relationships)

```sql
CREATE TABLE IF NOT EXISTS `wp_user_missions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `mission_id` bigint(20) unsigned NOT NULL,
  `follow_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) NOT NULL DEFAULT 'following',
  `recruitment_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_mission_unique` (`user_id`, `mission_id`),
  KEY `user_id_index` (`user_id`),
  KEY `mission_id_index` (`mission_id`),
  KEY `status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- status values: 'following', 'ambassador', 'co-creator'
```

### Table 2: wp_user_achievements

```sql
CREATE TABLE IF NOT EXISTS `wp_user_achievements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `achievement_type` varchar(50) NOT NULL,
  `unlock_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_achievement_unique` (`user_id`, `achievement_type`),
  KEY `user_id_index` (`user_id`),
  KEY `achievement_type_index` (`achievement_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- achievement_type values:
-- 'memory_keeper', 'witness', 'voice', 'mission_creator',
-- 'bridge_builder', 'network_builder', 'ambassador', 'connector',
-- 'trusted_voice', 'guardian', 'peacemaker', 'heritage_keeper', 'community_leader'
```

### Table 3: wp_notifications

```sql
CREATE TABLE IF NOT EXISTS `wp_notifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id_index` (`user_id`),
  KEY `is_read_index` (`is_read`),
  KEY `created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- type values:
-- 'mission_update', 'achievement_unlocked', 'mission_completed',
-- 'follower_joined', 'ambassador_promoted', 'story_contributed'
```

### Database Migration Script

**File:** `wp-content/plugins/dwp-gamification/dwp-install.php`

```php
<?php
function dwp_gamification_install_tables() {
    global $wpdb;

    $charset_collate = $wpdb->get_charset_collate();

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');

    // Create wp_user_missions table
    $sql_user_missions = "CREATE TABLE {$wpdb->prefix}user_missions (
        id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
        user_id bigint(20) unsigned NOT NULL,
        mission_id bigint(20) unsigned NOT NULL,
        follow_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        status varchar(20) NOT NULL DEFAULT 'following',
        recruitment_count int(11) NOT NULL DEFAULT 0,
        created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY  (id),
        UNIQUE KEY user_mission_unique (user_id, mission_id),
        KEY user_id_index (user_id),
        KEY mission_id_index (mission_id),
        KEY status_index (status)
    ) $charset_collate;";

    dbDelta($sql_user_missions);

    // Create wp_user_achievements table
    $sql_user_achievements = "CREATE TABLE {$wpdb->prefix}user_achievements (
        id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
        user_id bigint(20) unsigned NOT NULL,
        achievement_type varchar(50) NOT NULL,
        unlock_date datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        metadata longtext,
        created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY  (id),
        UNIQUE KEY user_achievement_unique (user_id, achievement_type),
        KEY user_id_index (user_id),
        KEY achievement_type_index (achievement_type)
    ) $charset_collate;";

    dbDelta($sql_user_achievements);

    // Create wp_notifications table
    $sql_notifications = "CREATE TABLE {$wpdb->prefix}notifications (
        id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
        user_id bigint(20) unsigned NOT NULL,
        type varchar(50) NOT NULL,
        title varchar(255) NOT NULL,
        message text NOT NULL,
        data longtext,
        is_read tinyint(1) NOT NULL DEFAULT 0,
        created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY  (id),
        KEY user_id_index (user_id),
        KEY is_read_index (is_read),
        KEY created_at_index (created_at)
    ) $charset_collate;";

    dbDelta($sql_notifications);

    // Store database version
    add_option('dwp_gamification_db_version', '1.0');
}

register_activation_hook(__FILE__, 'dwp_gamification_install_tables');
```

---

## Part 4: REST API Endpoints

### Namespace: `/wp-json/dwp/v1/`

All endpoints use this namespace. Authentication via JWT bearer token in header:
```
Authorization: Bearer {token}
```

---

### 1. Mission CRUD Endpoints

#### 1.1 Create Mission
```
POST /wp-json/dwp/v1/missions
```

**Request Body:**
```json
{
  "title": "Stories from Dahiye during 1980s",
  "description": "Looking for memories from the Dahiye neighborhood...",
  "creator_id": 123,
  "goal_count": 10,
  "start_date": "2025-10-10",
  "end_date": "2025-11-10",
  "status": "active",
  "target_area": {
    "region": "Beirut",
    "center_lat": 33.8547,
    "center_lng": 35.8623,
    "radius_km": 5,
    "neighborhoods": "Dahiye,Hamra"
  },
  "target_period": {
    "start_year": 1980,
    "end_year": 1989,
    "decade_label": "1980s"
  },
  "tags": "civil_war,displacement,beirut"
}
```

**Response (201 Created):**
```json
{
  "id": 456,
  "title": "Stories from Dahiye during 1980s",
  "description": "Looking for memories from the Dahiye neighborhood...",
  "creator_id": 123,
  "goal_count": 10,
  "current_count": 0,
  "start_date": "2025-10-10",
  "end_date": "2025-11-10",
  "status": "active",
  "target_area": { ... },
  "target_period": { ... },
  "tags": ["civil_war", "displacement", "beirut"],
  "follower_ids": [],
  "ambassador_ids": [],
  "linked_story_ids": [],
  "created_at": "2025-10-10T12:00:00Z"
}
```

**Implementation:**
```php
function dwp_create_mission(WP_REST_Request $request) {
    $params = $request->get_json_params();

    // Verify user is authenticated
    $current_user = wp_get_current_user();
    if (!$current_user->ID) {
        return new WP_Error('unauthorized', 'User must be logged in', array('status' => 401));
    }

    // Create mission post
    $post_id = wp_insert_post(array(
        'post_type' => 'missions',
        'post_title' => sanitize_text_field($params['title']),
        'post_content' => wp_kses_post($params['description']),
        'post_status' => 'publish',
        'post_author' => $current_user->ID,
    ));

    if (is_wp_error($post_id)) {
        return $post_id;
    }

    // Update ACF fields
    update_field('creator_id', $params['creator_id'], $post_id);
    update_field('goal_count', intval($params['goal_count']), $post_id);
    update_field('current_count', 0, $post_id);
    update_field('start_date', $params['start_date'], $post_id);
    update_field('end_date', $params['end_date'], $post_id);
    update_field('status', $params['status'], $post_id);
    update_field('target_area', $params['target_area'], $post_id);
    update_field('target_period', $params['target_period'], $post_id);
    update_field('tags', $params['tags'], $post_id);
    update_field('linked_story_ids', '', $post_id);

    // Trigger achievement check for mission_creator
    dwp_check_achievement($current_user->ID, 'mission_creator');

    return new WP_REST_Response(dwp_format_mission_response($post_id), 201);
}
```

---

#### 1.2 Get All Missions (with Filtering)
```
GET /wp-json/dwp/v1/missions
GET /wp-json/dwp/v1/missions?region=Beirut
GET /wp-json/dwp/v1/missions?decade=1980s
GET /wp-json/dwp/v1/missions?status=active
GET /wp-json/dwp/v1/missions?per_page=20&page=2
```

**Query Parameters:**
- `region` (string): Filter by target area region
- `decade` (string): Filter by time period decade_label
- `status` (string): active|completed|expired
- `creator_id` (int): Filter by mission creator
- `per_page` (int): Results per page (default 20)
- `page` (int): Page number (default 1)

**Response (200 OK):**
```json
{
  "missions": [
    {
      "id": 456,
      "title": "Stories from Dahiye during 1980s",
      ... (full mission object)
    },
    ...
  ],
  "pagination": {
    "total": 47,
    "total_pages": 3,
    "current_page": 1,
    "per_page": 20
  }
}
```

---

#### 1.3 Get Single Mission
```
GET /wp-json/dwp/v1/missions/{id}
```

**Response (200 OK):** Full mission object with linked stories

---

#### 1.4 Update Mission
```
PUT /wp-json/dwp/v1/missions/{id}
```

**Authorization:** Only mission creator or admin can update

**Request Body:** Same as create, but all fields optional

---

#### 1.5 Delete Mission
```
DELETE /wp-json/dwp/v1/missions/{id}
```

**Authorization:** Only mission creator or admin can delete

---

### 2. Follow System Endpoints

#### 2.1 Follow Mission
```
POST /wp-json/dwp/v1/missions/{id}/follow
```

**Request Body:**
```json
{
  "user_id": 123
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Successfully followed mission",
  "follow": {
    "user_id": 123,
    "mission_id": 456,
    "follow_date": "2025-10-10T12:00:00Z",
    "status": "following",
    "recruitment_count": 0
  }
}
```

**Implementation:**
```php
function dwp_follow_mission(WP_REST_Request $request) {
    global $wpdb;
    $mission_id = $request->get_param('id');
    $user_id = $request->get_param('user_id');

    // Check if already following
    $existing = $wpdb->get_row($wpdb->prepare(
        "SELECT * FROM {$wpdb->prefix}user_missions
         WHERE user_id = %d AND mission_id = %d",
        $user_id, $mission_id
    ));

    if ($existing) {
        return new WP_Error('already_following', 'User already follows this mission', array('status' => 400));
    }

    // Insert follow relationship
    $wpdb->insert(
        $wpdb->prefix . 'user_missions',
        array(
            'user_id' => $user_id,
            'mission_id' => $mission_id,
            'status' => 'following',
        ),
        array('%d', '%d', '%s')
    );

    // Create notification for mission creator
    $mission = get_post($mission_id);
    $creator_id = get_field('creator_id', $mission_id);

    dwp_create_notification($creator_id, 'follower_joined',
        'New Mission Follower',
        'Someone just followed your mission: ' . $mission->post_title,
        json_encode(array('mission_id' => $mission_id, 'follower_id' => $user_id))
    );

    return new WP_REST_Response(array(
        'success' => true,
        'message' => 'Successfully followed mission'
    ), 201);
}
```

---

#### 2.2 Unfollow Mission
```
DELETE /wp-json/dwp/v1/missions/{id}/follow?user_id={user_id}
```

---

#### 2.3 Get Mission Followers
```
GET /wp-json/dwp/v1/missions/{id}/followers
```

**Response (200 OK):**
```json
{
  "followers": [
    {
      "user_id": 123,
      "display_name": "Ahmad",
      "status": "following",
      "follow_date": "2025-10-10T12:00:00Z"
    },
    {
      "user_id": 456,
      "display_name": "Fatima",
      "status": "ambassador",
      "follow_date": "2025-10-05T10:00:00Z",
      "recruitment_count": 3
    }
  ],
  "total_followers": 12,
  "ambassadors": 2
}
```

---

#### 2.4 Get User's Followed Missions
```
GET /wp-json/dwp/v1/users/{id}/following
```

**Response (200 OK):**
```json
{
  "following": [
    {
      "mission": { ... (full mission object) },
      "follow_status": "ambassador",
      "follow_date": "2025-10-05T10:00:00Z",
      "recruitment_count": 3
    }
  ]
}
```

---

#### 2.5 Promote to Ambassador
```
POST /wp-json/dwp/v1/missions/{id}/ambassador
```

**Request Body:**
```json
{
  "user_id": 123
}
```

**Authorization:** Only mission creator can promote

**Logic:** Updates user's status from "following" to "ambassador"

**Side Effect:** Triggers "ambassador" achievement check

---

### 3. Story-Mission Linking Endpoints

#### 3.1 Link Story to Mission
```
POST /wp-json/dwp/v1/stories/{story_id}/link-mission
```

**Request Body:**
```json
{
  "mission_id": 456
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Story linked to mission",
  "mission": {
    "id": 456,
    "title": "...",
    "current_count": 8,
    "goal_count": 10
  }
}
```

**Side Effects:**
1. Increment mission's `current_count` field
2. Add story_id to mission's `linked_story_ids`
3. Check if mission is completed (current_count >= goal_count)
4. Trigger "bridge_builder" achievement for story author
5. Notify all mission followers of new contribution

---

#### 3.2 Get Mission Stories
```
GET /wp-json/dwp/v1/missions/{id}/stories
```

**Response (200 OK):**
```json
{
  "stories": [
    { ... (story object) },
    { ... (story object) }
  ],
  "total": 8,
  "goal": 10,
  "progress_percentage": 80
}
```

---

### 4. Achievement Endpoints

#### 4.1 Get User Achievements
```
GET /wp-json/dwp/v1/users/{id}/achievements
```

**Response (200 OK):**
```json
{
  "achievements": [
    {
      "type": "memory_keeper",
      "unlock_date": "2025-10-01T10:00:00Z",
      "metadata": {
        "first_story_id": 789
      }
    },
    {
      "type": "ambassador",
      "unlock_date": "2025-10-05T14:30:00Z",
      "metadata": {
        "mission_id": 456,
        "recruitment_count": 3
      }
    }
  ],
  "total_unlocked": 2,
  "category_counts": {
    "foundation": 1,
    "community": 1,
    "legacy": 0
  }
}
```

---

#### 4.2 Check & Unlock Achievement
```
POST /wp-json/dwp/v1/achievements/check
```

**Request Body:**
```json
{
  "user_id": 123,
  "achievement_type": "memory_keeper"
}
```

**Response (200 OK):**
```json
{
  "unlocked": true,
  "achievement": {
    "type": "memory_keeper",
    "unlock_date": "2025-10-10T12:00:00Z"
  },
  "is_new": true
}
```

**OR if already unlocked:**
```json
{
  "unlocked": true,
  "is_new": false
}
```

**Implementation - Achievement Logic:**
```php
function dwp_check_achievement($user_id, $achievement_type) {
    global $wpdb;

    // Check if already unlocked
    $existing = $wpdb->get_row($wpdb->prepare(
        "SELECT * FROM {$wpdb->prefix}user_achievements
         WHERE user_id = %d AND achievement_type = %s",
        $user_id, $achievement_type
    ));

    if ($existing) {
        return array('unlocked' => true, 'is_new' => false);
    }

    // Verify achievement criteria
    $criteria_met = false;

    switch ($achievement_type) {
        case 'memory_keeper':
            // First approved story
            $story_count = wp_count_posts('stories');
            $criteria_met = ($story_count->publish > 0);
            break;

        case 'trusted_voice':
            // 5+ approved stories
            $args = array(
                'post_type' => 'stories',
                'author' => $user_id,
                'post_status' => 'publish',
                'posts_per_page' => -1
            );
            $user_stories = get_posts($args);
            $criteria_met = (count($user_stories) >= 5);
            break;

        case 'network_builder':
            // Invited 3+ people who contributed
            $recruitment_count = $wpdb->get_var($wpdb->prepare(
                "SELECT SUM(recruitment_count) FROM {$wpdb->prefix}user_missions
                 WHERE user_id = %d",
                $user_id
            ));
            $criteria_met = ($recruitment_count >= 3);
            break;

        // ... (add all 14 achievement types)
    }

    if (!$criteria_met) {
        return array('unlocked' => false);
    }

    // Unlock achievement
    $wpdb->insert(
        $wpdb->prefix . 'user_achievements',
        array(
            'user_id' => $user_id,
            'achievement_type' => $achievement_type,
        ),
        array('%d', '%s')
    );

    // Create notification
    dwp_create_notification($user_id, 'achievement_unlocked',
        'New Achievement Unlocked!',
        'Congratulations! You\'ve unlocked: ' . ucwords(str_replace('_', ' ', $achievement_type)),
        json_encode(array('achievement_type' => $achievement_type))
    );

    return array('unlocked' => true, 'is_new' => true);
}
```

---

### 5. Notification Endpoints

#### 5.1 Get User Notifications
```
GET /wp-json/dwp/v1/users/{id}/notifications?per_page=20&unread_only=true
```

**Response (200 OK):**
```json
{
  "notifications": [
    {
      "id": 123,
      "type": "mission_update",
      "title": "New Story Added",
      "message": "Someone contributed to your mission: Stories from Dahiye",
      "data": {
        "mission_id": 456,
        "story_id": 789
      },
      "is_read": false,
      "created_at": "2025-10-10T12:30:00Z"
    }
  ],
  "total": 5,
  "unread_count": 3
}
```

---

#### 5.2 Mark Notifications as Read
```
POST /wp-json/dwp/v1/notifications/mark-read
```

**Request Body:**
```json
{
  "notification_ids": [123, 124, 125]
}
```

**OR mark all as read:**
```json
{
  "user_id": 123,
  "mark_all": true
}
```

---

## Part 5: WordPress Hooks & Automation

### Hook 1: Auto-update Mission Progress
```php
// When story is linked to mission, auto-increment current_count
add_action('dwp_story_linked_to_mission', 'dwp_update_mission_progress', 10, 2);

function dwp_update_mission_progress($story_id, $mission_id) {
    $current = get_field('current_count', $mission_id);
    $goal = get_field('goal_count', $mission_id);

    update_field('current_count', $current + 1, $mission_id);

    // Check if mission completed
    if ($current + 1 >= $goal) {
        update_field('status', 'completed', $mission_id);

        // Notify all followers
        global $wpdb;
        $followers = $wpdb->get_results($wpdb->prepare(
            "SELECT user_id FROM {$wpdb->prefix}user_missions WHERE mission_id = %d",
            $mission_id
        ));

        $mission = get_post($mission_id);
        foreach ($followers as $follower) {
            dwp_create_notification(
                $follower->user_id,
                'mission_completed',
                'Mission Completed! 🎉',
                'The mission "' . $mission->post_title . '" has reached its goal!',
                json_encode(array('mission_id' => $mission_id))
            );
        }

        // Award community_leader achievement to creator
        $creator_id = get_field('creator_id', $mission_id);
        dwp_check_achievement($creator_id, 'community_leader');
    }
}
```

### Hook 2: Auto-expire Missions
```php
// Daily cron to check for expired missions
add_action('dwp_daily_mission_check', 'dwp_expire_old_missions');

function dwp_expire_old_missions() {
    $args = array(
        'post_type' => 'missions',
        'posts_per_page' => -1,
        'meta_query' => array(
            array(
                'key' => 'status',
                'value' => 'active',
                'compare' => '='
            ),
            array(
                'key' => 'end_date',
                'value' => date('Y-m-d'),
                'compare' => '<',
                'type' => 'DATE'
            )
        )
    );

    $expired_missions = get_posts($args);

    foreach ($expired_missions as $mission) {
        update_field('status', 'expired', $mission->ID);
    }
}

// Schedule cron
if (!wp_next_scheduled('dwp_daily_mission_check')) {
    wp_schedule_event(time(), 'daily', 'dwp_daily_mission_check');
}
```

---

## Part 6: Firebase Cloud Messaging Integration

### Setup Required

1. **Firebase Project Setup**
   - Create Firebase project at console.firebase.google.com
   - Generate Server Key from Settings → Cloud Messaging
   - Store server key in WordPress (Settings → DWP Gamification → FCM Server Key)

2. **WordPress Plugin for FCM**

**File:** `wp-content/plugins/dwp-gamification/fcm-integration.php`

```php
<?php
function dwp_send_fcm_notification($user_id, $title, $message, $data = array()) {
    // Get user's FCM token (stored in user meta)
    $fcm_token = get_user_meta($user_id, 'fcm_token', true);

    if (!$fcm_token) {
        return false; // User hasn't registered for push notifications
    }

    // Get FCM server key from settings
    $server_key = get_option('dwp_fcm_server_key');

    $notification_data = array(
        'to' => $fcm_token,
        'notification' => array(
            'title' => $title,
            'body' => $message,
            'sound' => 'default'
        ),
        'data' => $data
    );

    $response = wp_remote_post('https://fcm.googleapis.com/fcm/send', array(
        'headers' => array(
            'Content-Type' => 'application/json',
            'Authorization' => 'key=' . $server_key
        ),
        'body' => json_encode($notification_data)
    ));

    return !is_wp_error($response);
}

// Endpoint to register FCM token
add_action('rest_api_init', function() {
    register_rest_route('dwp/v1', '/fcm/register', array(
        'methods' => 'POST',
        'callback' => 'dwp_register_fcm_token',
        'permission_callback' => function() {
            return is_user_logged_in();
        }
    ));
});

function dwp_register_fcm_token(WP_REST_Request $request) {
    $user_id = get_current_user_id();
    $fcm_token = $request->get_param('fcm_token');

    update_user_meta($user_id, 'fcm_token', sanitize_text_field($fcm_token));

    return new WP_REST_Response(array('success' => true), 200);
}
```

### Notification Triggers

1. **Mission Update:** Follower contributed story
2. **Achievement Unlocked:** User earned new badge
3. **Mission Completed:** Goal reached
4. **Ambassador Promoted:** User became ambassador
5. **Follower Joined:** Someone followed user's mission

---

## Part 7: REST API Registration

### Main Plugin File Structure

**File:** `wp-content/plugins/dwp-gamification/dwp-gamification.php`

```php
<?php
/**
 * Plugin Name: DWP Gamification
 * Description: REST API endpoints for DealWithPast gamification system
 * Version: 1.0
 * Author: DWP Team
 */

// Include files
require_once plugin_dir_path(__FILE__) . 'dwp-install.php';
require_once plugin_dir_path(__FILE__) . 'fcm-integration.php';
require_once plugin_dir_path(__FILE__) . 'achievement-logic.php';

// Register all REST API routes
add_action('rest_api_init', 'dwp_register_all_routes');

function dwp_register_all_routes() {
    $namespace = 'dwp/v1';

    // MISSION CRUD
    register_rest_route($namespace, '/missions', array(
        array(
            'methods' => 'GET',
            'callback' => 'dwp_get_missions',
            'permission_callback' => '__return_true'
        ),
        array(
            'methods' => 'POST',
            'callback' => 'dwp_create_mission',
            'permission_callback' => function() {
                return is_user_logged_in();
            }
        )
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)', array(
        'methods' => 'GET',
        'callback' => 'dwp_get_mission',
        'permission_callback' => '__return_true'
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)', array(
        'methods' => 'PUT',
        'callback' => 'dwp_update_mission',
        'permission_callback' => 'dwp_can_edit_mission'
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)', array(
        'methods' => 'DELETE',
        'callback' => 'dwp_delete_mission',
        'permission_callback' => 'dwp_can_edit_mission'
    ));

    // FOLLOW SYSTEM
    register_rest_route($namespace, '/missions/(?P<id>\d+)/follow', array(
        'methods' => 'POST',
        'callback' => 'dwp_follow_mission',
        'permission_callback' => function() {
            return is_user_logged_in();
        }
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)/follow', array(
        'methods' => 'DELETE',
        'callback' => 'dwp_unfollow_mission',
        'permission_callback' => function() {
            return is_user_logged_in();
        }
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)/followers', array(
        'methods' => 'GET',
        'callback' => 'dwp_get_mission_followers',
        'permission_callback' => '__return_true'
    ));

    register_rest_route($namespace, '/users/(?P<id>\d+)/following', array(
        'methods' => 'GET',
        'callback' => 'dwp_get_user_following',
        'permission_callback' => '__return_true'
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)/ambassador', array(
        'methods' => 'POST',
        'callback' => 'dwp_promote_ambassador',
        'permission_callback' => 'dwp_is_mission_creator'
    ));

    // STORY-MISSION LINKING
    register_rest_route($namespace, '/stories/(?P<id>\d+)/link-mission', array(
        'methods' => 'POST',
        'callback' => 'dwp_link_story_to_mission',
        'permission_callback' => function() {
            return is_user_logged_in();
        }
    ));

    register_rest_route($namespace, '/missions/(?P<id>\d+)/stories', array(
        'methods' => 'GET',
        'callback' => 'dwp_get_mission_stories',
        'permission_callback' => '__return_true'
    ));

    // ACHIEVEMENTS
    register_rest_route($namespace, '/users/(?P<id>\d+)/achievements', array(
        'methods' => 'GET',
        'callback' => 'dwp_get_user_achievements',
        'permission_callback' => '__return_true'
    ));

    register_rest_route($namespace, '/achievements/check', array(
        'methods' => 'POST',
        'callback' => 'dwp_check_achievement_endpoint',
        'permission_callback' => function() {
            return is_user_logged_in();
        }
    ));

    // NOTIFICATIONS
    register_rest_route($namespace, '/users/(?P<id>\d+)/notifications', array(
        'methods' => 'GET',
        'callback' => 'dwp_get_user_notifications',
        'permission_callback' => function($request) {
            $user_id = $request->get_param('id');
            return get_current_user_id() == $user_id;
        }
    ));

    register_rest_route($namespace, '/notifications/mark-read', array(
        'methods' => 'POST',
        'callback' => 'dwp_mark_notifications_read',
        'permission_callback' => function() {
            return is_user_logged_in();
        }
    ));
}
```

---

## Part 8: Testing Checklist

### Endpoint Testing

Use Postman or similar tool to test each endpoint:

**Setup:**
1. Get JWT token: `POST /wp-json/jwt-auth/v1/token`
2. Add to headers: `Authorization: Bearer {token}`

**Mission CRUD:**
- [ ] Create mission (POST /missions)
- [ ] Get all missions (GET /missions)
- [ ] Filter by region (GET /missions?region=Beirut)
- [ ] Get single mission (GET /missions/123)
- [ ] Update mission (PUT /missions/123)
- [ ] Delete mission (DELETE /missions/123)

**Follow System:**
- [ ] Follow mission (POST /missions/123/follow)
- [ ] Unfollow mission (DELETE /missions/123/follow)
- [ ] Get followers (GET /missions/123/followers)
- [ ] Get user's following (GET /users/123/following)
- [ ] Promote ambassador (POST /missions/123/ambassador)

**Story Linking:**
- [ ] Link story to mission (POST /stories/789/link-mission)
- [ ] Get mission stories (GET /missions/123/stories)
- [ ] Verify current_count increments

**Achievements:**
- [ ] Get user achievements (GET /users/123/achievements)
- [ ] Check achievement (POST /achievements/check)
- [ ] Verify auto-unlock on story creation

**Notifications:**
- [ ] Get notifications (GET /users/123/notifications)
- [ ] Mark as read (POST /notifications/mark-read)

---

## Part 9: Development Timeline

### Week 1: Foundation
- [ ] Register missions custom post type
- [ ] Create ACF field groups
- [ ] Create database tables (migration script)
- [ ] Set up plugin structure

### Week 2: Core Endpoints
- [ ] Mission CRUD endpoints (5 endpoints)
- [ ] Follow system endpoints (5 endpoints)
- [ ] Story linking endpoints (2 endpoints)

### Week 3: Gamification Logic
- [ ] Achievement system (2 endpoints)
- [ ] Achievement checking logic (14 types)
- [ ] Notification system (2 endpoints)
- [ ] Firebase Cloud Messaging integration

### Week 4: Testing & Documentation
- [ ] Test all endpoints with Postman
- [ ] Fix bugs
- [ ] Write API documentation
- [ ] Coordinate with Flutter team for integration

---

## Part 10: Security Considerations

### Authentication
- ✅ All write endpoints require JWT authentication
- ✅ Users can only edit/delete their own missions
- ✅ Permission callbacks on all routes

### Data Validation
- [ ] Sanitize all text inputs: `sanitize_text_field()`
- [ ] Validate email addresses: `is_email()`
- [ ] Escape HTML output: `esc_html()`
- [ ] Use prepared statements for SQL queries

### Rate Limiting
- [ ] Consider rate limiting for mission creation (max 5/day per user)
- [ ] Prevent spam following/unfollowing
- [ ] Limit notification creation

---

## Support & Questions

**WordPress Developer Contact:**
- Name: [To be filled]
- Email: [To be filled]
- Availability: [To be filled]

**Questions to Address:**
1. Which WordPress version is running on dwp.world?
2. Do you have ACF Pro or ACF Free?
3. Do you prefer custom plugin or functions.php?
4. Are you comfortable with FCM integration?
5. What is your estimated timeline?

---

**Document Status:** ✅ Complete
**Last Updated:** October 10, 2025
**Next Document:** Data Models & Phased Rollout Plan
