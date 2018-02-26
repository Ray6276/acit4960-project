UPDATE mysql.user SET Password = PASSWORD("P@ssw0rd") WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' or DB='test\\_%';
