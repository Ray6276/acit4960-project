CREATE DATABASE wordpress;
CREATE USER wordpress_user@localhost IDENTIFIED BY 'P@sswOrd';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpress_user@localhost;

FLUSH PRIVILEGES;
