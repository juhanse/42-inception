<?php
// On récupère les secrets proprement
$db_password = trim(file_get_contents('/run/secrets/db_password'));

define( 'DB_NAME',     getenv('MYSQL_DATABASE') );
define( 'DB_USER',     getenv('MYSQL_USER') );
define( 'DB_PASSWORD', $db_password );
define( 'DB_HOST',     'mariadb' );

define( 'DB_CHARSET',  'utf8mb4' );
define( 'DB_COLLATE',  '' );

// Keys génériques
define('AUTH_KEY',         'Inception_42_Secret_Key');
define('SECURE_AUTH_KEY',  'Inception_42_Secret_Key');
define('LOGGED_IN_KEY',    'Inception_42_Secret_Key');
define('NONCE_KEY',        'Inception_42_Secret_Key');
define('AUTH_SALT',        'Inception_42_Secret_Key');
define('SECURE_AUTH_SALT', 'Inception_42_Secret_Key');
define('LOGGED_IN_SALT',   'Inception_42_Secret_Key');
define('NONCE_SALT',       'Inception_42_Secret_Key');

$table_prefix = 'wp_';
define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
