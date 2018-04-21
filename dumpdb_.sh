#!/bin/bash

SQL='\
SELECT schema_name \
  FROM information_schema.schemata \
  WHERE schema_name NOT IN ("mysql","information_schema","performance_schema","sys")'

DBLIST=$(docker exec mysql-server sh -c "exec mysql -uroot -p\"\$MYSQL_ROOT_PASSWORD\" -ANBe '$SQL'")

docker exec mysql-server sh -c "exec mysqldump -uroot -p\"\$MYSQL_ROOT_PASSWORD\" --databases $DBLIST" > ./databases.sql

