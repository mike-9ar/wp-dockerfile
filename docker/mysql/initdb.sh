#!/bin/bash

MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:-"mysql"}
MYSQL_USER=${MYSQL_USER:-"user"}
MYSQL_USER_PWD=${MYSQL_USER_PWD:-"def_password"}
MYSQL_USER_DB=${MYSQL_USER_DB:-"my_db"}

if [ -d "/var/lib/mysql/$MYSQL_USER_DB" ]; then
    echo '[i] El directorio '$MYSQL_USER_DB' ya existe, omitiendo generación de la DB'
else

    echo "[i] El directorio '$MYSQL_USER_DB' no existe, creando las DBs iniciales"

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Esperando inicio del servidor MySql ..."
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done

    # Creamos el usuarios por defecto
    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    echo "[i] Creando archivo temporal: $tfile"
    cat <<EOF > $tfile
USE mysql;
CREATE USER '$MYSQL_USER'@localhost IDENTIFIED BY '$MYSQL_USER_PWD';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@localhost WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
>> $tfile

    # run sql in tempfile
    echo "[i] Creando usuario: $tfile"
    mysql -uroot < $tfile
    rm -f $tfile

    echo "=> Volcado inicial de la base de datos ..."
    mysql -uroot < /etc/mysql/init_db.sql

    echo "[i] Finalizado"

fi 