# file necessario per poter leggere il log di mysql
touch mysql/mysql.log

# usare il seguente comando per evitare di aggiornare il git
# git update-index --assume-unchanged mysql/mysql.log

docker-compose up

