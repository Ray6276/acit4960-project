scpath="$( cd "$(dirname "$0")"; pwd -P)"
cd ${scpath}
useradd admin -p P@ssw0rd -g wheel


# copy the key from physical laptop
\cp ../conf_file/acit_admin_id_rsa.pub ~/.ssh/authorized_keys

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

systemctl start mariadb

#the following block needs to be edit


mysql -u root -p < /${scpath}/mariadb_security_config.sql

systemctl enable mariadb

##PHP Setup

yum -y install php
yum -y install php-mysql
yum -y install php-fpm

\cp ../conf_file/php.ini /etc

\cp ../conf_file/www.conf /etc/php-fpm.d

systemctl start php-fpm
systemctl enable php-fpm


#config nginx file
\cp ../conf_file/nginx.conf /etc/nginx


echo "<?php phpinfo(); ?>" >> /usr/share/nginx/html/info.php

systemctl restart nginx



mysql -u root -p < /${scpath}/wp_mariadb_config.sql
expect P@ssw0rd

wget http://wordpress.org/latest.tar.gz

tar xzvf latest.tar.gz

\cp wordpress/wp-config-sample.php wordpress/wp-config.php


\cp ../conf_file/wp-config.php ./wordpress/wp-config.php


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
