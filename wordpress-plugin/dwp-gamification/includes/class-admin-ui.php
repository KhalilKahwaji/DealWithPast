<?php
/**
 * Admin UI for Mission Moderation
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class DWP_Admin_UI {

    /**
     * Constructor
     */
    public function __construct() {
        // Add admin menu
        add_action('admin_menu', array($this, 'add_admin_menu'));

        // Add custom columns to missions list
        add_filter('manage_mission_posts_columns', array($this, 'add_mission_columns'));
        add_action('manage_mission_posts_custom_column', array($this, 'render_mission_columns'), 10, 2);

        // Add custom filters
        add_action('restrict_manage_posts', array($this, 'add_mission_filters'));
        add_filter('parse_query', array($this, 'filter_missions_by_meta'));

        // Add quick actions
        add_filter('post_row_actions', array($this, 'add_quick_actions'), 10, 2);

        // Handle AJAX actions
        add_action('wp_ajax_dwp_approve_mission', array($this, 'ajax_approve_mission'));
        add_action('wp_ajax_dwp_reject_mission', array($this, 'ajax_reject_mission'));

        // Add admin styles
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_styles'));
    }

    /**
     * Add admin menu page
     */
    public function add_admin_menu() {
        add_submenu_page(
            'edit.php?post_type=mission',
            'Pending Missions',
            'Pending <span class="awaiting-mod count-' . $this->get_pending_count() . '"><span class="pending-count">' . $this->get_pending_count() . '</span></span>',
            'edit_posts',
            'pending-missions',
            array($this, 'render_pending_missions_page')
        );
    }

    /**
     * Get count of pending missions
     */
    private function get_pending_count() {
        $query = new WP_Query(array(
            'post_type' => 'mission',
            'post_status' => 'pending',
            'posts_per_page' => -1,
            'fields' => 'ids',
        ));
        return $query->found_posts;
    }

    /**
     * Render pending missions page
     */
    public function render_pending_missions_page() {
        $pending_missions = new WP_Query(array(
            'post_type' => 'mission',
            'post_status' => 'pending',
            'posts_per_page' => 50,
            'orderby' => 'date',
            'order' => 'DESC',
        ));

        ?>
        <div class="wrap">
            <h1>Pending Missions - Awaiting Approval</h1>
            <p class="description">Review and approve user-submitted missions. All missions require approval before being published.</p>

            <?php if ($pending_missions->have_posts()) : ?>
                <table class="wp-list-table widefat fixed striped">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Difficulty</th>
                            <th>Location</th>
                            <th>Author</th>
                            <th>Submitted</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php while ($pending_missions->have_posts()) : $pending_missions->the_post(); ?>
                            <?php
                            $mission_id = get_the_ID();
                            $category = get_field('category', $mission_id);
                            $difficulty = get_field('difficulty', $mission_id);
                            $address = get_field('address', $mission_id);
                            $author = get_the_author();
                            ?>
                            <tr id="mission-<?php echo $mission_id; ?>">
                                <td>
                                    <strong>
                                        <a href="<?php echo get_edit_post_link($mission_id); ?>">
                                            <?php echo get_the_title(); ?>
                                        </a>
                                    </strong>
                                    <div class="row-actions">
                                        <span class="edit">
                                            <a href="<?php echo get_edit_post_link($mission_id); ?>">Edit</a> |
                                        </span>
                                        <span class="view">
                                            <a href="<?php echo get_preview_post_link($mission_id); ?>" target="_blank">Preview</a>
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <?php if ($category === 'personal') : ?>
                                        <span class="dashicons dashicons-heart" style="color: #e91e63;"></span> Personal
                                    <?php else : ?>
                                        <span class="dashicons dashicons-groups" style="color: #4caf50;"></span> Social
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <?php
                                    $color = ($difficulty === 'easy') ? '#4caf50' : (($difficulty === 'medium') ? '#ff9800' : '#f44336');
                                    echo '<span style="color: ' . $color . ';">● ' . ucfirst($difficulty) . '</span>';
                                    ?>
                                </td>
                                <td><?php echo esc_html($address ?: 'N/A'); ?></td>
                                <td><?php echo esc_html($author); ?></td>
                                <td><?php echo human_time_diff(get_the_time('U'), current_time('timestamp')) . ' ago'; ?></td>
                                <td>
                                    <button class="button button-primary dwp-approve-mission" data-mission-id="<?php echo $mission_id; ?>">
                                        <span class="dashicons dashicons-yes" style="vertical-align: middle;"></span> Approve
                                    </button>
                                    <button class="button dwp-reject-mission" data-mission-id="<?php echo $mission_id; ?>">
                                        <span class="dashicons dashicons-no" style="vertical-align: middle;"></span> Reject
                                    </button>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    </tbody>
                </table>
            <?php else : ?>
                <div class="notice notice-success">
                    <p><strong>✓ All caught up!</strong> No pending missions to review.</p>
                </div>
            <?php endif; ?>

            <?php wp_reset_postdata(); ?>
        </div>

        <script>
        jQuery(document).ready(function($) {
            // Approve mission
            $('.dwp-approve-mission').on('click', function() {
                var button = $(this);
                var missionId = button.data('mission-id');

                if (!confirm('Approve this mission and publish it?')) {
                    return;
                }

                button.prop('disabled', true).text('Approving...');

                $.ajax({
                    url: ajaxurl,
                    type: 'POST',
                    data: {
                        action: 'dwp_approve_mission',
                        mission_id: missionId,
                        nonce: '<?php echo wp_create_nonce('dwp_approve_mission'); ?>'
                    },
                    success: function(response) {
                        if (response.success) {
                            $('#mission-' + missionId).fadeOut(400, function() {
                                $(this).remove();
                                if ($('tbody tr').length === 0) {
                                    location.reload();
                                }
                            });
                        } else {
                            alert('Error: ' + response.data.message);
                            button.prop('disabled', false).html('<span class="dashicons dashicons-yes"></span> Approve');
                        }
                    },
                    error: function() {
                        alert('Network error. Please try again.');
                        button.prop('disabled', false).html('<span class="dashicons dashicons-yes"></span> Approve');
                    }
                });
            });

            // Reject mission
            $('.dwp-reject-mission').on('click', function() {
                var button = $(this);
                var missionId = button.data('mission-id');
                var reason = prompt('Optional: Provide a reason for rejection');

                if (reason === null) { // User cancelled
                    return;
                }

                button.prop('disabled', true).text('Rejecting...');

                $.ajax({
                    url: ajaxurl,
                    type: 'POST',
                    data: {
                        action: 'dwp_reject_mission',
                        mission_id: missionId,
                        reason: reason,
                        nonce: '<?php echo wp_create_nonce('dwp_reject_mission'); ?>'
                    },
                    success: function(response) {
                        if (response.success) {
                            $('#mission-' + missionId).fadeOut(400, function() {
                                $(this).remove();
                                if ($('tbody tr').length === 0) {
                                    location.reload();
                                }
                            });
                        } else {
                            alert('Error: ' + response.data.message);
                            button.prop('disabled', false).html('<span class="dashicons dashicons-no"></span> Reject');
                        }
                    },
                    error: function() {
                        alert('Network error. Please try again.');
                        button.prop('disabled', false).html('<span class="dashicons dashicons-no"></span> Reject');
                    }
                });
            });
        });
        </script>
        <?php
    }

    /**
     * Add custom columns to missions list
     */
    public function add_mission_columns($columns) {
        $new_columns = array();

        foreach ($columns as $key => $title) {
            $new_columns[$key] = $title;

            if ($key === 'title') {
                $new_columns['category'] = 'Category';
                $new_columns['difficulty'] = 'Difficulty';
                $new_columns['location'] = 'Location';
                $new_columns['reactions'] = 'Reactions';
            }
        }

        return $new_columns;
    }

    /**
     * Render custom column content
     */
    public function render_mission_columns($column, $post_id) {
        switch ($column) {
            case 'category':
                $category = get_field('category', $post_id);
                if ($category === 'personal') {
                    echo '<span class="dashicons dashicons-heart" style="color: #e91e63;"></span> Personal';
                } else {
                    echo '<span class="dashicons dashicons-groups" style="color: #4caf50;"></span> Social';
                }
                break;

            case 'difficulty':
                $difficulty = get_field('difficulty', $post_id);
                $color = ($difficulty === 'easy') ? '#4caf50' : (($difficulty === 'medium') ? '#ff9800' : '#f44336');
                echo '<span style="color: ' . $color . ';">● ' . ucfirst($difficulty) . '</span>';
                break;

            case 'location':
                $address = get_field('address', $post_id);
                echo esc_html($address ?: 'N/A');
                break;

            case 'reactions':
                $category = get_field('category', $post_id);
                if ($category === 'personal') {
                    $reactions = get_field('reactions', $post_id);
                    if ($reactions && is_array($reactions)) {
                        $total = count($reactions['pray']) + count($reactions['heart']) + count($reactions['smile']) + count($reactions['cry']);
                        echo '🙏 ' . count($reactions['pray']) . ' ';
                        echo '❤️ ' . count($reactions['heart']) . ' ';
                        echo '😊 ' . count($reactions['smile']) . ' ';
                        echo '😢 ' . count($reactions['cry']);
                        echo ' <small>(' . $total . ' total)</small>';
                    } else {
                        echo '—';
                    }
                } else {
                    echo '—';
                }
                break;
        }
    }

    /**
     * Add filters to missions list
     */
    public function add_mission_filters() {
        global $typenow;

        if ($typenow === 'mission') {
            // Category filter
            $category = isset($_GET['category']) ? $_GET['category'] : '';
            ?>
            <select name="category">
                <option value="">All Categories</option>
                <option value="social" <?php selected($category, 'social'); ?>>Social</option>
                <option value="personal" <?php selected($category, 'personal'); ?>>Personal</option>
            </select>

            <?php
            // Difficulty filter
            $difficulty = isset($_GET['difficulty']) ? $_GET['difficulty'] : '';
            ?>
            <select name="difficulty">
                <option value="">All Difficulties</option>
                <option value="easy" <?php selected($difficulty, 'easy'); ?>>Easy</option>
                <option value="medium" <?php selected($difficulty, 'medium'); ?>>Medium</option>
                <option value="hard" <?php selected($difficulty, 'hard'); ?>>Hard</option>
            </select>
            <?php
        }
    }

    /**
     * Filter missions by meta fields
     */
    public function filter_missions_by_meta($query) {
        global $pagenow, $typenow;

        if ($typenow === 'mission' && $pagenow === 'edit.php' && is_admin()) {
            $meta_query = array();

            if (isset($_GET['category']) && $_GET['category'] !== '') {
                $meta_query[] = array(
                    'key' => 'category',
                    'value' => $_GET['category'],
                );
            }

            if (isset($_GET['difficulty']) && $_GET['difficulty'] !== '') {
                $meta_query[] = array(
                    'key' => 'difficulty',
                    'value' => $_GET['difficulty'],
                );
            }

            if (!empty($meta_query)) {
                $query->set('meta_query', $meta_query);
            }
        }
    }

    /**
     * Add quick actions to mission rows
     */
    public function add_quick_actions($actions, $post) {
        if ($post->post_type === 'mission' && $post->post_status === 'pending') {
            $actions['approve'] = '<a href="#" class="dwp-approve-mission" data-mission-id="' . $post->ID . '">Approve</a>';
        }
        return $actions;
    }

    /**
     * AJAX: Approve mission
     */
    public function ajax_approve_mission() {
        check_ajax_referer('dwp_approve_mission', 'nonce');

        if (!current_user_can('edit_posts')) {
            wp_send_json_error(array('message' => 'Permission denied'));
        }

        $mission_id = intval($_POST['mission_id']);

        wp_update_post(array(
            'ID' => $mission_id,
            'post_status' => 'publish',
        ));

        // Log approval
        update_post_meta($mission_id, '_approved_by', get_current_user_id());
        update_post_meta($mission_id, '_approved_at', current_time('mysql'));

        wp_send_json_success(array('message' => 'Mission approved and published'));
    }

    /**
     * AJAX: Reject mission
     */
    public function ajax_reject_mission() {
        check_ajax_referer('dwp_reject_mission', 'nonce');

        if (!current_user_can('edit_posts')) {
            wp_send_json_error(array('message' => 'Permission denied'));
        }

        $mission_id = intval($_POST['mission_id']);
        $reason = sanitize_textarea_field($_POST['reason']);

        wp_update_post(array(
            'ID' => $mission_id,
            'post_status' => 'draft',
        ));

        // Log rejection
        update_post_meta($mission_id, '_rejected_by', get_current_user_id());
        update_post_meta($mission_id, '_rejected_at', current_time('mysql'));
        if ($reason) {
            update_post_meta($mission_id, '_rejection_reason', $reason);
        }

        // Notify author
        $author_id = get_post_field('post_author', $mission_id);
        do_action('dwp_mission_rejected', $mission_id, $author_id, $reason);

        wp_send_json_success(array('message' => 'Mission rejected'));
    }

    /**
     * Enqueue admin styles
     */
    public function enqueue_admin_styles($hook) {
        if (strpos($hook, 'mission') !== false) {
            wp_add_inline_style('wp-admin', '
                .dwp-approve-mission { color: #4caf50; }
                .dwp-reject-mission { color: #f44336; }
                .awaiting-mod { background-color: #d54e21; }
            ');
        }
    }
}
