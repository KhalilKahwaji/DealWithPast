<?php
/**
 * Mission Custom Post Type
 * Registers 'mission' CPT and ACF fields
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class DWP_Mission_CPT {

    /**
     * Constructor
     */
    public function __construct() {
        add_action('init', array($this, 'register_mission_cpt'));
        add_action('acf/init', array($this, 'register_mission_fields'));
    }

    /**
     * Register Mission Custom Post Type
     */
    public function register_mission_cpt() {
        $labels = array(
            'name'                  => _x('Missions', 'Post Type General Name', 'dwp-gamification'),
            'singular_name'         => _x('Mission', 'Post Type Singular Name', 'dwp-gamification'),
            'menu_name'             => __('Missions', 'dwp-gamification'),
            'name_admin_bar'        => __('Mission', 'dwp-gamification'),
            'archives'              => __('Mission Archives', 'dwp-gamification'),
            'attributes'            => __('Mission Attributes', 'dwp-gamification'),
            'parent_item_colon'     => __('Parent Mission:', 'dwp-gamification'),
            'all_items'             => __('All Missions', 'dwp-gamification'),
            'add_new_item'          => __('Add New Mission', 'dwp-gamification'),
            'add_new'               => __('Add New', 'dwp-gamification'),
            'new_item'              => __('New Mission', 'dwp-gamification'),
            'edit_item'             => __('Edit Mission', 'dwp-gamification'),
            'update_item'           => __('Update Mission', 'dwp-gamification'),
            'view_item'             => __('View Mission', 'dwp-gamification'),
            'view_items'            => __('View Missions', 'dwp-gamification'),
            'search_items'          => __('Search Mission', 'dwp-gamification'),
            'not_found'             => __('Not found', 'dwp-gamification'),
            'not_found_in_trash'    => __('Not found in Trash', 'dwp-gamification'),
            'featured_image'        => __('Mission Image', 'dwp-gamification'),
            'set_featured_image'    => __('Set mission image', 'dwp-gamification'),
            'remove_featured_image' => __('Remove mission image', 'dwp-gamification'),
            'use_featured_image'    => __('Use as mission image', 'dwp-gamification'),
            'insert_into_item'      => __('Insert into mission', 'dwp-gamification'),
            'uploaded_to_this_item' => __('Uploaded to this mission', 'dwp-gamification'),
            'items_list'            => __('Missions list', 'dwp-gamification'),
            'items_list_navigation' => __('Missions list navigation', 'dwp-gamification'),
            'filter_items_list'     => __('Filter missions list', 'dwp-gamification'),
        );

        $args = array(
            'label'                 => __('Mission', 'dwp-gamification'),
            'description'           => __('Gamification missions for users to complete', 'dwp-gamification'),
            'labels'                => $labels,
            'supports'              => array('title', 'editor', 'author', 'thumbnail', 'revisions'),
            'hierarchical'          => false,
            'public'                => true,
            'show_ui'               => true,
            'show_in_menu'          => true,
            'menu_position'         => 5,
            'menu_icon'             => 'dashicons-location-alt',
            'show_in_admin_bar'     => true,
            'show_in_nav_menus'     => true,
            'can_export'            => true,
            'has_archive'           => false,
            'exclude_from_search'   => false,
            'publicly_queryable'    => true,
            'capability_type'       => 'post',
            'show_in_rest'          => true, // Enable REST API
            'rest_base'             => 'missions',
            'rest_controller_class' => 'WP_REST_Posts_Controller',
        );

        register_post_type('mission', $args);
    }

    /**
     * Register ACF Fields for Missions
     */
    public function register_mission_fields() {
        if (!function_exists('acf_add_local_field_group')) {
            return;
        }

        acf_add_local_field_group(array(
            'key' => 'group_mission_details',
            'title' => 'Mission Details',
            'fields' => array(
                // Location - Latitude
                array(
                    'key' => 'field_mission_latitude',
                    'label' => 'Latitude',
                    'name' => 'latitude',
                    'type' => 'number',
                    'instructions' => 'Geographic latitude coordinate (e.g., 33.8938 for Beirut)',
                    'required' => 1,
                    'min' => -90,
                    'max' => 90,
                    'step' => 0.000001,
                    'placeholder' => '33.8938',
                ),
                // Location - Longitude
                array(
                    'key' => 'field_mission_longitude',
                    'label' => 'Longitude',
                    'name' => 'longitude',
                    'type' => 'number',
                    'instructions' => 'Geographic longitude coordinate (e.g., 35.5018 for Beirut)',
                    'required' => 1,
                    'min' => -180,
                    'max' => 180,
                    'step' => 0.000001,
                    'placeholder' => '35.5018',
                ),
                // Location - Address
                array(
                    'key' => 'field_mission_address',
                    'label' => 'Address',
                    'name' => 'address',
                    'type' => 'text',
                    'instructions' => 'Human-readable address',
                    'placeholder' => 'Martyrs Square, Beirut, Lebanon',
                ),
                // Linked Story
                array(
                    'key' => 'field_mission_story_id',
                    'label' => 'Linked Story',
                    'name' => 'story_id',
                    'type' => 'post_object',
                    'instructions' => 'Select the story this mission is related to',
                    'post_type' => array('stories'),
                    'allow_null' => 1,
                    'multiple' => 0,
                    'return_format' => 'id',
                ),
                // Difficulty
                array(
                    'key' => 'field_mission_difficulty',
                    'label' => 'Difficulty',
                    'name' => 'difficulty',
                    'type' => 'select',
                    'instructions' => 'How challenging is this mission?',
                    'choices' => array(
                        'easy' => 'Easy (15-30 minutes)',
                        'medium' => 'Medium (30-60 minutes)',
                        'hard' => 'Hard (1+ hours)',
                    ),
                    'default_value' => 'easy',
                    'allow_null' => 0,
                    'multiple' => 0,
                    'ui' => 1,
                    'return_format' => 'value',
                ),
                // Mission Type
                array(
                    'key' => 'field_mission_type',
                    'label' => 'Mission Type',
                    'name' => 'mission_type',
                    'type' => 'select',
                    'instructions' => 'What type of activity does this mission require?',
                    'choices' => array(
                        'visit' => 'Visit Location',
                        'interview' => 'Interview Elder',
                        'photograph' => 'Photograph Site',
                        'research' => 'Research Archive',
                        'memorial' => 'Create Memorial',
                    ),
                    'default_value' => 'visit',
                    'allow_null' => 0,
                    'multiple' => 0,
                    'ui' => 1,
                    'return_format' => 'value',
                ),
                // Completion Count
                array(
                    'key' => 'field_mission_completion_count',
                    'label' => 'Completion Count',
                    'name' => 'completion_count',
                    'type' => 'number',
                    'instructions' => 'How many users have completed this mission (auto-updated)',
                    'default_value' => 0,
                    'min' => 0,
                    'readonly' => 1,
                ),
                // Active Status
                array(
                    'key' => 'field_mission_active',
                    'label' => 'Active',
                    'name' => 'is_active',
                    'type' => 'true_false',
                    'instructions' => 'Is this mission currently active and visible to users?',
                    'message' => 'Yes, this mission is active',
                    'default_value' => 1,
                    'ui' => 1,
                ),
                // Reward Points (auto-calculated - readonly)
                array(
                    'key' => 'field_mission_reward_points',
                    'label' => 'Reward Points (Auto-Calculated)',
                    'name' => 'reward_points',
                    'type' => 'number',
                    'instructions' => 'Points awarded for completing this mission (automatically calculated based on difficulty × goal_count)',
                    'default_value' => 10,
                    'readonly' => 1,
                    'disabled' => 1,
                ),
                // Goal Count (for progress tracking)
                array(
                    'key' => 'field_mission_goal_count',
                    'label' => 'Goal Count',
                    'name' => 'goal_count',
                    'type' => 'number',
                    'instructions' => 'How many story contributions are needed to complete this mission?',
                    'default_value' => 10,
                    'min' => 1,
                    'max' => 100,
                    'step' => 1,
                ),
                // Category (social vs personal)
                array(
                    'key' => 'field_mission_category',
                    'label' => 'Mission Category',
                    'name' => 'category',
                    'type' => 'select',
                    'instructions' => 'Is this a community-driven (social) or individual mission?',
                    'choices' => array(
                        'social' => 'Social Mission (Community-driven)',
                        'personal' => 'Personal Mission (Individual journey)',
                    ),
                    'default_value' => 'social',
                    'allow_null' => 0,
                    'multiple' => 0,
                    'ui' => 1,
                    'return_format' => 'value',
                ),
                // Neighborhood Tags (for geographic discovery)
                array(
                    'key' => 'field_mission_neighborhood_tags',
                    'label' => 'Neighborhood Tags',
                    'name' => 'neighborhood_tags',
                    'type' => 'text',
                    'instructions' => 'Comma-separated neighborhood tags (e.g., "Hamra", "Dahiye", "Achrafieh", "Ras Beirut")',
                    'placeholder' => 'Hamra, Dahiye, Achrafieh',
                ),
                // Decade Tags (for time-based discovery)
                array(
                    'key' => 'field_mission_decade_tags',
                    'label' => 'Decade Tags',
                    'name' => 'decade_tags',
                    'type' => 'text',
                    'instructions' => 'Comma-separated decade tags (e.g., "1970s", "1980s", "1990s", "2000s")',
                    'placeholder' => '1970s, 1980s',
                ),
                // Theme Tags (for thematic discovery)
                array(
                    'key' => 'field_mission_theme_tags',
                    'label' => 'Theme Tags',
                    'name' => 'theme_tags',
                    'type' => 'text',
                    'instructions' => 'Comma-separated theme tags (e.g., "war", "reconstruction", "daily life", "family", "resistance")',
                    'placeholder' => 'war, daily life, family',
                ),
                // Rejection Reason (for admin to explain why mission was rejected)
                array(
                    'key' => 'field_mission_rejection_reason',
                    'label' => 'Rejection Reason (سبب الرفض)',
                    'name' => 'rejection_reason',
                    'type' => 'textarea',
                    'instructions' => 'If rejecting this mission, please provide a reason in Arabic. The creator will see this message. Examples: المحتوى غير مناسب، معلومات غير دقيقة، موقع غير صحيح',
                    'placeholder' => 'اكتب سبب رفض المهمة هنا...',
                    'rows' => 3,
                    'conditional_logic' => 0,
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
            'menu_order' => 0,
            'position' => 'normal',
            'style' => 'default',
            'label_placement' => 'top',
            'instruction_placement' => 'label',
            'hide_on_screen' => '',
            'active' => true,
            'description' => 'Fields for mission location, type, and settings',
        ));
    }
}
