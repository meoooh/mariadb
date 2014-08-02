#!/bin/bash

# forked from http://goo.gl/LW1Ahp

/usr/bin/mysqld_safe &

ID=${MARIADB_ID:-admin}
PASS=${MARIADB_PASS:-$(pwgen -n 70)}

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service startup"
    sleep 1
    mysql -uroot -e "status"
    RET=$?
done

mysql -uroot -e "CREATE USER '$ID'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$ID'@'%' WITH GRANT OPTION"

echo "========================================================================"
echo "You can now connect to this MariaDB Server using:"
echo ""
echo "    mysql -u$ID -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MariaDB user 'root' has no password but only allows local connections"
echo "========================================================================"

service mysql stop

RET=0
while [[ RET -eq 0 ]]; do
    echo "=> Waiting for confirmation of MariaDB service stop"
    sleep 1
    mysql -uroot -e "status"
    RET=$?
done

/usr/bin/mysqld_safe
