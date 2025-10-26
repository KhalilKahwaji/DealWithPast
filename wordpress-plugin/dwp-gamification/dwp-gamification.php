<?php
/**
 * Plugin Name: DWP Gamification
 * Plugin URI: https://dwp.world
 * Description: Gamification system for DealWithPast - Missions, Achievements, and Memorial Plaques
 * Version: 1.1.0
 * Author: Ziad (UNDP DealWithPast Team)
 * Author URI: https://dwp.world
 * Text Domain: dwp-gamification
 * Domain Path: /languages
 * Requires at least: 6.0
 * Requires PHP: 7.4
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Plugin constants
define('DWP_GAMIFICATION_VERSION', '1.1.0');
define('DWP_GAMIFICATION_PATH', plugin_dir_path(__FILE__));
define('DWP_GAMIFICATION_URL', plugin_dir_url(__FILE__));
define('DWP_GAMIFICATION_BASENAME', plugin_basename(__FILE__));

/**
 * Main plugin class
 */
class DWP_Gamification {

    /**
     * Single instance of the class
     */
    private static $instance = null;

    /**
     * Get instance
     */
    public static function get_instance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Constructor
     */
    private function __construct() {
        // Load dependencies
        $this->load_dependencies();

        // Initialize hooks
        add_action('plugins_loaded', array($this, 'init'));

        // Activation/Deactivation hooks
        register_activation_hook(__FILE__, array($this, 'activate'));
        register_deactivation_hook(__FILE__, array($this, 'deactivate'));
    }

    /**
     * Load plugin dependencies
     */
    private function load_dependencies() {
        // Database schema
        require_once DWP_GAMIFICATION_PATH . 'database/schema.php';

        // Core classes
        require_once DWP_GAMIFICATION_PATH . 'includes/class-mission-cpt.php';
        require_once DWP_GAMIFICATION_PATH . 'includes/class-api-endpoints.php';
        require_once DWP_GAMIFICATION_PATH . 'includes/class-achievement-manager.php';
        require_once DWP_GAMIFICATION_PATH . 'includes/class-notification-handler.php';
        require_once DWP_GAMIFICATION_PATH . 'includes/class-admin-ui.php';
    }

    /**
     * Initialize plugin
     */
    public function init() {
        // Check if ACF is active
        if (!function_exists('acf_add_local_field_group')) {
            add_action('admin_notices', array($this, 'acf_missing_notice'));
            return;
        }

        // Initialize components
        new DWP_Mission_CPT();
        new DWP_API_Endpoints();
        new DWP_Achievement_Manager();
        new DWP_Notification_Handler();

        // Initialize admin UI (only in admin)
        if (is_admin()) {
            new DWP_Admin_UI();
        }

        // Setup deep linking for missions
        add_action('template_redirect', array($this, 'handle_mission_deep_link'));

        // Load text domain
        load_plugin_textdomain('dwp-gamification', false, dirname(DWP_GAMIFICATION_BASENAME) . '/languages');
    }

    /**
     * Handle deep linking for mission URLs
     * Redirects https://dwp.world/mission/{id} to dwp://mission/{id} on mobile
     */
    public function handle_mission_deep_link() {
        // Only process if we're on a mission single page
        if (!is_singular('mission')) {
            return;
        }

        // Get the mission ID
        $mission_id = get_the_ID();
        if (!$mission_id) {
            return;
        }

        // Check if user is on mobile device
        $user_agent = isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';
        $is_mobile = preg_match('/(android|iphone|ipad|mobile)/i', $user_agent);

        // Only redirect on mobile
        if (!$is_mobile) {
            return;
        }

        // Build deep link URL
        $deep_link = 'dwp://mission/' . $mission_id;

        // Redirect to app with fallback
        ?>
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Opening in DealWithPast App...</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    font-family: 'Tajawal', -apple-system, BlinkMacSystemFont, sans-serif;
                    text-align: center;
                    padding: 50px 20px;
                    background: linear-gradient(135deg, #5A7C59 0%, #8B5A5A 100%);
                    color: white;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                }
                .spinner {
                    border: 4px solid rgba(255, 255, 255, 0.3);
                    border-radius: 50%;
                    border-top: 4px solid white;
                    width: 50px;
                    height: 50px;
                    animation: spin 1s linear infinite;
                    margin: 30px auto;
                }
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
                .message {
                    font-size: 18px;
                    margin: 20px 0;
                }
                .fallback {
                    margin-top: 30px;
                    font-size: 14px;
                    opacity: 0.9;
                }
                a {
                    color: #F5F0E8;
                    text-decoration: underline;
                }
            </style>
        </head>
        <body>
            <h1>📍 خارطة وذاكرة</h1>
            <div class="spinner"></div>
            <p class="message">Opening mission in app...</p>
            <p class="fallback">
                Don't have the app? <a href="https://play.google.com/store">Download here</a>
            </p>
            <script>
                // Attempt to open the app
                window.location.href = '<?php echo esc_js($deep_link); ?>';

                // If app doesn't open after 2 seconds, show fallback
                setTimeout(function() {
                    document.querySelector('.message').textContent = 'App not installed?';
                }, 2000);
            </script>
        </body>
        </html>
        <?php
        exit;
    }

    /**
     * Plugin activation
     */
    public function activate() {
        // Create database tables
        dwp_create_gamification_tables();

        // Flush rewrite rules
        flush_rewrite_rules();

        // Set activation flag
        add_option('dwp_gamification_activated', time());
    }

    /**
     * Plugin deactivation
     */
    public function deactivate() {
        // Flush rewrite rules
        flush_rewrite_rules();
    }

    /**
     * ACF missing notice
     */
    public function acf_missing_notice() {
        ?>
        <div class="notice notice-error">
            <p>
                <strong>DWP Gamification:</strong>
                This plugin requires Advanced Custom Fields (ACF) Pro to be installed and activated.
            </p>
        </div>
        <?php
    }
}

/**
 * Initialize the plugin
 */
function dwp_gamification() {
    return DWP_Gamification::get_instance();
}

// Start the plugin
dwp_gamification();
