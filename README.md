# Ambiente di sviluppo Apache+PHP+MySQL basato su

![Docker](https://blog.seeweb.it/wp-content/uploads/2015/06/homepage-docker-logo-300x248.png)

-_-
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
Dove si desidera, sul proprio pc, preparare la cartella di lavoro `webapp` contenente i file e le cartelle

* `webapp` (cartella di lavoro)
	* `.env`*
	* `docker-compose.yml`*
	* `Dockerfile`*
	* [ ] `mysql`
		* [ ] `data`
		* `mysql.log`
		* `my.cnf`*
	* [ ] `www`
		* `index.php`*
		* ... (il resto della webapp)
	* `start.sh`*
	* `sotp.sh`*
	* `dumpdb.sh`*

(*) file scaricati dal repository

Il file `.env` contiene la configurazione delle porte su cui vengono esposti i servizi. Sono impostate in modo da non entrare in conflitto con le porte standard 80, 443 e 3306. Modificale con i valori standard se queste porte non sono già occupate.

Il file `docker-compose.yml` definisce la struttura e la natura di tutto lo stack server e i relativi comandi `docker-compose up` e `docker-compose down` permettono di costruire e demolire l'intero stack. In particolare definisce quali porte delle macchine server vengono mappate e su quali porte del host: modificare tali valori per adattarli alle proprie esigenze (tenendo conto che, se sul host le porte 80, 443 e 3306 sono già occupate, tentandone la mappatura con le relative dei server, si causa un errore che impedisce allo stack di avviarsi correttamente).

Il file `Dockerfile` definisce il web-server partendo da un'immagine standard per php 7 aggiungendo la libreria mysqli che consente a php di collegarsi al db.

La cartella `mysql` contiene i file del database, la configurazione e il log. Il file mysql.log deve essere creato a mano prima di avviare i servizi. 

Il file `my.cnf` definisce la configurazione del server mysql tentando di minimizzarne l'impatto sul file system. In caso l'occupazione di spazio non fosse un problema è possibile commmentare la seconda parte delle direttive.

La cartella `www` conterrà tutta l'applicazione web: il file index.php proposto ha l'unico scopo di consentire di verificare velocemente se lo stack funziona collegandosi da php al database.
Fa' attenzione poiché l'applicazione php si connette al db sulla porta 3306, indipendentemente dalla porta configurata nel file `.env`, che invece è la porta a cui collegarsi per accedere al db dall'host.

I comandi `start.sh` e `stop.sh` servono per avviare e fermare lo stack server. Il comando `dumpdb.sh` consente di creare un file di dump dell'intero db (ovviamente a stack funzionante).

## Ubuntu
### Installazione
[Ecco come fare](https://docs.docker.com/install/linux/docker-ce/ubuntu/) per installare Docker-CE:

```bash
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
$ sudo apt-get install docker-ce
$ sudo docker run hello-world
```
### Setup del sistema
[Ecco cosa occorre fare](https://docs.docker.com/install/linux/linux-postinstall/):

```bash
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
```
Fare il logout e quindi di nuovo il login per recepire le ultime modifiche.

```bash
$ docker run hello-world
```

E per installare [docker-compose](https://docs.docker.com/compose/install/):

```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose --version
docker-compose version 1.19.0, build 1719ceb
```

### Avvio
Per creare i container e avviarli,
dalla cartella di lavoro (`webapp`):

```bash
$ ./start.sh
```
oppure a mano:

```bash
$ docker-compose up
```
che mantiene il terminale collegato all'output dei processi attivati sui server, oppure si può avviare in modo "detached" con l'opzione:

```bash
$ docker-compose up -d
```

Visitare quindi [localhost:8080](localhost:8080) per verificare il corretto
funzionamento del tutto.
Per accedere al database dal host, ad esempio con un client GUI come
[?Ubuntu](),
[Sequel Pro](http://sequelpro.com/)
o [Heidi](https://www.heidisql.com),
utilizzare l'indirizzo `localhost` sulla porta `33060` con
utente `root` e password `root`.

Come si evince dal file `index.php`, il server web accede al server mysql utilizzando il dn `db` sulla porta mysql standard (3306).

### Stop
Dalla cartella di lavoro (`webapp`):

```bash
$ ./stop.sh
```
oppure

```bash
$ docker-compose stop
```
Per fermare il tutto e cancellare i container:

```bash
$ docker-compose down
```
### Rimozione
Per eliminare docker e tutti i file di lavoro:

```bash
$ sudo apt-get purge docker-ce
$ sudo rm -rf /var/lib/docker
$ rm -rf webapp
```

## Windows
### Installazione
[Ecco come fare](https://docs.docker.com/docker-for-windows/install/):

Scaricare [Docker](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) e installarlo seguendo la [guida](https://docs.docker.com/docker-for-windows/).

### Avvio
### Stop

## macOS
### Installazione
[Ecco come fare](https://docs.docker.com/docker-for-mac/install/):

Scaricare [Docker](https://download.docker.com/mac/stable/Docker.dmg) e installarlo seguendo la [guida](https://docs.docker.com/docker-for-mac/).

### Avvio
Come Ubuntu
### Stop
Come Ubuntu

-_-