# Ambiente di sviluppo Apache+PHP+MySQL basato su

![Docker](https://blog.seeweb.it/wp-content/uploads/2015/06/homepage-docker-logo-300x248.png)


## Sofware Requirements

* Docker-CE
* Docker-compose
* Kitematic (opzionale)
* Client GUI per MySQL (opzionale)
* IDE (opz.): Atom, Brackets, Eclipse, etc.
* composer (opzionale)
* bower (opzionale)
* git (opzionale)

## Cartelle e file necessari
Dove si desidera, sul proprio pc, scarichiamo la cartella di lavoro `webapp` contenente i file e le cartelle.

### Download da github
Dalla cartella di lavoro, non è necessario si trovi in un posto particolare, digitare il comando git per scaricare la cartella lamp e tutto il contenuto:

```console
$ git clone https://github.com/maxmasetti/docker-lamp.git webapp
$ cd webapp
```
chi preferisce, può utilizzare anche un client grafico per git. Il contenuto della cartella `webapp` è, più o meno:

* `webapp`
	* `.env`
	* `docker-compose.yml`
	* `Dockerfile`
	* [ ] `mysql`
		* [ ] `data`
		* `mysql.log`
		* `my.cnf`
	* [ ] `www`
		* `index.php`
		* ... (qui metteremo il resto della webapp)
	* `start.sh`
	* `stop.sh`
	* `dumpdb.sh`

Il file `.env` contiene la configurazione delle porte su cui vengono esposti i servizi. Sono impostate in modo da non entrare in conflitto con le porte standard 80 e 3306. Modificale con i valori standard se queste porte non sono già occupate.

```
MYSQL_PORT=33060
HTTP_PORT=8080
```

Il file `docker-compose.yml` definisce la struttura e la natura di tutto lo stack server che con i comandi `docker-compose up` e `docker-compose down` vinene costruito e demolito completamente.

Il file `Dockerfile` definisce il web-server partendo da un'immagine standard per php 7 aggiungendo la libreria mysqli che consente a php di collegarsi al db. Viene utilizzato da docker-compose per costruire il server web.

La cartella `mysql` contiene i file del database, la configurazione e il log. Il file mysql.log deve essere presente prima di avviare i container. 

Il file `my.cnf` definisce la configurazione del server mysql tentando di minimizzarne l'impatto sul file system. In caso l'occupazione di spazio non fosse un problema è possibile commmentare la seconda parte delle direttive inserite nel file di configurazione.

La cartella `www` conterrà tutta l'applicazione web: il file index.php proposto ha l'unico scopo di consentire di verificare velocemente se lo stack funziona collegandosi da php al database.
Fa' attenzione poiché l'applicazione php si connette al db sulla porta 3306, indipendentemente dalla porta configurata nel file `.env`, che invece è la porta a cui collegarsi per accedere al db dall'host.

I comandi `start.sh` e `stop.sh` servono per avviare e fermare lo stack server. Il comando `dumpdb.sh` consente di creare un file di dump dell'intero db (ovviamente a stack funzionante).

## Ubuntu
### Installazione
[Ecco come fare](https://docs.docker.com/install/linux/docker-ce/ubuntu/) per installare Docker:

```console
$ sudo apt-get remove docker docker-engine docker.io
$ sudo apt-get update
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
```
Qui però facciamo una variante, invece di utilizzare il comando da console:

```console
$ sudo apt-get install docker.io
```
utilizziamo il programma di installazione software di Ubuntu, "Ubuntu Software", cerchiamo Docker e lo installiamo. Oppure da linea di comando:

```console
$ sudo snap install docker
```
Una volta installato, proviamo se funziona:

```console
$ sudo docker run hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/

```

### Setup del sistema
[Ecco cosa occorre fare](https://docs.docker.com/install/linux/linux-postinstall/):

```console
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
```
Fare il logout e quindi di nuovo il login per recepire le ultime modifiche (anche se pare che in realtà occorra riavviare :?). A questo punto dovrebbe funzionare anche senza il sudo (questo tipo di modifica non è consigliabile sui sistemi di produzione, poiché garantisce all'utente un accesso di root senza limitazioni).

```console
$ docker run hello-world
```

E per installare l'ultima versione di [docker-compose](https://docs.docker.com/compose/install/):

```console
$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose version
docker-compose version 1.19.0, build 9e633ef
docker-py version: 2.7.0
CPython version: 2.7.13
OpenSSL version: OpenSSL 1.0.1t  3 May 2016
```
Oppure si può utilizzare quella installata con snap, ma non è l'ultimissima versione:

```console
$ docker.compose version
docker-compose version 1.16.1, build unknown
docker-py version: 2.5.1
CPython version: 2.7.12
OpenSSL version: OpenSSL 1.0.2g  1 Mar 2016
```

### Download dei file per lo stack lamp da github
Dalla cartella in cui creare la cartella lamp, digitare il comando:

```console
$ git clone https://github.com/maxmasetti/docker-lamp.git webapp
$ cd webapp
```
oppure utilizzare un client grafico per git.

### Avvio
Per creare i container (le macchine virtuali che compongono lo stack lamp) e avviarli, dalla cartella di lavoro (`webapp`):

```console
$ ./start.sh
```
Se preferisci avviare il tutto a mano, digita il comando:

```console
$ touch mysql/mysql.log
```
e quindi invocare il comando:

```console
$ docker-compose up
```
che mantiene il terminale collegato all'output dei processi attivati sui server, oppure si può avviare in modo "detached" con l'opzione:

```console
$ docker-compose up -d
```

Dopo qualche minuto (la prima volta deve scaricare tutte le immagini da internet) e un bel po' di righe di log, dovrebbe comparire la scritta:

```console
...
mysql-server | 2018-03-12T19:09:22.535808Z 0 [Note] mysqld: ready for connections.
mysql-server | Version: '5.7.21-log'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
...
web-server | [Mon Mar 12 19:09:23.516886 2018] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
```

Visita quindi [localhost:8080](localhost:8080) (correggi `8080` con la porta configurata nel file `.env`, se l'hai cambiata) e verifica il corretto funzionamento del tutto, la pagina dovrebbe rispondere con le scritte:

```console
Success: A proper connection to MySQL was made!
Host information: db via TCP/IP
...
```

Per accedere al database dal host, ad esempio con un client GUI come *emma* per Ubuntu (installabile dall'applicazione Ubuntu Software), [Sequel Pro](http://sequelpro.com/) per macOS o [Heidi](https://www.heidisql.com) per Windows, utilizzare l'indirizzo `localhost` sulla porta `33060` (o così come configurata nel file `.env`) con utente `root` e password `root`.

Come si evince dal file `index.php`, il server web accede al server mysql utilizzando il dn `db` sulla porta mysql standard (3306).

Se il log di mysql nel file `mysql/mysql.log` non compare, si può provare a cambiare i permessi del file stesso:

```console
$ chmod ugo+w mysql/mysql.log
```
e quindi riavviare lo stack. Per vedere il log in continuo, usa il comando tail:

```console
$ tail -f mysql/mysql.log
```

**Ora puoi iniziare a scrivere i tuoi programmi nella cartella www.**

Per fare un dump del database:

```console
$ docker exec mysql-server sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > ./databases.sql
```

oppure puoi utilizzare lo script:

```console
$ dumpdb.sh
```

### Stop
Dalla cartella di lavoro (`webapp`):

```console
$ ./stop.sh
```
oppure

```console
$ docker-compose stop
```
Per fermare il tutto e cancellare i container:

```console
$ docker-compose down
```
### Rimozione
Per eliminare docker e tutti i file di lavoro:

```console
$ sudo apt-get purge docker-ce
$ sudo rm -rf /var/lib/docker
$ rm -rf webapp
```

## Windows
### Installazione
Scaricare [Docker](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) e installarlo seguendo la [guida](https://docs.docker.com/docker-for-windows/).
### Avvio
Come Ubuntu o utilizzando Kitematic.
### Stop
Come Ubuntu o utilizzando Kitematic.

## macOS
### Installazione
Scaricare [Docker](https://download.docker.com/mac/stable/Docker.dmg) e installarlo seguendo la [guida](https://docs.docker.com/docker-for-mac/). Per installare Kitematic, dal menù a tendina selezionare `Kitematic`.
### Avvio
Come Ubuntu o utilizzando Kitematic.
### Stop
Come Ubuntu o utilizzando Kitematic.

`;)`
