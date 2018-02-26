UPDATE mysql.user SET Password = PASSWORD('P@sswOrd') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' or Db='test\\_%';
