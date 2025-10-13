<?php
/**
 * Database schema for DWP Gamification
 * Creates tables: wp_user_missions, wp_user_achievements, wp_dwp_notifications
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

/**
 * Create gamification database tables
 */
function dwp_create_gamification_tables() {
    global $wpdb;

    $charset_collate = $wpdb->get_charset_collate();
    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');

    // Table 1: User Missions (tracking user progress on missions)
    $table_user_missions = $wpdb->prefix . 'user_missions';
    $sql_user_missions = "CREATE TABLE IF NOT EXISTS $table_user_missions (
        id bigint(20) NOT NULL AUTO_INCREMENT,
        user_id bigint(20) NOT NULL,
        mission_id bigint(20) NOT NULL,
        status varchar(20) DEFAULT 'active',
        started_at datetime DEFAULT CURRENT_TIMESTAMP,
        completed_at datetime NULL,
        progress int(3) DEFAULT 0,
        proof_media longtext NULL COMMENT 'JSON array of image URLs',
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
        type varchar(30) NOT NULL COMMENT 'achievement_unlocked, new_follower, mission_completed, etc',
        title varchar(255) NOT NULL,
        body text NOT NULL,
        data longtext NULL COMMENT 'JSON data for notification',
        read_status tinyint(1) DEFAULT 0,
        sent_at datetime DEFAULT CURRENT_TIMESTAMP,
        fcm_sent tinyint(1) DEFAULT 0 COMMENT 'Firebase Cloud Messaging sent flag',
        PRIMARY KEY (id),
        KEY user_id (user_id),
        KEY type (type),
        KEY read_status (read_status),
        KEY sent_at (sent_at)
    ) $charset_collate;";

    // Create tables using dbDelta (handles updates safely)
    dbDelta($sql_user_missions);
    dbDelta($sql_user_achievements);
    dbDelta($sql_notifications);

    // Log table creation
    if (function_exists('error_log')) {
        error_log('DWP Gamification: Database tables created/updated');
    }
}
