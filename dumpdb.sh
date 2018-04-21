docker exec mysql-server sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" books' > ./databases.sql

