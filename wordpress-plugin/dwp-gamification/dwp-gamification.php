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

        // Load text domain
        load_plugin_textdomain('dwp-gamification', false, dirname(DWP_GAMIFICATION_BASENAME) . '/languages');
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
