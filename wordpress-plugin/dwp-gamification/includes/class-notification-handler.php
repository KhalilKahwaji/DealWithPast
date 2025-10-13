<?php
/**
 * Notification Handler
 * Manages in-app notifications and FCM push notifications (Phase 2)
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class DWP_Notification_Handler {

    /**
     * Constructor
     */
    public function __construct() {
        add_action('rest_api_init', array($this, 'register_notification_routes'));
        // FCM sending will be implemented in Phase 2
    }

    /**
     * Register REST API routes
     */
    public function register_notification_routes() {
        // Get user notifications
        register_rest_route('dwp/v1', '/notifications', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_notifications'),
            'permission_callback' => function() {
                return is_user_logged_in();
            },
            'args' => array(
                'unread_only' => array(
                    'default' => false,
                    'type' => 'boolean',
                ),
                'limit' => array(
                    'default' => 50,
                    'type' => 'integer',
                ),
            ),
        ));

        // Mark notification as read
        register_rest_route('dwp/v1', '/notifications/(?P<id>\d+)/read', array(
            'methods' => 'POST',
            'callback' => array($this, 'mark_as_read'),
            'permission_callback' => function() {
                return is_user_logged_in();
            },
        ));

        // Mark all notifications as read
        register_rest_route('dwp/v1', '/notifications/read-all', array(
            'methods' => 'POST',
            'callback' => array($this, 'mark_all_as_read'),
            'permission_callback' => function() {
                return is_user_logged_in();
            },
        ));

        // Get unread count
        register_rest_route('dwp/v1', '/notifications/unread-count', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_unread_count'),
            'permission_callback' => function() {
                return is_user_logged_in();
            },
        ));

        // Register FCM token (Phase 2)
        register_rest_route('dwp/v1', '/notifications/register-token', array(
            'methods' => 'POST',
            'callback' => array($this, 'register_fcm_token'),
            'permission_callback' => function() {
                return is_user_logged_in();
            },
            'args' => array(
                'fcm_token' => array(
                    'required' => true,
                    'type' => 'string',
                ),
            ),
        ));
    }

    /**
     * Get user notifications
     */
    public function get_notifications($request) {
        $user_id = get_current_user_id();
        $unread_only = $request->get_param('unread_only');
        $limit = intval($request->get_param('limit'));

        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $where = "user_id = %d";
        $params = array($user_id);

        if ($unread_only) {
            $where .= " AND read_status = 0";
        }

        $sql = $wpdb->prepare(
            "SELECT * FROM $table WHERE $where ORDER BY sent_at DESC LIMIT %d",
            array_merge($params, array($limit))
        );

        $notifications = $wpdb->get_results($sql, ARRAY_A);

        // Parse JSON data field
        foreach ($notifications as &$notification) {
            if (!empty($notification['data'])) {
                $notification['data'] = json_decode($notification['data'], true);
            }
        }

        return rest_ensure_response(array(
            'success' => true,
            'count' => count($notifications),
            'notifications' => $notifications,
        ));
    }

    /**
     * Mark notification as read
     */
    public function mark_as_read($request) {
        $notification_id = intval($request->get_param('id'));
        $user_id = get_current_user_id();

        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        // Verify notification belongs to user
        $notification = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $table WHERE id = %d AND user_id = %d",
            $notification_id, $user_id
        ));

        if (!$notification) {
            return new WP_Error('not_found', 'Notification not found', array('status' => 404));
        }

        // Update read status
        $wpdb->update(
            $table,
            array('read_status' => 1),
            array('id' => $notification_id, 'user_id' => $user_id),
            array('%d'),
            array('%d', '%d')
        );

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Notification marked as read',
        ));
    }

    /**
     * Mark all notifications as read
     */
    public function mark_all_as_read($request) {
        $user_id = get_current_user_id();

        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $updated = $wpdb->update(
            $table,
            array('read_status' => 1),
            array('user_id' => $user_id, 'read_status' => 0),
            array('%d'),
            array('%d', '%d')
        );

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'All notifications marked as read',
            'count_updated' => $updated,
        ));
    }

    /**
     * Get unread notification count
     */
    public function get_unread_count($request) {
        $user_id = get_current_user_id();

        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $count = (int) $wpdb->get_var($wpdb->prepare(
            "SELECT COUNT(*) FROM $table WHERE user_id = %d AND read_status = 0",
            $user_id
        ));

        return rest_ensure_response(array(
            'success' => true,
            'unread_count' => $count,
        ));
    }

    /**
     * Register FCM token (for push notifications - Phase 2)
     */
    public function register_fcm_token($request) {
        $user_id = get_current_user_id();
        $fcm_token = sanitize_text_field($request->get_param('fcm_token'));

        // Store FCM token in user meta
        update_user_meta($user_id, 'fcm_token', $fcm_token);
        update_user_meta($user_id, 'fcm_token_updated', current_time('timestamp'));

        return rest_ensure_response(array(
            'success' => true,
            'message' => 'FCM token registered successfully',
        ));
    }

    /**
     * Send FCM push notification (Phase 2 implementation)
     *
     * @param int $user_id User ID to send notification to
     * @param int $notification_id Notification ID from database
     * @return bool Success status
     */
    public function send_fcm_notification($user_id, $notification_id) {
        // TODO: Phase 2 - Implement Firebase Cloud Messaging
        // This is a placeholder for Phase 2 development

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

        // Phase 2: Add FCM API call here
        // Reference: https://firebase.google.com/docs/cloud-messaging/send-message

        /*
        $fcm_data = array(
            'to' => $fcm_token,
            'notification' => array(
                'title' => $notification->title,
                'body' => $notification->body,
                'sound' => 'default',
                'badge' => '1',
            ),
            'data' => json_decode($notification->data, true),
        );

        $headers = array(
            'Authorization: key=' . get_option('dwp_fcm_server_key'),
            'Content-Type: application/json',
        );

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fcm_data));
        $result = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($http_code === 200) {
            // Mark as sent
            $wpdb->update(
                $table,
                array('fcm_sent' => 1),
                array('id' => $notification_id)
            );
            return true;
        }
        */

        return false;
    }

    /**
     * Create a notification (helper method)
     *
     * @param int $user_id User ID to send notification to
     * @param string $type Notification type (achievement_unlocked, new_follower, etc.)
     * @param string $title Notification title
     * @param string $body Notification body
     * @param array $data Additional data (optional)
     * @return int|false Notification ID or false on failure
     */
    public static function create_notification($user_id, $type, $title, $body, $data = array()) {
        global $wpdb;
        $table = $wpdb->prefix . 'dwp_notifications';

        $inserted = $wpdb->insert($table, array(
            'user_id' => $user_id,
            'type' => sanitize_text_field($type),
            'title' => sanitize_text_field($title),
            'body' => sanitize_textarea_field($body),
            'data' => !empty($data) ? json_encode($data) : null,
            'read_status' => 0,
            'fcm_sent' => 0,
        ));

        if ($inserted) {
            $notification_id = $wpdb->insert_id;

            // Phase 2: Trigger FCM sending
            // do_action('dwp_send_fcm_notification', $user_id, $notification_id);

            return $notification_id;
        }

        return false;
    }
}
