<?php
/**
 * REST API Endpoints for Missions
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class DWP_API_Endpoints {

    private $namespace = 'dwp/v1';

    /**
     * Constructor
     */
    public function __construct() {
        add_action('rest_api_init', array($this, 'register_routes'));
    }

    /**
     * Register REST API routes
     */
    public function register_routes() {
        // Get nearby missions
        register_rest_route($this->namespace, '/missions/nearby', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_nearby_missions'),
            'permission_callback' => '__return_true', // Public endpoint
            'args' => array(
                'lat' => array(
                    'required' => true,
                    'type' => 'number',
                    'description' => 'Latitude coordinate',
                ),
                'lng' => array(
                    'required' => true,
                    'type' => 'number',
                    'description' => 'Longitude coordinate',
                ),
                'radius' => array(
                    'default' => 10,
                    'type' => 'number',
                    'description' => 'Search radius in kilometers',
                ),
            ),
        ));

        // Get mission details
        register_rest_route($this->namespace, '/missions/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_mission_details'),
            'permission_callback' => '__return_true', // Public endpoint
        ));

        // Start mission
        register_rest_route($this->namespace, '/missions/start', array(
            'methods' => 'POST',
            'callback' => array($this, 'start_mission'),
            'permission_callback' => array($this, 'check_auth'),
            'args' => array(
                'mission_id' => array(
                    'required' => true,
                    'type' => 'integer',
                ),
            ),
        ));

        // Complete mission
        register_rest_route($this->namespace, '/missions/complete', array(
            'methods' => 'POST',
            'callback' => array($this, 'complete_mission'),
            'permission_callback' => array($this, 'check_auth'),
            'args' => array(
                'mission_id' => array(
                    'required' => true,
                    'type' => 'integer',
                ),
                'proof_media' => array(
                    'required' => false,
                    'type' => 'array',
                    'description' => 'Array of image URLs as proof',
                ),
            ),
        ));

        // Get user's missions
        register_rest_route($this->namespace, '/missions/my-missions', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_missions'),
            'permission_callback' => array($this, 'check_auth'),
        ));

        // Create new mission (user-generated)
        register_rest_route($this->namespace, '/missions/create', array(
            'methods' => 'POST',
            'callback' => array($this, 'create_mission'),
            'permission_callback' => array($this, 'check_auth'),
            'args' => array(
                'title' => array(
                    'required' => true,
                    'type' => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ),
                'description' => array(
                    'required' => true,
                    'type' => 'string',
                    'sanitize_callback' => 'sanitize_textarea_field',
                ),
                'latitude' => array(
                    'required' => true,
                    'type' => 'number',
                ),
                'longitude' => array(
                    'required' => true,
                    'type' => 'number',
                ),
                'address' => array(
                    'required' => false,
                    'type' => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ),
                'difficulty' => array(
                    'required' => false,
                    'type' => 'string',
                    'default' => 'easy',
                    'enum' => array('easy', 'medium', 'hard'),
                ),
                'mission_type' => array(
                    'required' => false,
                    'type' => 'string',
                    'default' => 'visit',
                    'enum' => array('visit', 'interview', 'photograph', 'research', 'memorial'),
                ),
                'category' => array(
                    'required' => false,
                    'type' => 'string',
                    'default' => 'social',
                    'enum' => array('social', 'personal'),
                    'description' => 'Mission category: social (community quest) or personal (tribute)',
                ),
                'privacy' => array(
                    'required' => false,
                    'type' => 'string',
                    'default' => 'public',
                    'enum' => array('public', 'private'),
                    'description' => 'Privacy setting for personal missions',
                ),
                'reward_points' => array(
                    'required' => false,
                    'type' => 'integer',
                    'description' => 'Reward points (auto-calculated if not provided)',
                ),
                'story_id' => array(
                    'required' => false,
                    'type' => 'integer',
                ),
            ),
        ));

        // Add reaction to personal mission
        register_rest_route($this->namespace, '/missions/react', array(
            'methods' => 'POST',
            'callback' => array($this, 'add_mission_reaction'),
            'permission_callback' => array($this, 'check_auth'),
            'args' => array(
                'mission_id' => array(
                    'required' => true,
                    'type' => 'integer',
                ),
                'reaction' => array(
                    'required' => true,
                    'type' => 'string',
                    'enum' => array('pray', 'heart', 'smile', 'cry'),
                    'description' => 'Reaction type: pray (🙏), heart (❤️), smile (😊), cry (😢)',
                ),
            ),
        ));

        // Get mission reactions
        register_rest_route($this->namespace, '/missions/(?P<id>\d+)/reactions', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_mission_reactions'),
            'permission_callback' => '__return_true', // Public endpoint
        ));

        // Remove reaction from mission
        register_rest_route($this->namespace, '/missions/unreact', array(
            'methods' => 'POST',
            'callback' => array($this, 'remove_mission_reaction'),
            'permission_callback' => array($this, 'check_auth'),
            'args' => array(
                'mission_id' => array(
                    'required' => true,
                    'type' => 'integer',
                ),
                'reaction' => array(
                    'required' => true,
                    'type' => 'string',
                ),
            ),
        ));

        // Get shareable content for mission
        register_rest_route($this->namespace, '/missions/(?P<id>\d+)/share', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_share_content'),
            'permission_callback' => '__return_true', // Public endpoint
            'args' => array(
                'platform' => array(
                    'required' => false,
                    'type' => 'string',
                    'enum' => array('whatsapp', 'facebook', 'twitter', 'generic'),
                    'default' => 'generic',
                ),
            ),
        ));
    }

    /**
     * Check if user is authenticated
     */
    public function check_auth($request) {
        return is_user_logged_in();
    }

    /**
     * Get nearby missions using Haversine formula
     */
    public function get_nearby_missions($request) {
        $lat = floatval($request->get_param('lat'));
        $lng = floatval($request->get_param('lng'));
        $radius = floatval($request->get_param('radius'));

        global $wpdb;
        $posts_table = $wpdb->prefix . 'posts';
        $postmeta_table = $wpdb->prefix . 'postmeta';

        // Haversine formula SQL query
        $sql = $wpdb->prepare("
            SELECT DISTINCT p.ID, p.post_title, p.post_content, p.post_date,
                   lat.meta_value AS latitude,
                   lng.meta_value AS longitude,
                   (6371 * acos(
                       cos(radians(%f)) * cos(radians(CAST(lat.meta_value AS DECIMAL(10,8)))) *
                       cos(radians(CAST(lng.meta_value AS DECIMAL(11,8))) - radians(%f)) +
                       sin(radians(%f)) * sin(radians(CAST(lat.meta_value AS DECIMAL(10,8))))
                   )) AS distance
            FROM $posts_table p
            INNER JOIN $postmeta_table lat ON p.ID = lat.post_id AND lat.meta_key = 'latitude'
            INNER JOIN $postmeta_table lng ON p.ID = lng.post_id AND lng.meta_key = 'longitude'
            INNER JOIN $postmeta_table active ON p.ID = active.post_id AND active.meta_key = 'is_active' AND active.meta_value = '1'
            WHERE p.post_type = 'mission'
              AND p.post_status = 'publish'
            HAVING distance <= %f
            ORDER BY distance ASC
            LIMIT 50
        ", $lat, $lng, $lat, $radius);

        $results = $wpdb->get_results($sql);

        $missions = array();
        foreach ($results as $row) {
            $missions[] = $this->format_mission_data($row->ID, $row);
        }

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($missions),
            'user_location' => array('lat' => $lat, 'lng' => $lng),
            'radius_km' => $radius,
            'missions' => $missions,
        ));
    }

    /**
     * Get mission details
     */
    public function get_mission_details($request) {
        $mission_id = intval($request->get_param('id'));
        $post = get_post($mission_id);

        if (!$post || $post->post_type !== 'mission' || $post->post_status !== 'publish') {
            return new WP_Error('not_found', 'Mission not found', array('status' => 404));
        }

        $mission = $this->format_mission_data($mission_id, $post);

        // Add user status if logged in
        if (is_user_logged_in()) {
            $user_id = get_current_user_id();
            $user_mission = $this->get_user_mission_status($user_id, $mission_id);
            $mission['user_status'] = $user_mission ? $user_mission->status : 'not_started';
            $mission['user_progress'] = $user_mission ? intval($user_mission->progress) : 0;
            $mission['user_started_at'] = $user_mission ? $user_mission->started_at : null;
        }

        return rest_ensure_response(array(
            'success' => true,
            'mission' => $mission,
        ));
    }

    /**
     * Start a mission
     */
    public function start_mission($request) {
        $mission_id = intval($request->get_param('mission_id'));
        $user_id = get_current_user_id();

        // Verify mission exists
        $post = get_post($mission_id);
        if (!$post || $post->post_type !== 'mission') {
            return new WP_Error('invalid_mission', 'Invalid mission ID', array('status' => 400));
        }

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
            'mission_id' => $mission_id,
        ));
    }

    /**
     * Complete a mission
     */
    public function complete_mission($request) {
        $mission_id = intval($request->get_param('mission_id'));
        $proof_media = $request->get_param('proof_media');
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
                'proof_media' => $proof_media ? json_encode($proof_media) : null,
            ),
            array(
                'user_id' => $user_id,
                'mission_id' => $mission_id,
            ),
            array('%s', '%s', '%d', '%s'),
            array('%d', '%d')
        );

        if ($updated === false || $updated === 0) {
            return new WP_Error('not_found', 'Mission not started or already completed', array('status' => 400));
        }

        // Increment mission completion count
        $current_count = intval(get_field('completion_count', $mission_id));
        update_field('completion_count', $current_count + 1, $mission_id);

        // Trigger achievement check
        do_action('dwp_mission_completed', $user_id, $mission_id);

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Mission completed!',
            'mission_id' => $mission_id,
        ));
    }

    /**
     * Get user's missions
     */
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
                    'progress' => intval($um->progress),
                    'started_at' => $um->started_at,
                    'completed_at' => $um->completed_at,
                    'thumbnail' => get_the_post_thumbnail_url($post->ID, 'thumbnail'),
                    'difficulty' => get_field('difficulty', $post->ID),
                    'mission_type' => get_field('mission_type', $post->ID),
                );
            }
        }

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($missions),
            'missions' => $missions,
        ));
    }

    /**
     * Format mission data
     */
    private function format_mission_data($mission_id, $post_data = null) {
        if (!$post_data) {
            $post_data = get_post($mission_id);
        }

        $category = get_field('category', $mission_id) ?: 'social';

        $mission = array(
            'id' => $mission_id,
            'title' => $post_data->post_title,
            'description' => $post_data->post_content,
            'excerpt' => wp_trim_words($post_data->post_content, 30),
            'latitude' => floatval(get_field('latitude', $mission_id)),
            'longitude' => floatval(get_field('longitude', $mission_id)),
            'address' => get_field('address', $mission_id),
            'difficulty' => get_field('difficulty', $mission_id),
            'mission_type' => get_field('mission_type', $mission_id),
            'category' => $category,
            'privacy' => get_field('privacy', $mission_id) ?: 'public',
            'completion_count' => intval(get_field('completion_count', $mission_id)),
            'reward_points' => intval(get_field('reward_points', $mission_id)),
            'goal_count' => intval(get_field('goal_count', $mission_id)),
            'follower_goal' => intval(get_field('follower_goal', $mission_id)),
            'duration_days' => intval(get_field('duration_days', $mission_id)),
            'is_active' => (bool) get_field('is_active', $mission_id),
            'thumbnail' => get_the_post_thumbnail_url($mission_id, 'medium'),
            'story_id' => get_field('story_id', $mission_id),
            'created_at' => $post_data->post_date,
            'status' => $post_data->post_status,
        );

        // Add reactions for personal missions
        if ($category === 'personal') {
            $reactions = get_field('reactions', $mission_id);
            if (!$reactions || !is_array($reactions)) {
                $reactions = array(
                    'pray' => array(),
                    'heart' => array(),
                    'smile' => array(),
                    'cry' => array(),
                );
            }
            $mission['reactions'] = $this->format_reactions($reactions);
        }

        // Add distance if available (from nearby query)
        if (isset($post_data->distance)) {
            $mission['distance_km'] = round(floatval($post_data->distance), 2);
        }

        return $mission;
    }

    /**
     * Create a new mission
     */
    public function create_mission($request) {
        $user_id = get_current_user_id();

        // Get parameters
        $title = $request->get_param('title');
        $description = $request->get_param('description');
        $latitude = floatval($request->get_param('latitude'));
        $longitude = floatval($request->get_param('longitude'));
        $address = $request->get_param('address');
        $difficulty = $request->get_param('difficulty') ?: 'easy';
        $mission_type = $request->get_param('mission_type') ?: 'visit';
        $category = $request->get_param('category') ?: 'social';
        $privacy = $request->get_param('privacy') ?: 'public';
        $story_id = $request->get_param('story_id');

        // AUTO-CALCULATE system-controlled fields based on difficulty and category
        $system_rules = $this->calculate_mission_rules($difficulty, $category);

        // Allow manual override of reward_points only if provided
        $reward_points = $request->get_param('reward_points');
        if (!$reward_points) {
            $reward_points = $system_rules['reward_points'];
        }

        // ALL missions need approval for safety - no auto-publish
        $post_status = 'pending';

        // Create mission post
        $post_data = array(
            'post_title' => $title,
            'post_content' => $description,
            'post_status' => $post_status,
            'post_author' => $user_id,
            'post_type' => 'mission',
        );

        $post_id = wp_insert_post($post_data);

        if (is_wp_error($post_id)) {
            return new WP_Error('create_failed', 'Failed to create mission', array('status' => 500));
        }

        // Save ACF fields
        update_field('latitude', $latitude, $post_id);
        update_field('longitude', $longitude, $post_id);
        update_field('address', $address, $post_id);
        update_field('difficulty', $difficulty, $post_id);
        update_field('mission_type', $mission_type, $post_id);
        update_field('category', $category, $post_id);
        update_field('privacy', $privacy, $post_id);
        update_field('reward_points', $reward_points, $post_id);
        update_field('goal_count', $system_rules['goal_count'], $post_id);
        update_field('follower_goal', $system_rules['follower_goal'], $post_id);
        update_field('duration_days', $system_rules['duration_days'], $post_id);
        update_field('completion_count', 0, $post_id);
        update_field('is_active', true, $post_id);

        if ($story_id) {
            update_field('story_id', $story_id, $post_id);
        }

        // Get the formatted mission data
        $mission = $this->format_mission_data($post_id);

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Mission created and submitted for approval',
            'status' => 'pending',
            'mission' => $mission,
        ));
    }

    /**
     * Calculate mission system rules based on difficulty and category
     */
    private function calculate_mission_rules($difficulty, $category) {
        $rules = array();

        if ($category === 'social') {
            // Social missions: community quests with goals
            switch ($difficulty) {
                case 'easy':
                    $rules = array(
                        'goal_count' => 5,
                        'follower_goal' => 3,
                        'duration_days' => 30,
                        'reward_points' => 50,
                    );
                    break;
                case 'medium':
                    $rules = array(
                        'goal_count' => 15,
                        'follower_goal' => 10,
                        'duration_days' => 60,
                        'reward_points' => 150,
                    );
                    break;
                case 'hard':
                    $rules = array(
                        'goal_count' => 30,
                        'follower_goal' => 25,
                        'duration_days' => 90,
                        'reward_points' => 300,
                    );
                    break;
                default:
                    $rules = array(
                        'goal_count' => 5,
                        'follower_goal' => 3,
                        'duration_days' => 30,
                        'reward_points' => 50,
                    );
            }
        } else {
            // Personal missions: tributes with no follower goals
            switch ($difficulty) {
                case 'easy':
                    $rules = array(
                        'goal_count' => 1,
                        'follower_goal' => 0,
                        'duration_days' => 0, // No expiry
                        'reward_points' => 25,
                    );
                    break;
                case 'medium':
                    $rules = array(
                        'goal_count' => 1,
                        'follower_goal' => 0,
                        'duration_days' => 0,
                        'reward_points' => 50,
                    );
                    break;
                case 'hard':
                    $rules = array(
                        'goal_count' => 1,
                        'follower_goal' => 0,
                        'duration_days' => 0,
                        'reward_points' => 100,
                    );
                    break;
                default:
                    $rules = array(
                        'goal_count' => 1,
                        'follower_goal' => 0,
                        'duration_days' => 0,
                        'reward_points' => 25,
                    );
            }
        }

        return $rules;
    }

    /**
     * Get user mission status
     */
    private function get_user_mission_status($user_id, $mission_id) {
        global $wpdb;
        $table = $wpdb->prefix . 'user_missions';

        return $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d AND mission_id = %d",
            $user_id, $mission_id
        ));
    }

    /**
     * Add emoji reaction to a personal mission
     */
    public function add_mission_reaction($request) {
        $mission_id = intval($request->get_param('mission_id'));
        $reaction = $request->get_param('reaction');
        $user_id = get_current_user_id();

        // Verify mission exists and is personal
        $post = get_post($mission_id);
        if (!$post || $post->post_type !== 'mission') {
            return new WP_Error('invalid_mission', 'Invalid mission ID', array('status' => 400));
        }

        $category = get_field('category', $mission_id);
        if ($category !== 'personal') {
            return new WP_Error('invalid_category', 'Reactions are only available for personal missions', array('status' => 400));
        }

        // Get existing reactions
        $reactions = get_field('reactions', $mission_id);
        if (!$reactions || !is_array($reactions)) {
            $reactions = array(
                'pray' => array(),
                'heart' => array(),
                'smile' => array(),
                'cry' => array(),
            );
        }

        // Check if user already reacted with this emoji
        if (in_array($user_id, $reactions[$reaction])) {
            return new WP_Error('already_reacted', 'You already reacted with this emoji', array('status' => 400));
        }

        // Remove user from other reactions (one reaction per user)
        foreach ($reactions as $type => $users) {
            if (($key = array_search($user_id, $users)) !== false) {
                unset($reactions[$type][$key]);
                $reactions[$type] = array_values($reactions[$type]); // Re-index
            }
        }

        // Add new reaction
        $reactions[$reaction][] = $user_id;

        // Save updated reactions
        update_field('reactions', $reactions, $mission_id);

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Reaction added successfully',
            'reactions' => $this->format_reactions($reactions),
        ));
    }

    /**
     * Get all reactions for a mission
     */
    public function get_mission_reactions($request) {
        $mission_id = intval($request->get_param('id'));

        $post = get_post($mission_id);
        if (!$post || $post->post_type !== 'mission') {
            return new WP_Error('invalid_mission', 'Invalid mission ID', array('status' => 400));
        }

        $reactions = get_field('reactions', $mission_id);
        if (!$reactions || !is_array($reactions)) {
            $reactions = array(
                'pray' => array(),
                'heart' => array(),
                'smile' => array(),
                'cry' => array(),
            );
        }

        return rest_ensure_response(array(
            'success' => true,
            'mission_id' => $mission_id,
            'reactions' => $this->format_reactions($reactions),
        ));
    }

    /**
     * Remove reaction from mission
     */
    public function remove_mission_reaction($request) {
        $mission_id = intval($request->get_param('mission_id'));
        $reaction = $request->get_param('reaction');
        $user_id = get_current_user_id();

        $post = get_post($mission_id);
        if (!$post || $post->post_type !== 'mission') {
            return new WP_Error('invalid_mission', 'Invalid mission ID', array('status' => 400));
        }

        $reactions = get_field('reactions', $mission_id);
        if (!$reactions || !is_array($reactions)) {
            return new WP_Error('no_reactions', 'No reactions found', array('status' => 404));
        }

        // Remove user from reaction
        if (isset($reactions[$reaction])) {
            if (($key = array_search($user_id, $reactions[$reaction])) !== false) {
                unset($reactions[$reaction][$key]);
                $reactions[$reaction] = array_values($reactions[$reaction]); // Re-index
                update_field('reactions', $reactions, $mission_id);

                return rest_ensure_response(array(
                    'success' => true,
                    'message' => 'Reaction removed successfully',
                    'reactions' => $this->format_reactions($reactions),
                ));
            }
        }

        return new WP_Error('not_found', 'Reaction not found', array('status' => 404));
    }

    /**
     * Format reactions for API response
     */
    private function format_reactions($reactions) {
        return array(
            'pray' => array(
                'emoji' => '🙏',
                'count' => count($reactions['pray']),
                'users' => $reactions['pray'],
            ),
            'heart' => array(
                'emoji' => '❤️',
                'count' => count($reactions['heart']),
                'users' => $reactions['heart'],
            ),
            'smile' => array(
                'emoji' => '😊',
                'count' => count($reactions['smile']),
                'users' => $reactions['smile'],
            ),
            'cry' => array(
                'emoji' => '😢',
                'count' => count($reactions['cry']),
                'users' => $reactions['cry'],
            ),
        );
    }

    /**
     * Get shareable content for a mission
     */
    public function get_share_content($request) {
        $mission_id = intval($request->get_param('id'));
        $platform = $request->get_param('platform');

        $post = get_post($mission_id);
        if (!$post || $post->post_type !== 'mission' || $post->post_status !== 'publish') {
            return new WP_Error('invalid_mission', 'Mission not found', array('status' => 404));
        }

        $mission = $this->format_mission_data($mission_id, $post);

        // Generate mission URL
        $mission_url = home_url('/mission/' . $mission_id);

        // Clean description (remove HTML tags)
        $clean_description = wp_strip_all_tags($mission['description']);
        $short_description = wp_trim_words($clean_description, 20);

        // Base share data
        $share_data = array(
            'title' => $mission['title'],
            'description' => $short_description,
            'url' => $mission_url,
            'category' => $mission['category'],
        );

        // Platform-specific formatting
        switch ($platform) {
            case 'whatsapp':
                $emoji = ($mission['category'] === 'personal') ? '🙏' : '🎯';
                $message = "{$emoji} {$mission['title']}\n\n{$short_description}\n\n📍 {$mission['address']}\n\n🌟 {$mission['reward_points']} points\n\nجزء من قصص الحرب الأهلية اللبنانية 🇱🇧\n\n{$mission_url}";

                $share_data['whatsapp_url'] = 'https://wa.me/?text=' . rawurlencode($message);
                $share_data['message'] = $message;
                break;

            case 'facebook':
                $share_data['facebook_url'] = 'https://www.facebook.com/sharer/sharer.php?u=' . rawurlencode($mission_url);
                $share_data['quote'] = $mission['title'] . ' - ' . $short_description;
                break;

            case 'twitter':
                $hashtags = 'DealWithPast,Lebanon';
                $tweet = "{$mission['title']}\n{$short_description}\n\n{$mission_url}";

                // Twitter has 280 char limit
                if (strlen($tweet) > 250) {
                    $tweet = substr($tweet, 0, 247) . '...';
                }

                $share_data['twitter_url'] = 'https://twitter.com/intent/tweet?text=' . rawurlencode($tweet) . '&hashtags=' . $hashtags;
                $share_data['tweet'] = $tweet;
                break;

            case 'generic':
            default:
                $emoji = ($mission['category'] === 'personal') ? '🙏' : '🎯';
                $share_data['text'] = "{$emoji} {$mission['title']}\n\n{$short_description}\n\n📍 {$mission['address']}\n🌟 {$mission['reward_points']} points\n\nDealWithPast - Lebanese Civil War Stories\n{$mission_url}";
                break;
        }

        // Add meta tags for social sharing
        $share_data['meta'] = array(
            'og:title' => $mission['title'],
            'og:description' => $short_description,
            'og:url' => $mission_url,
            'og:type' => 'article',
            'og:site_name' => 'DealWithPast',
            'twitter:card' => 'summary_large_image',
            'twitter:title' => $mission['title'],
            'twitter:description' => $short_description,
        );

        // Add image if available
        if ($mission['thumbnail']) {
            $share_data['meta']['og:image'] = $mission['thumbnail'];
            $share_data['meta']['twitter:image'] = $mission['thumbnail'];
        }

        return rest_ensure_response(array(
            'success' => true,
            'mission_id' => $mission_id,
            'platform' => $platform,
            'share' => $share_data,
        ));
    }
}
