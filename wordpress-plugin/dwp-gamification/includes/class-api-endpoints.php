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

        // Add mission data to story REST API responses
        add_filter('rest_prepare_stories', array($this, 'add_mission_data_to_story'), 10, 3);
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
                'neighborhood' => array(
                    'required' => false,
                    'type' => 'string',
                    'description' => 'Filter by neighborhood tag (e.g., "Hamra", "Dahiye")',
                ),
                'decade' => array(
                    'required' => false,
                    'type' => 'string',
                    'description' => 'Filter by decade tag (e.g., "1970s", "1980s")',
                ),
                'theme' => array(
                    'required' => false,
                    'type' => 'string',
                    'description' => 'Filter by theme tag (e.g., "war", "daily life")',
                ),
                'category' => array(
                    'required' => false,
                    'type' => 'string',
                    'enum' => array('social', 'personal'),
                    'description' => 'Filter by mission category',
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

        // Get user badges - GAMIFICATION
        register_rest_route($this->namespace, '/users/(?P<id>\d+)/badges', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_badges'),
            'permission_callback' => '__return_true', // Public endpoint
        ));

        // Get user legacy data - GAMIFICATION
        register_rest_route($this->namespace, '/users/(?P<id>\d+)/legacy', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_legacy'),
            'permission_callback' => '__return_true', // Public endpoint
        ));

        // Get user's pending missions (for tracking submissions)
        register_rest_route($this->namespace, '/missions/my-pending', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_my_pending_missions'),
            'permission_callback' => array($this, 'check_auth'),
        ));
    }

    /**
     * Check if user is authenticated (supports session cookies and Firebase JWT tokens)
     */
    public function check_auth($request) {
        // First check WordPress session
        if (is_user_logged_in()) {
            return true;
        }

        // Check for JWT Bearer token in Authorization header
        $auth_header = $request->get_header('authorization');
        if (!$auth_header) {
            return new WP_Error(
                'rest_forbidden',
                __('Authorization header missing.'),
                array('status' => 401)
            );
        }

        // Extract token from "Bearer <token>" format
        if (preg_match('/Bearer\s+(.*)$/i', $auth_header, $matches)) {
            $token = $matches[1];
            error_log('DWP Auth: Received token (first 50 chars): ' . substr($token, 0, 50));

            // Try to decode the Firebase JWT token
            try {
                // Split the JWT token (format: header.payload.signature)
                $token_parts = explode('.', $token);
                if (count($token_parts) !== 3) {
                    error_log('DWP Auth: Invalid token format - parts count: ' . count($token_parts));
                    throw new Exception('Invalid token format');
                }

                // Decode the payload (second part)
                // Firebase tokens use base64url encoding
                $payload_encoded = $token_parts[1];
                $payload_json = base64_decode(strtr($payload_encoded, '-_', '+/'));
                $payload = json_decode($payload_json);

                if (!$payload) {
                    error_log('DWP Auth: Failed to decode token payload. JSON: ' . substr($payload_json, 0, 100));
                    throw new Exception('Failed to decode token payload');
                }

                error_log('DWP Auth: Token payload keys: ' . implode(', ', array_keys((array)$payload)));

                // Firebase token has user_id (Firebase UID)
                $firebase_uid = null;
                if (isset($payload->user_id)) {
                    $firebase_uid = $payload->user_id;
                } elseif (isset($payload->sub)) {
                    // 'sub' is the standard JWT claim for subject (user ID)
                    $firebase_uid = $payload->sub;
                }

                if (!$firebase_uid) {
                    error_log('DWP Auth: No user ID found in token. Available fields: ' . json_encode($payload));
                    throw new Exception('No user ID found in token');
                }

                error_log('DWP Auth: Firebase UID extracted: ' . $firebase_uid);

                // Find WordPress user with this Firebase UID
                $users = get_users(array(
                    'meta_key' => 'firebase_uid',
                    'meta_value' => $firebase_uid,
                    'number' => 1,
                ));

                error_log('DWP Auth: Users found by Firebase UID: ' . count($users));

                if (empty($users)) {
                    // User not found - try to get email from token and find by email
                    $email = isset($payload->email) ? $payload->email : null;
                    error_log('DWP Auth: Email from token: ' . ($email ? $email : 'none'));

                    if ($email) {
                        $user = get_user_by('email', $email);
                        if ($user) {
                            error_log('DWP Auth: User found by email: ' . $user->user_email . ' (ID: ' . $user->ID . ')');
                            // Update their Firebase UID for future requests
                            update_user_meta($user->ID, 'firebase_uid', $firebase_uid);
                            wp_set_current_user($user->ID);
                            error_log('DWP Auth: User authenticated successfully');
                            return true;
                        } else {
                            error_log('DWP Auth: No user found with email: ' . $email);
                        }
                    }

                    return new WP_Error(
                        'rest_forbidden',
                        __('DEBUG: No WP user found. Email from token: ' . ($email ? $email : 'NONE') . ' | Firebase UID: ' . $firebase_uid . ' | Token payload keys: ' . implode(', ', array_keys((array)$payload))),
                        array('status' => 401)
                    );
                }

                // Authenticate the user
                $user = $users[0];
                wp_set_current_user($user->ID);
                error_log('DWP Auth: User authenticated by Firebase UID: ' . $user->user_email . ' (ID: ' . $user->ID . ')');
                return true;

            } catch (Exception $e) {
                error_log('DWP Auth: Exception - ' . $e->getMessage());
                return new WP_Error(
                    'rest_forbidden',
                    __('DEBUG: Auth exception - ' . $e->getMessage()),
                    array('status' => 401)
                );
            }
        }

        return new WP_Error(
            'rest_forbidden',
            __('Invalid authorization header format.'),
            array('status' => 401)
        );
    }

    /**
     * Get nearby missions using Haversine formula
     */
    public function get_nearby_missions($request) {
        $lat = floatval($request->get_param('lat'));
        $lng = floatval($request->get_param('lng'));
        $radius = floatval($request->get_param('radius'));

        // Get optional filter parameters
        $neighborhood_filter = $request->get_param('neighborhood');
        $decade_filter = $request->get_param('decade');
        $theme_filter = $request->get_param('theme');
        $category_filter = $request->get_param('category');

        global $wpdb;
        $posts_table = $wpdb->prefix . 'posts';
        $postmeta_table = $wpdb->prefix . 'postmeta';

        // Haversine formula SQL query - ONLY published missions
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

        // Apply tag filters (post-query because tags are comma-separated strings in ACF)
        $missions = array();
        foreach ($results as $row) {
            // Apply filters if provided
            if ($category_filter) {
                $category = get_field('category', $row->ID);
                if ($category !== $category_filter) {
                    continue;
                }
            }

            if ($neighborhood_filter) {
                $neighborhood_tags = get_field('neighborhood_tags', $row->ID);
                if (empty($neighborhood_tags) || stripos($neighborhood_tags, $neighborhood_filter) === false) {
                    continue;
                }
            }

            if ($decade_filter) {
                $decade_tags = get_field('decade_tags', $row->ID);
                if (empty($decade_tags) || stripos($decade_tags, $decade_filter) === false) {
                    continue;
                }
            }

            if ($theme_filter) {
                $theme_tags = get_field('theme_tags', $row->ID);
                if (empty($theme_tags) || stripos($theme_tags, $theme_filter) === false) {
                    continue;
                }
            }

            $missions[] = $this->format_mission_data($row->ID, $row);
        }

        $filters_applied = array();
        if ($category_filter) $filters_applied['category'] = $category_filter;
        if ($neighborhood_filter) $filters_applied['neighborhood'] = $neighborhood_filter;
        if ($decade_filter) $filters_applied['decade'] = $decade_filter;
        if ($theme_filter) $filters_applied['theme'] = $theme_filter;

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($missions),
            'user_location' => array('lat' => $lat, 'lng' => $lng),
            'radius_km' => $radius,
            'filters' => $filters_applied,
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

        // Parse tags into arrays
        $neighborhood_tags_str = get_field('neighborhood_tags', $mission_id);
        $decade_tags_str = get_field('decade_tags', $mission_id);
        $theme_tags_str = get_field('theme_tags', $mission_id);

        // Auto-calculate reward points based on difficulty and goal_count
        $difficulty = get_field('difficulty', $mission_id) ?: 'easy';
        $goal_count = intval(get_field('goal_count', $mission_id));

        $base_points = array(
            'easy' => 5,
            'medium' => 10,
            'hard' => 15,
        );

        $calculated_points = ($base_points[$difficulty] ?? 10) * max(1, $goal_count / 10);
        $reward_points = round($calculated_points);

        // Get author info
        $author_id = $post_data->post_author;
        $author_name = get_the_author_meta('display_name', $author_id);
        $author_avatar = get_avatar_url($author_id, array('size' => 96));

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
            'reward_points' => $reward_points, // Auto-calculated
            'goal_count' => intval(get_field('goal_count', $mission_id)),
            'follower_goal' => intval(get_field('follower_goal', $mission_id)),
            'duration_days' => intval(get_field('duration_days', $mission_id)),
            'is_active' => (bool) get_field('is_active', $mission_id),
            'thumbnail' => get_the_post_thumbnail_url($mission_id, 'medium'),
            'story_id' => get_field('story_id', $mission_id),
            'created_at' => $post_data->post_date,
            'status' => $post_data->post_status,
            // Creator info
            'creator_id' => intval($author_id),
            'creator_name' => $author_name,
            'creator_avatar' => $author_avatar,
            // Tag fields (parsed as arrays for easier filtering in app)
            'neighborhood_tags' => $neighborhood_tags_str ? array_map('trim', explode(',', $neighborhood_tags_str)) : array(),
            'decade_tags' => $decade_tags_str ? array_map('trim', explode(',', $decade_tags_str)) : array(),
            'theme_tags' => $theme_tags_str ? array_map('trim', explode(',', $theme_tags_str)) : array(),
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

    /**
     * Add mission data to story REST API responses (bidirectional linking)
     *
     * This filter enriches story responses with mission metadata when a story
     * is linked to a mission via the mission_id ACF field.
     *
     * @param WP_REST_Response $response The response object
     * @param WP_Post $post The post object
     * @param WP_REST_Request $request The request object
     * @return WP_REST_Response Modified response with mission data
     */
    public function add_mission_data_to_story($response, $post, $request) {
        // Get mission_id from ACF field
        $mission_id = get_field('mission_id', $post->ID);

        if ($mission_id && is_numeric($mission_id)) {
            // Fetch mission data
            $mission_post = get_post($mission_id);

            if ($mission_post && $mission_post->post_type === 'mission' && $mission_post->post_status === 'publish') {
                // Get mission metadata
                $mission_data = array(
                    'id' => (int) $mission_id,
                    'title' => $mission_post->post_title,
                    'category' => get_field('category', $mission_id) ?: 'social',
                    'difficulty' => get_field('difficulty', $mission_id) ?: 'easy',
                    'goal_count' => (int) get_field('goal_count', $mission_id) ?: 10,
                    'completion_count' => $this->get_mission_story_count($mission_id),
                );

                // Add mission data to response
                $response_data = $response->get_data();
                $response_data['mission_data'] = $mission_data;
                $response->set_data($response_data);
            }
        }

        return $response;
    }

    /**
     * Get user badges - GAMIFICATION
     * Endpoint: GET /wp-json/dwp/v1/users/{id}/badges
     */
    public function get_user_badges($request) {
        $user_id = (int) $request['id'];

        // Get user's story count
        $args = array(
            'post_type' => 'stories',
            'author' => $user_id,
            'post_status' => 'publish',
            'posts_per_page' => -1,
            'fields' => 'ids',
        );
        $user_stories = get_posts($args);
        $total_stories = count($user_stories);

        // Get stories with media
        $stories_with_media = 0;
        foreach ($user_stories as $story_id) {
            if (get_field('audio_url', $story_id) || get_field('video_url', $story_id)) {
                $stories_with_media++;
            }
        }

        // Get user's mission data
        $missions_created = count(get_posts(array(
            'post_type' => 'mission',
            'author' => $user_id,
            'post_status' => 'publish',
            'fields' => 'ids',
        )));

        // Get missions participated in (stories linked to missions)
        $missions_participated = array();
        foreach ($user_stories as $story_id) {
            $mission_id = get_field('mission_id', $story_id);
            if ($mission_id && !in_array($mission_id, $missions_participated)) {
                $missions_participated[] = $mission_id;
            }
        }
        $missions_participated_count = count($missions_participated);

        // Check badge unlock status
        $badges = array(
            // FOUNDATION BADGES
            array(
                'id' => 'voice',
                'unlocked' => $stories_with_media >= 1,
                'progress' => min($stories_with_media, 1),
            ),
            array(
                'id' => 'memory_keeper',
                'unlocked' => $total_stories >= 1,
                'progress' => min($total_stories, 1),
            ),
            array(
                'id' => 'narrator',
                'unlocked' => $total_stories >= 3,
                'progress' => min($total_stories, 3),
            ),

            // COMMUNITY BADGES
            array(
                'id' => 'community_builder',
                'unlocked' => $missions_created >= 1,
                'progress' => min($missions_created, 1),
            ),
            array(
                'id' => 'peace_messenger',
                'unlocked' => $missions_participated_count >= 3,
                'progress' => min($missions_participated_count, 3),
            ),
            array(
                'id' => 'memory_protectors',
                'unlocked' => false, // TODO: Implement invite tracking
                'progress' => 0,
            ),
            array(
                'id' => 'gatherer',
                'unlocked' => $missions_participated_count >= 5,
                'progress' => min($missions_participated_count, 5),
            ),

            // LEGACY BADGES
            array(
                'id' => 'generation_witness',
                'unlocked' => $total_stories >= 15, // Ambassador level
                'progress' => min($total_stories, 15),
            ),
            array(
                'id' => 'family_storyteller',
                'unlocked' => false, // TODO: Check for family history stories
                'progress' => 0,
            ),
            array(
                'id' => 'peacemaker',
                'unlocked' => false, // TODO: Check for reconciliation stories
                'progress' => 0,
            ),
            array(
                'id' => 'culture_guardian',
                'unlocked' => false, // TODO: Check for cultural missions created
                'progress' => 0,
            ),
            array(
                'id' => 'story_champion',
                'unlocked' => count($missions_participated) >= 3 && $total_stories >= 5,
                'progress' => min(count($missions_participated), 3),
            ),
        );

        return new WP_REST_Response(array(
            'user_id' => $user_id,
            'badges' => $badges,
            'total_unlocked' => count(array_filter($badges, function($b) { return $b['unlocked']; })),
        ), 200);
    }

    /**
     * Get user legacy data - GAMIFICATION
     * Endpoint: GET /wp-json/dwp/v1/users/{id}/legacy
     */
    public function get_user_legacy($request) {
        $user_id = (int) $request['id'];

        // Get user info
        $user = get_userdata($user_id);
        if (!$user) {
            return new WP_Error('user_not_found', 'User not found', array('status' => 404));
        }

        // Get user's stories
        $args = array(
            'post_type' => 'stories',
            'author' => $user_id,
            'post_status' => 'publish',
            'posts_per_page' => -1,
            'fields' => 'ids',
        );
        $user_stories = get_posts($args);
        $total_stories = count($user_stories);

        // Count stories with media
        $stories_with_media = 0;
        $themes = array();
        foreach ($user_stories as $story_id) {
            // Check for media
            if (get_field('audio_url', $story_id) || get_field('video_url', $story_id)) {
                $stories_with_media++;
            }

            // Collect themes
            $story_themes = wp_get_post_terms($story_id, 'theme', array('fields' => 'names'));
            $themes = array_merge($themes, $story_themes);
        }
        $themes_explored = count(array_unique($themes));

        // Get user's missions
        $missions_created = count(get_posts(array(
            'post_type' => 'mission',
            'author' => $user_id,
            'post_status' => 'publish',
            'fields' => 'ids',
        )));

        // Get missions participated in
        $missions_participated = array();
        foreach ($user_stories as $story_id) {
            $mission_id = get_field('mission_id', $story_id);
            if ($mission_id && !in_array($mission_id, $missions_participated)) {
                $missions_participated[] = $mission_id;
            }
        }

        // Get member since date
        $member_since = get_userdata($user_id)->user_registered;

        // Get user avatar
        $avatar_url = get_avatar_url($user_id, array('size' => 96));

        return new WP_REST_Response(array(
            'user_name' => $user->display_name,
            'user_avatar' => $avatar_url,
            'member_since' => $member_since,
            'stories' => array(
                'total' => $total_stories,
                'with_media' => $stories_with_media,
            ),
            'missions' => array(
                'total' => $missions_created + count($missions_participated),
                'created' => $missions_created,
                'participated' => count($missions_participated),
            ),
            'community' => array(
                'people_invited' => 0, // TODO: Implement invite tracking
                'themes_explored' => $themes_explored,
            ),
        ), 200);
    }

    /**
     * Get user's pending missions (submissions waiting for approval)
     */
    public function get_my_pending_missions($request) {
        $user_id = get_current_user_id();

        $args = array(
            'post_type' => 'mission',
            'post_status' => 'pending',
            'author' => $user_id,
            'posts_per_page' => -1,
            'orderby' => 'date',
            'order' => 'DESC',
        );

        $query = new WP_Query($args);
        $missions = array();

        if ($query->have_posts()) {
            while ($query->have_posts()) {
                $query->the_post();
                $post_id = get_the_ID();

                $missions[] = array(
                    'id' => $post_id,
                    'title' => get_the_title(),
                    'description' => get_the_content(),
                    'latitude' => floatval(get_field('latitude', $post_id)),
                    'longitude' => floatval(get_field('longitude', $post_id)),
                    'address' => get_field('address', $post_id),
                    'category' => get_field('category', $post_id),
                    'difficulty' => get_field('difficulty', $post_id),
                    'status' => 'pending',
                    'submitted_at' => get_the_date('c'),
                    'rejection_reason' => get_field('rejection_reason', $post_id), // Will be set if previously rejected
                );
            }
            wp_reset_postdata();
        }

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($missions),
            'pending_missions' => $missions,
        ));
    }
}
