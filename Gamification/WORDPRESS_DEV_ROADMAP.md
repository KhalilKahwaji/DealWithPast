# WordPress Development Roadmap
## DealWithPast Gamification Backend

**Developer:** Ziad (Lebanese Cultural Lead)
**Estimated Time:** 120-160 hours (15-20 hours/week = 8-10 weeks)
**Environment:** dwp.world WordPress installation

---

## Prerequisites Checklist

### Before Starting Development
- [ ] **WordPress Access Verified**
  - Admin credentials for dwp.world
  - FTP/SFTP access (for plugin installation)
  - phpMyAdmin or database access
  - WP-CLI access (optional but helpful)

- [ ] **Required Plugins Installed**
  - [ ] Advanced Custom Fields (ACF) Pro ← Already installed
  - [ ] JWT Authentication for WP REST API ← Already installed
  - [ ] WP REST API Cache (optional, for performance)
  - [ ] Query Monitor (for debugging)

- [ ] **Local Development Environment**
  - [ ] Local WordPress installation (XAMPP/MAMP/LocalWP)
  - [ ] Git configured on local machine
  - [ ] Code editor (VS Code recommended)
  - [ ] Postman or Insomnia (for API testing)

- [ ] **Backup & Safety**
  - [ ] Full WordPress database backup
  - [ ] Full WordPress files backup
  - [ ] Staging site available (if not, develop locally first)

---

## Phase 1: Mission Discovery Foundation (Weeks 3-5)

### Week 3: Custom Post Type & Database

#### Task 1.1: Create DWP Gamification Plugin (4 hours)
**File:** `wp-content/plugins/dwp-gamification/dwp-gamification.php`

```php
<?php
/**
 * Plugin Name: DWP Gamification
 * Description: Gamification system for DealWithPast - Missions, Achievements, Memorials
 * Version: 1.0.0
 * Author: Ziad
 * Text Domain: dwp-gamification
 */

// Prevent direct access
if (!defined('ABSPATH')) exit;

// Plugin constants
define('DWP_GAMIFICATION_VERSION', '1.0.0');
define('DWP_GAMIFICATION_PATH', plugin_dir_path(__FILE__));
define('DWP_GAMIFICATION_URL', plugin_dir_url(__FILE__));

// Include files
require_once DWP_GAMIFICATION_PATH . 'includes/class-mission-cpt.php';
require_once DWP_GAMIFICATION_PATH . 'includes/class-api-endpoints.php';
require_once DWP_GAMIFICATION_PATH . 'includes/class-achievement-manager.php';
require_once DWP_GAMIFICATION_PATH . 'includes/class-notification-handler.php';

// Activation hook
register_activation_hook(__FILE__, 'dwp_gamification_activate');
function dwp_gamification_activate() {
    require_once DWP_GAMIFICATION_PATH . 'database/schema.php';
    dwp_create_gamification_tables();
    flush_rewrite_rules();
}

// Initialize plugin
add_action('plugins_loaded', 'dwp_gamification_init');
function dwp_gamification_init() {
    // Initialize custom post type
    new DWP_Mission_CPT();

    // Initialize API endpoints
    new DWP_API_Endpoints();

    // Initialize achievement manager
    new DWP_Achievement_Manager();

    // Initialize notification handler
    new DWP_Notification_Handler();
}
```

**Deliverable:** Plugin activated successfully, no errors

---

#### Task 1.2: Create Missions Custom Post Type (6 hours)
**File:** `wp-content/plugins/dwp-gamification/includes/class-mission-cpt.php`

```php
<?php
class DWP_Mission_CPT {
    public function __construct() {
        add_action('init', array($this, 'register_mission_cpt'));
        add_action('acf/init', array($this, 'register_mission_fields'));
    }

    public function register_mission_cpt() {
        register_post_type('mission', array(
            'labels' => array(
                'name' => 'Missions',
                'singular_name' => 'Mission',
                'add_new' => 'Add New Mission',
                'edit_item' => 'Edit Mission',
            ),
            'public' => true,
            'has_archive' => false,
            'show_in_rest' => true, // Enable REST API
            'supports' => array('title', 'editor', 'author', 'thumbnail'),
            'menu_icon' => 'dashicons-location-alt',
            'capability_type' => 'post',
            'map_meta_cap' => true,
        ));
    }

    public function register_mission_fields() {
        if (function_exists('acf_add_local_field_group')) {
            acf_add_local_field_group(array(
                'key' => 'group_mission_details',
                'title' => 'Mission Details',
                'fields' => array(
                    // Location
                    array(
                        'key' => 'field_mission_latitude',
                        'label' => 'Latitude',
                        'name' => 'latitude',
                        'type' => 'number',
                        'required' => 1,
                        'step' => 0.000001,
                    ),
                    array(
                        'key' => 'field_mission_longitude',
                        'label' => 'Longitude',
                        'name' => 'longitude',
                        'type' => 'number',
                        'required' => 1,
                        'step' => 0.000001,
                    ),
                    array(
                        'key' => 'field_mission_address',
                        'label' => 'Address',
                        'name' => 'address',
                        'type' => 'text',
                    ),

                    // Story details
                    array(
                        'key' => 'field_mission_story_id',
                        'label' => 'Linked Story',
                        'name' => 'story_id',
                        'type' => 'post_object',
                        'post_type' => array('story'), // Assuming 'story' CPT exists
                    ),
                    array(
                        'key' => 'field_mission_difficulty',
                        'label' => 'Difficulty',
                        'name' => 'difficulty',
                        'type' => 'select',
                        'choices' => array(
                            'easy' => 'Easy',
                            'medium' => 'Medium',
                            'hard' => 'Hard',
                        ),
                        'default_value' => 'easy',
                    ),
                    array(
                        'key' => 'field_mission_type',
                        'label' => 'Mission Type',
                        'name' => 'mission_type',
                        'type' => 'select',
                        'choices' => array(
                            'visit' => 'Visit Location',
                            'interview' => 'Interview Elder',
                            'photograph' => 'Photograph Site',
                            'research' => 'Research Archive',
                            'memorial' => 'Create Memorial',
                        ),
                        'default_value' => 'visit',
                    ),

                    // Completion tracking
                    array(
                        'key' => 'field_mission_completion_count',
                        'label' => 'Completion Count',
                        'name' => 'completion_count',
                        'type' => 'number',
                        'default_value' => 0,
                        'readonly' => 1,
                    ),
                    array(
                        'key' => 'field_mission_active',
                        'label' => 'Active',
                        'name' => 'is_active',
                        'type' => 'true_false',
                        'default_value' => 1,
                    ),
                ),
                'location' => array(
                    array(
                        array(
                            'param' => 'post_type',
                            'operator' => '==',
                            'value' => 'mission',
                        ),
                    ),
                ),
            ));
        }
    }
}
```

**Testing Checklist:**
- [ ] Create test mission via WP Admin
- [ ] Verify all ACF fields save correctly
- [ ] Check mission appears in REST API: `/wp-json/wp/v2/mission`

---

#### Task 1.3: Create Database Tables (4 hours)
**File:** `wp-content/plugins/dwp-gamification/database/schema.php`

```php
<?php
function dwp_create_gamification_tables() {
    global $wpdb;
    $charset_collate = $wpdb->get_charset_collate();

    // Table 1: User Missions (tracking)
    $table_user_missions = $wpdb->prefix . 'user_missions';
    $sql_user_missions = "CREATE TABLE IF NOT EXISTS $table_user_missions (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        user_id bigint(20) NOT NULL,
        mission_id bigint(20) NOT NULL,
        status varchar(20) DEFAULT 'active',
        started_at datetime DEFAULT CURRENT_TIMESTAMP,
        completed_at datetime NULL,
        progress int(3) DEFAULT 0,
        proof_media longtext NULL,
        PRIMARY KEY (id),
        KEY user_id (user_id),
        KEY mission_id (mission_id),
        KEY status (status),
        UNIQUE KEY user_mission (user_id, mission_id)
    ) $charset_collate;";

    // Table 2: User Achievements
    $table_user_achievements = $wpdb->prefix . 'user_achievements';
    $sql_user_achievements = "CREATE TABLE IF NOT EXISTS $table_user_achievements (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        user_id bigint(20) NOT NULL,
        achievement_slug varchar(50) NOT NULL,
        unlocked_at datetime DEFAULT CURRENT_TIMESTAMP,
        notification_sent tinyint(1) DEFAULT 0,
        PRIMARY KEY (id),
        KEY user_id (user_id),
        KEY achievement_slug (achievement_slug),
        UNIQUE KEY user_achievement (user_id, achievement_slug)
    ) $charset_collate;";

    // Table 3: Notifications
    $table_notifications = $wpdb->prefix . 'dwp_notifications';
    $sql_notifications = "CREATE TABLE IF NOT EXISTS $table_notifications (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        user_id bigint(20) NOT NULL,
        type varchar(30) NOT NULL,
        title varchar(255) NOT NULL,
        body text NOT NULL,
        data longtext NULL,
        read_status tinyint(1) DEFAULT 0,
        sent_at datetime DEFAULT CURRENT_TIMESTAMP,
        fcm_sent tinyint(1) DEFAULT 0,
        PRIMARY KEY (id),
        KEY user_id (user_id),
        KEY type (type),
        KEY read_status (read_status)
    ) $charset_collate;";

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    dbDelta($sql_user_missions);
    dbDelta($sql_user_achievements);
    dbDelta($sql_notifications);
}
```

**Testing Checklist:**
- [ ] Activate plugin, check tables created in phpMyAdmin
- [ ] Verify table structure matches schema
- [ ] Test insert/select queries manually

---

### Week 4: Mission API Endpoints (12 hours)

#### Task 1.4: Mission REST API Endpoints
**File:** `wp-content/plugins/dwp-gamification/includes/class-api-endpoints.php`

```php
<?php
class DWP_API_Endpoints {
    private $namespace = 'dwp/v1';

    public function __construct() {
        add_action('rest_api_init', array($this, 'register_routes'));
    }

    public function register_routes() {
        // 1. Get nearby missions
        register_rest_route($this->namespace, '/missions/nearby', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_nearby_missions'),
            'permission_callback' => array($this, 'check_auth'),
            'args' => array(
                'lat' => array('required' => true, 'type' => 'number'),
                'lng' => array('required' => true, 'type' => 'number'),
                'radius' => array('default' => 10, 'type' => 'number'), // km
            ),
        ));

        // 2. Get mission details
        register_rest_route($this->namespace, '/missions/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_mission_details'),
            'permission_callback' => array($this, 'check_auth'),
        ));

        // 3. Create mission
        register_rest_route($this->namespace, '/missions/create', array(
            'methods' => 'POST',
            'callback' => array($this, 'create_mission'),
            'permission_callback' => array($this, 'check_auth'),
        ));

        // 4. Start mission
        register_rest_route($this->namespace, '/missions/start', array(
            'methods' => 'POST',
            'callback' => array($this, 'start_mission'),
            'permission_callback' => array($this, 'check_auth'),
        ));

        // 5. Complete mission
        register_rest_route($this->namespace, '/missions/complete', array(
            'methods' => 'POST',
            'callback' => array($this, 'complete_mission'),
            'permission_callback' => array($this, 'check_auth'),
        ));

        // 6. Get user's active missions
        register_rest_route($this->namespace, '/missions/my-missions', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_missions'),
            'permission_callback' => array($this, 'check_auth'),
        ));
    }

    public function check_auth($request) {
        return is_user_logged_in(); // JWT auth handles this
    }

    public function get_nearby_missions($request) {
        $lat = $request->get_param('lat');
        $lng = $request->get_param('lng');
        $radius = $request->get_param('radius');

        // Haversine formula for distance calculation
        global $wpdb;
        $table = $wpdb->prefix . 'posts';
        $meta_table = $wpdb->prefix . 'postmeta';

        $sql = $wpdb->prepare("
            SELECT p.ID, p.post_title, p.post_content,
                   lat.meta_value AS latitude,
                   lng.meta_value AS longitude,
                   (6371 * acos(
                       cos(radians(%f)) * cos(radians(lat.meta_value)) *
                       cos(radians(lng.meta_value) - radians(%f)) +
                       sin(radians(%f)) * sin(radians(lat.meta_value))
                   )) AS distance
            FROM $table p
            INNER JOIN $meta_table lat ON p.ID = lat.post_id AND lat.meta_key = 'latitude'
            INNER JOIN $meta_table lng ON p.ID = lng.post_id AND lng.meta_key = 'longitude'
            WHERE p.post_type = 'mission'
              AND p.post_status = 'publish'
            HAVING distance <= %f
            ORDER BY distance ASC
            LIMIT 50
        ", $lat, $lng, $lat, $radius);

        $results = $wpdb->get_results($sql);

        // Fetch ACF fields for each mission
        $missions = array();
        foreach ($results as $row) {
            $missions[] = array(
                'id' => (int) $row->ID,
                'title' => $row->post_title,
                'description' => $row->post_content,
                'latitude' => (float) $row->latitude,
                'longitude' => (float) $row->longitude,
                'distance' => round($row->distance, 2),
                'difficulty' => get_field('difficulty', $row->ID),
                'mission_type' => get_field('mission_type', $row->ID),
                'completion_count' => (int) get_field('completion_count', $row->ID),
                'thumbnail' => get_the_post_thumbnail_url($row->ID, 'medium'),
            );
        }

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($missions),
            'missions' => $missions,
        ));
    }

    public function get_mission_details($request) {
        $mission_id = $request->get_param('id');
        $post = get_post($mission_id);

        if (!$post || $post->post_type !== 'mission') {
            return new WP_Error('not_found', 'Mission not found', array('status' => 404));
        }

        $mission = array(
            'id' => $post->ID,
            'title' => $post->post_title,
            'description' => $post->post_content,
            'latitude' => (float) get_field('latitude', $post->ID),
            'longitude' => (float) get_field('longitude', $post->ID),
            'address' => get_field('address', $post->ID),
            'difficulty' => get_field('difficulty', $post->ID),
            'mission_type' => get_field('mission_type', $post->ID),
            'completion_count' => (int) get_field('completion_count', $post->ID),
            'thumbnail' => get_the_post_thumbnail_url($post->ID, 'large'),
            'story_id' => get_field('story_id', $post->ID),
        );

        // Check if current user has started/completed this mission
        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';
        $user_id = get_current_user_id();
        $user_mission = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d AND mission_id = %d",
            $user_id, $mission_id
        ));

        $mission['user_status'] = $user_mission ? $user_mission->status : 'not_started';
        $mission['user_progress'] = $user_mission ? (int) $user_mission->progress : 0;

        return rest_ensure_response(array(
            'success' => true,
            'mission' => $mission,
        ));
    }

    public function start_mission($request) {
        $mission_id = $request->get_param('mission_id');
        $user_id = get_current_user_id();

        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';

        // Check if already started
        $exists = $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM $table WHERE user_id = %d AND mission_id = %d",
            $user_id, $mission_id
        ));

        if ($exists) {
            return new WP_Error('already_started', 'Mission already started', array('status' => 400));
        }

        // Insert new user mission
        $inserted = $wpdb->insert($table, array(
            'user_id' => $user_id,
            'mission_id' => $mission_id,
            'status' => 'active',
            'started_at' => current_time('mysql'),
            'progress' => 0,
        ));

        if (!$inserted) {
            return new WP_Error('db_error', 'Failed to start mission', array('status' => 500));
        }

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Mission started successfully',
        ));
    }

    public function complete_mission($request) {
        $mission_id = $request->get_param('mission_id');
        $proof_media = $request->get_param('proof_media'); // JSON array of image URLs
        $user_id = get_current_user_id();

        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';

        // Update user mission status
        $updated = $wpdb->update(
            $table,
            array(
                'status' => 'completed',
                'completed_at' => current_time('mysql'),
                'progress' => 100,
                'proof_media' => json_encode($proof_media),
            ),
            array('user_id' => $user_id, 'mission_id' => $mission_id)
        );

        if (!$updated) {
            return new WP_Error('not_found', 'Mission not started or already completed', array('status' => 400));
        }

        // Increment mission completion count
        $current_count = (int) get_field('completion_count', $mission_id);
        update_field('completion_count', $current_count + 1, $mission_id);

        // Check for achievement unlocks
        do_action('dwp_mission_completed', $user_id, $mission_id);

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Mission completed!',
        ));
    }

    public function get_user_missions($request) {
        $user_id = get_current_user_id();
        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';

        $user_missions = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d ORDER BY started_at DESC",
            $user_id
        ));

        $missions = array();
        foreach ($user_missions as $um) {
            $post = get_post($um->mission_id);
            if ($post) {
                $missions[] = array(
                    'id' => $post->ID,
                    'title' => $post->post_title,
                    'status' => $um->status,
                    'progress' => (int) $um->progress,
                    'started_at' => $um->started_at,
                    'completed_at' => $um->completed_at,
                    'thumbnail' => get_the_post_thumbnail_url($post->ID, 'thumbnail'),
                );
            }
        }

        return rest_ensure_response(array(
            'success' => true,
            'missions' => $missions,
        ));
    }

    public function create_mission($request) {
        // TODO: Implement mission creation
        // Validate user has permission
        // Create mission post
        // Return mission ID
    }
}
```

**Testing with Postman:**
```
GET /wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018&radius=10
Headers: Authorization: Bearer YOUR_JWT_TOKEN

Expected Response:
{
  "success": true,
  "count": 5,
  "missions": [...]
}
```

**Testing Checklist:**
- [ ] Test all 6 endpoints with Postman
- [ ] Verify JWT authentication works
- [ ] Check error handling (invalid mission ID, etc.)
- [ ] Verify distance calculation is accurate

---

### Week 5: Achievement System Backend (10 hours)

#### Task 1.5: Achievement Manager
**File:** `wp-content/plugins/dwp-gamification/includes/class-achievement-manager.php`

```php
<?php
class DWP_Achievement_Manager {
    private $achievements = array();

    public function __construct() {
        $this->define_achievements();
        add_action('dwp_mission_completed', array($this, 'check_mission_achievements'), 10, 2);
        add_action('rest_api_init', array($this, 'register_achievement_routes'));
    }

    private function define_achievements() {
        $this->achievements = array(
            'first_mission' => array(
                'title' => 'First Steps',
                'description' => 'Complete your first mission',
                'icon' => 'first_mission.png',
                'criteria' => array('missions_completed' => 1),
            ),
            'five_missions' => array(
                'title' => 'Explorer',
                'description' => 'Complete 5 missions',
                'icon' => 'explorer.png',
                'criteria' => array('missions_completed' => 5),
            ),
            'ten_missions' => array(
                'title' => 'Historian',
                'description' => 'Complete 10 missions',
                'icon' => 'historian.png',
                'criteria' => array('missions_completed' => 10),
            ),
            'first_memorial' => array(
                'title' => 'Memorial Keeper',
                'description' => 'Create your first memorial plaque',
                'icon' => 'memorial_keeper.png',
                'criteria' => array('memorials_created' => 1),
            ),
            'story_teller' => array(
                'title' => 'Story Teller',
                'description' => 'Add 3 stories to the map',
                'icon' => 'story_teller.png',
                'criteria' => array('stories_created' => 3),
            ),
            'community_builder' => array(
                'title' => 'Community Builder',
                'description' => 'Have 10 followers',
                'icon' => 'community_builder.png',
                'criteria' => array('followers' => 10),
            ),
            'guardian' => array(
                'title' => 'Guardian of Memory',
                'description' => 'Complete 25 missions',
                'icon' => 'guardian.png',
                'criteria' => array('missions_completed' => 25),
            ),
        );
    }

    public function check_mission_achievements($user_id, $mission_id) {
        // Count user's completed missions
        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';
        $completed_count = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $table WHERE user_id = %d AND status = 'completed'",
            $user_id
        ));

        // Check achievement criteria
        if ($completed_count == 1) {
            $this->unlock_achievement($user_id, 'first_mission');
        } elseif ($completed_count == 5) {
            $this->unlock_achievement($user_id, 'five_missions');
        } elseif ($completed_count == 10) {
            $this->unlock_achievement($user_id, 'ten_missions');
        } elseif ($completed_count == 25) {
            $this->unlock_achievement($user_id, 'guardian');
        }
    }

    public function unlock_achievement($user_id, $achievement_slug) {
        global $wpdb;
        $table = $wpdb->prefix . 'user_achievements';

        // Check if already unlocked
        $exists = $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM $table WHERE user_id = %d AND achievement_slug = %s",
            $user_id, $achievement_slug
        ));

        if ($exists) {
            return false; // Already unlocked
        }

        // Insert achievement
        $wpdb->insert($table, array(
            'user_id' => $user_id,
            'achievement_slug' => $achievement_slug,
            'unlocked_at' => current_time('mysql'),
        ));

        // Send notification
        $achievement = $this->achievements[$achievement_slug];
        $this->send_achievement_notification($user_id, $achievement);

        return true;
    }

    private function send_achievement_notification($user_id, $achievement) {
        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $wpdb->insert($table, array(
            'user_id' => $user_id,
            'type' => 'achievement_unlocked',
            'title' => 'Achievement Unlocked!',
            'body' => $achievement['title'] . ': ' . $achievement['description'],
            'data' => json_encode(array('achievement' => $achievement)),
        ));

        // TODO: Send FCM push notification (Phase 2)
    }

    public function register_achievement_routes() {
        register_rest_route('dwp/v1', '/achievements', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_achievements'),
            'permission_callback' => '__return_true',
        ));
    }

    public function get_user_achievements($request) {
        $user_id = get_current_user_id();
        global $wpdb;
        $table = $wpdb->prefix . 'user_achievements';

        $unlocked = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d ORDER BY unlocked_at DESC",
            $user_id
        ), ARRAY_A);

        // Add achievement details
        $achievements = array();
        foreach ($unlocked as $row) {
            $slug = $row['achievement_slug'];
            if (isset($this->achievements[$slug])) {
                $achievements[] = array_merge(
                    $this->achievements[$slug],
                    array(
                        'slug' => $slug,
                        'unlocked_at' => $row['unlocked_at'],
                        'unlocked' => true,
                    )
                );
            }
        }

        // Add locked achievements
        foreach ($this->achievements as $slug => $achievement) {
            $is_unlocked = false;
            foreach ($unlocked as $row) {
                if ($row['achievement_slug'] === $slug) {
                    $is_unlocked = true;
                    break;
                }
            }
            if (!$is_unlocked) {
                $achievements[] = array_merge(
                    $achievement,
                    array(
                        'slug' => $slug,
                        'unlocked' => false,
                    )
                );
            }
        }

        return rest_ensure_response(array(
            'success' => true,
            'achievements' => $achievements,
        ));
    }
}
```

**Testing Checklist:**
- [ ] Complete a mission, verify achievement unlocks
- [ ] Check achievement appears in database
- [ ] Test GET /wp-json/dwp/v1/achievements endpoint
- [ ] Verify notification created

---

## Phase 2: Community Building & Achievements (Weeks 6-7)

### Week 6: Following System (8 hours)

#### Task 2.1: Following System API
**Add to:** `wp-content/plugins/dwp-gamification/includes/class-api-endpoints.php`

```php
// Follow user
register_rest_route($this->namespace, '/users/follow', array(
    'methods' => 'POST',
    'callback' => array($this, 'follow_user'),
    'permission_callback' => array($this, 'check_auth'),
));

// Unfollow user
register_rest_route($this->namespace, '/users/unfollow', array(
    'methods' => 'POST',
    'callback' => array($this, 'unfollow_user'),
    'permission_callback' => array($this, 'check_auth'),
));

// Get followers
register_rest_route($this->namespace, '/users/followers', array(
    'methods' => 'GET',
    'callback' => array($this, 'get_followers'),
    'permission_callback' => array($this, 'check_auth'),
));

// Get following
register_rest_route($this->namespace, '/users/following', array(
    'methods' => 'GET',
    'callback' => array($this, 'get_following'),
    'permission_callback' => array($this, 'check_auth'),
));

// Get feed
register_rest_route($this->namespace, '/feed', array(
    'methods' => 'GET',
    'callback' => array($this, 'get_user_feed'),
    'permission_callback' => array($this, 'check_auth'),
));

public function follow_user($request) {
    $follower_id = get_current_user_id();
    $following_id = $request->get_param('user_id');

    if ($follower_id == $following_id) {
        return new WP_Error('invalid', 'Cannot follow yourself', array('status' => 400));
    }

    // Use WordPress user meta for simplicity
    $current_following = get_user_meta($follower_id, 'dwp_following', true);
    if (!is_array($current_following)) {
        $current_following = array();
    }

    if (in_array($following_id, $current_following)) {
        return new WP_Error('already_following', 'Already following this user', array('status' => 400));
    }

    $current_following[] = $following_id;
    update_user_meta($follower_id, 'dwp_following', $current_following);

    // Update follower's followers list
    $followers = get_user_meta($following_id, 'dwp_followers', true);
    if (!is_array($followers)) {
        $followers = array();
    }
    $followers[] = $follower_id;
    update_user_meta($following_id, 'dwp_followers', $followers);

    // Send notification
    global $wpdb;
    $table = $wpdb->prefix . 'dwp_notifications';
    $follower_name = wp_get_current_user()->display_name;
    $wpdb->insert($table, array(
        'user_id' => $following_id,
        'type' => 'new_follower',
        'title' => 'New Follower',
        'body' => $follower_name . ' started following you',
    ));

    return rest_ensure_response(array(
        'success' => true,
        'message' => 'Now following user',
    ));
}

// Implement unfollow_user, get_followers, get_following similarly
```

**Testing Checklist:**
- [ ] Follow user, verify meta updated
- [ ] Unfollow user, verify meta updated
- [ ] Check follower count updates correctly
- [ ] Verify notification sent

---

### Week 7: Push Notifications (FCM) (12 hours)

#### Task 2.2: Firebase Cloud Messaging Setup

**Prerequisites:**
- [ ] Create Firebase project (or use existing DWP project)
- [ ] Get Firebase Server Key from Console
- [ ] Store server key in wp-config.php: `define('FCM_SERVER_KEY', 'your-key-here');`

**File:** `wp-content/plugins/dwp-gamification/includes/class-notification-handler.php`

```php
<?php
class DWP_Notification_Handler {
    public function __construct() {
        add_action('rest_api_init', array($this, 'register_notification_routes'));
        add_action('dwp_send_notification', array($this, 'send_fcm_notification'), 10, 2);
    }

    public function register_notification_routes() {
        // Register FCM token
        register_rest_route('dwp/v1', '/notifications/register-token', array(
            'methods' => 'POST',
            'callback' => array($this, 'register_fcm_token'),
            'permission_callback' => '__return_true',
        ));

        // Get user notifications
        register_rest_route('dwp/v1', '/notifications', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_notifications'),
            'permission_callback' => '__return_true',
        ));

        // Mark as read
        register_rest_route('dwp/v1', '/notifications/(?P<id>\d+)/read', array(
            'methods' => 'POST',
            'callback' => array($this, 'mark_as_read'),
            'permission_callback' => '__return_true',
        ));
    }

    public function register_fcm_token($request) {
        $user_id = get_current_user_id();
        $fcm_token = $request->get_param('fcm_token');

        update_user_meta($user_id, 'fcm_token', $fcm_token);

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'FCM token registered',
        ));
    }

    public function send_fcm_notification($user_id, $notification_id) {
        $fcm_token = get_user_meta($user_id, 'fcm_token', true);
        if (!$fcm_token) {
            return false; // No FCM token registered
        }

        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';
        $notification = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $table WHERE id = %d",
            $notification_id
        ));

        if (!$notification) {
            return false;
        }

        $fcm_data = array(
            'to' => $fcm_token,
            'notification' => array(
                'title' => $notification->title,
                'body' => $notification->body,
                'sound' => 'default',
            ),
            'data' => json_decode($notification->data, true),
        );

        $headers = array(
            'Authorization: key=' . FCM_SERVER_KEY,
            'Content-Type: application/json',
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fcm_data));
        $result = curl_exec($ch);
        curl_close($ch);

        // Mark as sent
        $wpdb->update($table, array('fcm_sent' => 1), array('id' => $notification_id));

        return true;
    }

    public function get_notifications($request) {
        $user_id = get_current_user_id();
        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $notifications = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d ORDER BY sent_at DESC LIMIT 50",
            $user_id
        ), ARRAY_A);

        return rest_ensure_response(array(
            'success' => true,
            'notifications' => $notifications,
        ));
    }

    public function mark_as_read($request) {
        $notification_id = $request->get_param('id');
        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $wpdb->update($table, array('read_status' => 1), array('id' => $notification_id));

        return rest_ensure_response(array(
            'success' => true,
        ));
    }
}
```

**Testing Checklist:**
- [ ] Register test FCM token via API
- [ ] Trigger notification (complete mission)
- [ ] Verify FCM notification received on Flutter app
- [ ] Check notification saved in database

---

## Phase 3: Legacy & Memorial System (Weeks 8-9)

### Week 8-9: Memorial Plaque System (16 hours)

#### Task 3.1: Memorial Plaque Custom Post Type
**Add to:** `includes/class-mission-cpt.php` (or create new file)

```php
public function register_memorial_cpt() {
    register_post_type('memorial_plaque', array(
        'labels' => array(
            'name' => 'Memorial Plaques',
            'singular_name' => 'Memorial Plaque',
        ),
        'public' => true,
        'has_archive' => false,
        'show_in_rest' => true,
        'supports' => array('title', 'editor', 'author'),
        'menu_icon' => 'dashicons-heart',
    ));
}

public function register_memorial_fields() {
    acf_add_local_field_group(array(
        'key' => 'group_memorial_plaque',
        'title' => 'Memorial Plaque Details',
        'fields' => array(
            array(
                'key' => 'field_memorial_story_id',
                'label' => 'Linked Story',
                'name' => 'story_id',
                'type' => 'post_object',
                'post_type' => array('story'),
                'required' => 1,
            ),
            array(
                'key' => 'field_memorial_template',
                'label' => 'Plaque Template',
                'name' => 'template',
                'type' => 'select',
                'choices' => array(
                    'cedar' => 'Cedar Tree Design',
                    'olive' => 'Olive Branch Design',
                    'geometric' => 'Geometric Pattern',
                ),
            ),
            array(
                'key' => 'field_memorial_dedication',
                'label' => 'Dedication Text',
                'name' => 'dedication_text',
                'type' => 'textarea',
                'maxlength' => 200,
            ),
            array(
                'key' => 'field_memorial_qr_code',
                'label' => 'QR Code URL',
                'name' => 'qr_code_url',
                'type' => 'url',
                'readonly' => 1,
            ),
            array(
                'key' => 'field_memorial_views',
                'label' => 'View Count',
                'name' => 'view_count',
                'type' => 'number',
                'default_value' => 0,
                'readonly' => 1,
            ),
        ),
        'location' => array(
            array(
                array(
                    'param' => 'post_type',
                    'operator' => '==',
                    'value' => 'memorial_plaque',
                ),
            ),
        ),
    ));
}
```

#### Task 3.2: Memorial API Endpoints
```php
// Create memorial plaque
register_rest_route($this->namespace, '/memorials/create', array(
    'methods' => 'POST',
    'callback' => array($this, 'create_memorial'),
    'permission_callback' => array($this, 'check_auth'),
));

// Get memorial by QR code
register_rest_route($this->namespace, '/memorials/(?P<id>\d+)', array(
    'methods' => 'GET',
    'callback' => array($this, 'get_memorial'),
    'permission_callback' => '__return_true', // Public endpoint
));

public function create_memorial($request) {
    $user_id = get_current_user_id();
    $story_id = $request->get_param('story_id');
    $template = $request->get_param('template');
    $dedication = $request->get_param('dedication_text');

    // Create memorial post
    $memorial_id = wp_insert_post(array(
        'post_type' => 'memorial_plaque',
        'post_title' => 'Memorial for Story #' . $story_id,
        'post_status' => 'publish',
        'post_author' => $user_id,
    ));

    if (!$memorial_id) {
        return new WP_Error('creation_failed', 'Failed to create memorial', array('status' => 500));
    }

    // Save ACF fields
    update_field('story_id', $story_id, $memorial_id);
    update_field('template', $template, $memorial_id);
    update_field('dedication_text', $dedication, $memorial_id);

    // Generate QR code URL
    $qr_url = site_url('/memorial/' . $memorial_id);
    update_field('qr_code_url', $qr_url, $memorial_id);

    // Check achievement
    do_action('dwp_memorial_created', $user_id);

    return rest_ensure_response(array(
        'success' => true,
        'memorial_id' => $memorial_id,
        'qr_url' => $qr_url,
    ));
}
```

**Testing Checklist:**
- [ ] Create memorial via API
- [ ] Verify QR code URL generated
- [ ] Access memorial via public endpoint
- [ ] Verify view count increments

---

## WordPress Development Timeline Summary

| Phase | Week | Task | Hours | Status |
|-------|------|------|-------|--------|
| **Phase 1** | 3 | Plugin structure + Missions CPT | 10 | Pending |
| | 3 | Database tables | 4 | Pending |
| | 4 | Mission API endpoints (6 endpoints) | 12 | Pending |
| | 5 | Achievement system backend | 10 | Pending |
| **Phase 2** | 6 | Following system API | 8 | Pending |
| | 7 | Push notifications (FCM) | 12 | Pending |
| **Phase 3** | 8-9 | Memorial plaque system | 16 | Pending |
| **Phase 4** | 10 | Testing, optimization, docs | 8 | Pending |
| **TOTAL** | | | **80 hours** | |

---

## Daily Development Workflow

### Morning Routine (15 min)
1. Pull latest from `feature/gamification` branch
2. Review CHANGELOG.md for overnight updates
3. Check Postman for API endpoint status

### Development Session
1. Pick one task from roadmap
2. Code locally (WordPress local site)
3. Test with Postman immediately
4. Document any API changes in WORDPRESS_BACKEND_REQUIREMENTS.md

### End of Day (15 min)
1. Commit changes with descriptive message
2. Push to `feature/gamification` branch
3. Update CHANGELOG.md with progress
4. Post standup update (what completed, what's next, blockers)

---

## Common WordPress Development Commands

```bash
# Activate plugin
wp plugin activate dwp-gamification

# Check database tables
wp db query "SHOW TABLES LIKE 'wp_user_missions'"

# Test ACF field
wp post meta list 123

# Flush rewrite rules
wp rewrite flush

# Export database (backup)
wp db export backup-$(date +%Y%m%d).sql

# Test REST API endpoint
curl -X GET "https://dwp.world/wp-json/dwp/v1/missions/nearby?lat=33.8938&lng=35.5018" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## Questions to Answer Before Starting

1. **WordPress Environment:**
   - [ ] Do you have admin access to dwp.world?
   - [ ] Is there a staging site available?
   - [ ] Do you have FTP/SFTP credentials?

2. **Database Access:**
   - [ ] Can you access phpMyAdmin?
   - [ ] Do you have database backup procedure?

3. **Current Setup:**
   - [ ] Is ACF Pro already installed and activated?
   - [ ] Is JWT auth plugin installed?
   - [ ] What's the current WordPress version?

4. **Development Workflow:**
   - [ ] Will you develop locally first, then deploy?
   - [ ] Or develop directly on staging/production?

---

**Ready to start Phase 1?** Let me know and I'll walk you through creating the plugin structure!
