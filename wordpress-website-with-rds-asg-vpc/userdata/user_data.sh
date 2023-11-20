#!/bin/bash
apt update -y
apt install -y apache2 php php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
apt-get install -y awscli
service apache2 restart
# Configure WordPress to use RDS MySQL
echo "<?php
    define('DB_NAME', 'wordpress');
    define('DB_USER', 'admin');
    define('DB_PASSWORD', 'admin123'); // Replace with your actual DB password
    define('DB_HOST', '${aws_db_instance.wordpress.endpoint}');
    define('DB_CHARSET', 'utf8');
    define('DB_COLLATE', '');

    define('AUTH_KEY',         'your-unique-keys-here');
    define('SECURE_AUTH_KEY',  'your-unique-keys-here');
    define('LOGGED_IN_KEY',    'your-unique-keys-here');
    define('NONCE_KEY',        'your-unique-keys-here');
    define('AUTH_SALT',        'your-unique-keys-here');
    define('SECURE_AUTH_SALT', 'your-unique-keys-here');
    define('LOGGED_IN_SALT',   'your-unique-keys-here');
    define('NONCE_SALT',       'your-unique-keys-here');

    \$table_prefix = 'wp_';
    define('WP_DEBUG', false);
    if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');
    require_once(ABSPATH . 'wp-settings.php');
    " > /var/www/html/wp-config.php
service apache2 restart
echo '*/5 * * * * aws s3 cp /var/log/myapp/ s3://my-wordpress-logs-bucket/ --recursive' | crontab -