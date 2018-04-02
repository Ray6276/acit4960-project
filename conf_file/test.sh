scpath="$( cd "$(dirname "$0")"; pwd -P)"
echo ${scpath}
\cp /${scpath}/www.conf /etc/php-fpm.d

