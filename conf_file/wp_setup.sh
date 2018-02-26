
echo "DEVICE=enp0s3" > /etc/sysconfig/netowrk-scripts/ifcfg-enp0s3
echo "IPADDR=192.168.254.10" >> /etc/sysconfig/netowrk-scripts/ifcfg-enp0s3
echo "NETMASK=255.255.255.0" >> /etc/sysconfig/netowrk-scripts/ifcfg-enp0s3
echo "GATEWAY=192.168.254.1" >> /etc/sysconfig/netowrk-scripts/ifcfg-enp0s3
echo "ONBOOT=YES" >> /etc/sysconfig/netowrk-scripts/ifcfg-enp0s3


echo "nameserver 8.8.8.8" > /etc/resolv.conf


echo "HOSTNAME=wp/snp.acit" > /etc/sysconfig/network

systemctl enable network

systemctl restart network

useradd admin -p P@ssw0rd -g wheel


# copy the key from physical laptop
cp acit_admin_id_rsa.pub ~/.ssh/authorized_keys

yum -y install epel-release 
yum -y install vim
yum -y install git
yum -y install tcpdump
yum -y install nmap-ncat
yum -y install curl

firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent

yum -y install nginx

systemctl start nginx
systemctl enable nginx

# MariaDB Setup
yum -y install mariadb-server
yum -y install mariadb

systectl start mariadb

#the following block needs to be edit
mysql_secure_installation 
expect P@ssw0rd
expect P@ssw0rd
expect Y
expect Y
expect Y
expect Y

echo "UPDATE mysql.user SET Password=PASSWORD('P@ssw0rd') WHERE User='root';" > mariadb_security_config.sql

echo "DELETE FROM mysql.user WHERE User='';" >> mariadb_security_config.sql

echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> mariadb_security_config.sql

echo "DROP DATABASE test;" >> mariadb_security_config.sql

echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" >> mariadb_security_config.sql

mysql -u root -p < mariadb_security_config.sql
expect P@ssw0rd
systemctl enable mariadb

##PHP Setup

yum -y install php
yum -y install php-mysql
yum -y install php-fpm

sed -i '763 s/.*/cgi.fix_pathinfo=0/' /etc/php.ini

sed -i '12 s/.*/listen = \/var\/run\/php-fpm\/php-fpm.sock/' /etc/php-fpm.d/www.conf

sed -i '31 s/.*/listen.owner = nobody/' /etc/php-fpm.d/www.conf

sed -i '32 s/.*/listen.group = nobody/' /etc/php-fpm.d/www.conf

sed -i '39 s/.*/user = nginx/' /etc/php-fpm.d/www.conf

sed -i '41 s/.*/group = nginx/' /etc/php-fpm.d/www.conf

systemctl strat php-fpm
systemctl enable php-fpm


#config nginx file
sed -i '10 d' /etc/nginx/nginx.conf
sed -i '11 d' /etc/nginx/nginx.conf
sed -i '12 d' /etc/nginx/nginx.conf
sed -i '40 i\        location ~ \.php$ {\' /etc/nginx/nginx.conf
sed -i '55 i\            try_files $uri =404;\' /etc/nginx/nginx.conf
sed -i '40 i\            fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;\' /etc/nginx/nginx.conf
sed -i '40 i\           fastcgi_index index.php;\' /etc/nginx/nginx.conf
sed -i '40 i\            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;\' /etc/nginx/nginx.conf
sed -i '40 i\            include fastcgi_params;\' /etc/nginx/nginx.conf
sed -i '40 i\        }\' /etc/nginx/nginx.conf

echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/info.php

systemctl restart nginx

echo "CREATE DATABASE wordpress;" > wp_mariadb_config.sql

echo "CREATE USER wordpress_user@localhost IDENTIFIED BY 'P@ssw0rd';" >>wp_mariadb_config.sql

echo "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress_user@localhost;" >>wp_mariadb_config.sql

echo "FLUSH PRIVILEGES;" >>wp_mariadb_config.sql

mysql -u root -p < wp_mariadb_config.sql
expect P@ssw0rd

wget http://wordpress.org/latest.tar.gz

tar xzvf latest.tar.gz

cp wordpress/wp-config-sample.php wordpress/wp-config.php


sed -i "23 s/.*/define('DB_NAME', 'wordpress');/" ./wordpress/wp-config.php

sed -i "26 s/.*/define('DB_USER', 'wordpress_user');/" ./wordpress/wp-config.php

sed -i "29 s/.*/define('DB_PASSWORD', 'P@ssw0rd');/" ./wordpress/wp-config.php

sed -i "32 s/.*/define('DB_HOST', 'localhost');/" ./wordpress/wp-config.php

sed -i "35 s/.*/define('DB_CHARSET', 'utf8');/" ./wordpress/wp-config.php

sed -i "38 s/.*/define('DB_COLLATE\', '');/" ./wordpress/wp-config.php

rsync -avP ./wordpress/ /usr/share/nginx/html/

mkdir /usr/share/nginx/html/wp-content/uploads

chown -R admin:nginx /usr/share/nginx/html/*

#install virtualbox guest additions
yum -y install kernel-devel kernel-headers dkms gcc gcc-c++ kexec-tools

# Creating mount point, mounting, and installing VirtualBox Guest Additions
# Assumes that the virtualbox guest additions CD is in /dev/cdrom
mkdir vbox_cd
mount /dev/cdrom ./vbox_cd
./vbox_cd/VBoxLinuxAdditions.run
umount ./vbox_cd
rmdir ./vbox_cd
