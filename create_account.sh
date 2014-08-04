#!/bin/bash

# forked from http://goo.gl/LW1Ahp

HOST=$(hostname -I)
if [[ ! -d /var/lib/mysql/mysql ]]; then
    mysql_install_db > /dev/null
    /usr/bin/mysqld_safe &

    ID=${MARIADB_ID:-admin}
    PASS=${MARIADB_PASS:-$(pwgen -n 70)}

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MariaDB service startup"
        sleep 5
        mysql -uroot -e "status"
        RET=$?
    done

    mysql -uroot -e "CREATE USER '$ID'@'%' IDENTIFIED BY '$PASS'"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$ID'@'%' WITH GRANT OPTION"

    echo "========================================================================"
    echo "You can now connect to this MariaDB Server using:"
    echo ""
    if [ $MARIADB_PASS ]
    then
        echo "    mysql -u$ID -p<MARIADB_PASS> -h$HOST"
    else
        echo "    mysql -u$ID -p$PASS -h$HOST"
    fi
    echo ""
    echo "Please remember to change the above password as soon as possible!"
    echo "MariaDB user 'root' has no password but only allows local connections"
    echo "========================================================================"
    mysqladmin -uroot shutdown

    RET=1
    while [[ RET -eq 1 ]]; do
        echo "=> Waiting for confirmation of MariaDB service stop"
        sleep 5
        mysql -uroot -e "status" > /dev/null &
        RET=$?
        echo $RET
    done
else
    echo "Using an existing volume of MariaDB"
    echo "host is $HOST"
fi

/usr/bin/mysqld_safe
