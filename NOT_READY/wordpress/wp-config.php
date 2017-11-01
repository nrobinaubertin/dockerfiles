<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'root');

/** MySQL database password */
define('DB_PASSWORD', 'root');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'DJf2_R~Q,qpQFYS*jA.R6ERNO/-ZI`1P!~~<f,VCu_<EiJ5:ph)o269uwhn U^eU');
define('SECURE_AUTH_KEY',  '|l91T^F*P(^-tR%W#c!z6,%T@=qlvFF[SW[g^x=>UwlTT1+-I&vgx0#8iQ~u|R61');
define('LOGGED_IN_KEY',    '78(ph[UI/}e<[IdiHHH:S*EAT[TU`{Zi`cwwE8pchxeD8f& 9N#DA%f~(2wg*/O<');
define('NONCE_KEY',        'z+3f`*aY@!PWyvA#FuE %Qi;ez$iNc4+@yU!4yKlsXi#5TC$8r8UMi=UMyyF:F<H');
define('AUTH_SALT',        'oJ)*6^EDci_5iMJZAXXiSE3!snQLmi`!*p)y[X=oH?z(dwY@[HHkxJed(0Qsx9J>');
define('SECURE_AUTH_SALT', 'qj<%$aU2pl?MO?[99yHWmr{Hx$>JwIP8,mH Kc2@-,(GktrO{)4Xj@FJsci:8p,3');
define('LOGGED_IN_SALT',   'IKFkScA7rZKjUI;s*f+QRcK{t_>,aNI67WZ|!;U{WU;a%#L^[:|tjF[QW.=-13++');
define('NONCE_SALT',       '5|IpuiuitWB+F*3|+Zv<xunV]TfI(^F2$ m2hEf<0szVEAsd4dG{X=*WL<NT2M|q');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
