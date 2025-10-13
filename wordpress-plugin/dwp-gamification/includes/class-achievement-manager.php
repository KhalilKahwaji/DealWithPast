<?php
/**
 * Achievement Manager
 * Handles achievement definitions, unlocking, and tracking
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class DWP_Achievement_Manager {

    private $achievements = array();

    /**
     * Constructor
     */
    public function __construct() {
        $this->define_achievements();
        add_action('dwp_mission_completed', array($this, 'check_mission_achievements'), 10, 2);
        add_action('rest_api_init', array($this, 'register_achievement_routes'));
    }

    /**
     * Define all achievements
     */
    private function define_achievements() {
        $this->achievements = array(
            'first_mission' => array(
                'slug' => 'first_mission',
                'title' => __('First Steps', 'dwp-gamification'),
                'description' => __('Complete your first mission', 'dwp-gamification'),
                'icon' => 'achievement_first_mission.png',
                'criteria' => array('missions_completed' => 1),
                'reward_points' => 10,
            ),
            'explorer' => array(
                'slug' => 'explorer',
                'title' => __('Explorer', 'dwp-gamification'),
                'description' => __('Complete 5 missions', 'dwp-gamification'),
                'icon' => 'achievement_explorer.png',
                'criteria' => array('missions_completed' => 5),
                'reward_points' => 25,
            ),
            'historian' => array(
                'slug' => 'historian',
                'title' => __('Historian', 'dwp-gamification'),
                'description' => __('Complete 10 missions', 'dwp-gamification'),
                'icon' => 'achievement_historian.png',
                'criteria' => array('missions_completed' => 10),
                'reward_points' => 50,
            ),
            'guardian' => array(
                'slug' => 'guardian',
                'title' => __('Guardian of Memory', 'dwp-gamification'),
                'description' => __('Complete 25 missions', 'dwp-gamification'),
                'icon' => 'achievement_guardian.png',
                'criteria' => array('missions_completed' => 25),
                'reward_points' => 100,
            ),
            'memorial_keeper' => array(
                'slug' => 'memorial_keeper',
                'title' => __('Memorial Keeper', 'dwp-gamification'),
                'description' => __('Create your first memorial plaque', 'dwp-gamification'),
                'icon' => 'achievement_memorial_keeper.png',
                'criteria' => array('memorials_created' => 1),
                'reward_points' => 50,
            ),
            'story_teller' => array(
                'slug' => 'story_teller',
                'title' => __('Story Teller', 'dwp-gamification'),
                'description' => __('Add 3 stories to the map', 'dwp-gamification'),
                'icon' => 'achievement_story_teller.png',
                'criteria' => array('stories_created' => 3),
                'reward_points' => 30,
            ),
            'community_builder' => array(
                'slug' => 'community_builder',
                'title' => __('Community Builder', 'dwp-gamification'),
                'description' => __('Have 10 followers', 'dwp-gamification'),
                'icon' => 'achievement_community_builder.png',
                'criteria' => array('followers' => 10),
                'reward_points' => 40,
            ),
        );

        // Allow other plugins/themes to add achievements
        $this->achievements = apply_filters('dwp_achievements', $this->achievements);
    }

    /**
     * Check mission-related achievements after mission completion
     */
    public function check_mission_achievements($user_id, $mission_id) {
        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';

        // Count completed missions
        $completed_count = $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $table WHERE user_id = %d AND status = 'completed'",
            $user_id
        ));

        // Check achievement thresholds
        $achievements_to_unlock = array();

        if ($completed_count >= 1 && !$this->is_achievement_unlocked($user_id, 'first_mission')) {
            $achievements_to_unlock[] = 'first_mission';
        }
        if ($completed_count >= 5 && !$this->is_achievement_unlocked($user_id, 'explorer')) {
            $achievements_to_unlock[] = 'explorer';
        }
        if ($completed_count >= 10 && !$this->is_achievement_unlocked($user_id, 'historian')) {
            $achievements_to_unlock[] = 'historian';
        }
        if ($completed_count >= 25 && !$this->is_achievement_unlocked($user_id, 'guardian')) {
            $achievements_to_unlock[] = 'guardian';
        }

        // Unlock achievements
        foreach ($achievements_to_unlock as $achievement_slug) {
            $this->unlock_achievement($user_id, $achievement_slug);
        }
    }

    /**
     * Check if achievement is already unlocked
     */
    public function is_achievement_unlocked($user_id, $achievement_slug) {
        global $wpdb;
        $table = $wpdb->prefix . 'user_achievements';

        $exists = $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM $table WHERE user_id = %d AND achievement_slug = %s",
            $user_id, $achievement_slug
        ));

        return (bool) $exists;
    }

    /**
     * Unlock an achievement for a user
     */
    public function unlock_achievement($user_id, $achievement_slug) {
        // Check if achievement exists
        if (!isset($this->achievements[$achievement_slug])) {
            return false;
        }

        // Check if already unlocked
        if ($this->is_achievement_unlocked($user_id, $achievement_slug)) {
            return false;
        }

        global $wpdb;
        $table = $wpdb->prefix . 'user_achievements';

        // Insert achievement
        $inserted = $wpdb->insert($table, array(
            'user_id' => $user_id,
            'achievement_slug' => $achievement_slug,
            'unlocked_at' => current_time('mysql'),
            'notification_sent' => 0,
        ));

        if (!$inserted) {
            return false;
        }

        // Get achievement details
        $achievement = $this->achievements[$achievement_slug];

        // Send notification
        $this->send_achievement_notification($user_id, $achievement);

        // Trigger action for other plugins
        do_action('dwp_achievement_unlocked', $user_id, $achievement_slug, $achievement);

        return true;
    }

    /**
     * Send achievement unlock notification
     */
    private function send_achievement_notification($user_id, $achievement) {
        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $wpdb->insert($table, array(
            'user_id' => $user_id,
            'type' => 'achievement_unlocked',
            'title' => __('Achievement Unlocked!', 'dwp-gamification'),
            'body' => sprintf(
                __('%s: %s', 'dwp-gamification'),
                $achievement['title'],
                $achievement['description']
            ),
            'data' => json_encode(array(
                'achievement' => $achievement,
            )),
            'read_status' => 0,
            'fcm_sent' => 0,
        ));
    }

    /**
     * Register REST API routes for achievements
     */
    public function register_achievement_routes() {
        // Get user achievements
        register_rest_route('dwp/v1', '/achievements', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_achievements'),
            'permission_callback' => function() {
                return is_user_logged_in();
            },
        ));

        // Get all available achievements (public)
        register_rest_route('dwp/v1', '/achievements/all', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_all_achievements'),
            'permission_callback' => '__return_true',
        ));
    }

    /**
     * Get user's achievements (REST API endpoint)
     */
    public function get_user_achievements($request) {
        $user_id = get_current_user_id();

        global $wpdb;
        $table = $wpdb->prefix . 'user_achievements';

        // Get unlocked achievements
        $unlocked = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d ORDER BY unlocked_at DESC",
            $user_id
        ), ARRAY_A);

        $unlocked_slugs = array_column($unlocked, 'achievement_slug');

        // Get user stats for progress calculation
        $stats = $this->get_user_stats($user_id);

        $achievements = array();

        foreach ($this->achievements as $slug => $achievement) {
            $is_unlocked = in_array($slug, $unlocked_slugs);

            $achievement_data = array_merge($achievement, array(
                'unlocked' => $is_unlocked,
                'unlocked_at' => null,
                'progress' => 0,
            ));

            // Add unlock timestamp if unlocked
            if ($is_unlocked) {
                $unlock_data = array_values(array_filter($unlocked, function($item) use ($slug) {
                    return $item['achievement_slug'] === $slug;
                }));
                if (!empty($unlock_data)) {
                    $achievement_data['unlocked_at'] = $unlock_data[0]['unlocked_at'];
                }
            } else {
                // Calculate progress toward achievement
                $achievement_data['progress'] = $this->calculate_achievement_progress($slug, $stats);
            }

            $achievements[] = $achievement_data;
        }

        return rest_ensure_response(array(
            'success' => true,
            'count_unlocked' => count($unlocked),
            'count_total' => count($this->achievements),
            'achievements' => $achievements,
        ));
    }

    /**
     * Get all available achievements (public endpoint)
     */
    public function get_all_achievements($request) {
        $achievements = array();

        foreach ($this->achievements as $slug => $achievement) {
            $achievements[] = $achievement;
        }

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($achievements),
            'achievements' => $achievements,
        ));
    }

    /**
     * Get user stats for progress calculation
     */
    private function get_user_stats($user_id) {
        global $wpdb;

        $stats = array();

        // Missions completed
        $missions_table = $wpdb->prefix . 'user_missions';
        $stats['missions_completed'] = (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $missions_table WHERE user_id = %d AND status = 'completed'",
            $user_id
        ));

        // Stories created (posts by user)
        $stats['stories_created'] = (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM {$wpdb->prefix}posts WHERE post_author = %d AND post_type = 'stories' AND post_status = 'publish'",
            $user_id
        ));

        // Followers count (from user meta)
        $followers = get_user_meta($user_id, 'dwp_followers', true);
        $stats['followers'] = is_array($followers) ? count($followers) : 0;

        // Memorials created (future Phase 3)
        $stats['memorials_created'] = 0;

        return $stats;
    }

    /**
     * Calculate progress toward achievement
     */
    private function calculate_achievement_progress($achievement_slug, $user_stats) {
        if (!isset($this->achievements[$achievement_slug])) {
            return 0;
        }

        $achievement = $this->achievements[$achievement_slug];
        $criteria = $achievement['criteria'];

        // Calculate progress percentage
        foreach ($criteria as $key => $required_value) {
            if (isset($user_stats[$key])) {
                $current_value = $user_stats[$key];
                $progress = min(100, ($current_value / $required_value) * 100);
                return (int) $progress;
            }
        }

        return 0;
    }
}
