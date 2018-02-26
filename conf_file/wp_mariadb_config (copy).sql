CREATE DATABASE wordpress;
CREATE USER wordpress_user@localhost IDENTIFIED BY 'P@ssw0rd';
GRABT ALL PRIVILEGES ON wordpress.* TO wordpress_user@localhost;
FLUSH PRIVILEGES;
