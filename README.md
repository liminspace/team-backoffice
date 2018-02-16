# team-backoffice
The recipe of easy installing Gitlab + Gitlab Registry + Redmine + Let's Encrypt using Docker and Docker Compose


### Requirements:

 * Debian Linux 9 Stretch (or something like this)
 * Email-server on it that can send emails (for example, `exim4`)
 * Installed [Docker](https://docs.docker.com/install/linux/docker-ce/debian/)
       and [Docker-compose](https://docs.docker.com/compose/install/#install-compose)
 * extended arms and clear mind ;)


### Installing:

Make a fork of this repo if you want extend its settings in future.

NOTE: **You have to do everything under `root` user.**

Clone it on your server:
```
$ git clone https://github.com/liminspace/team-backoffice.git /srv/team-backoffice
```

Make decision what do you want to install and read below.


### Nginx

**It's important and necessary service.**

Go to the directory:
```
$ cd /srv/team-backoffice/nginx
```

Create `.env` file from example one:
```
$ cp .env.example .env
```

Set up `.env` or just see it.

Create a docker-network with name from option `NETWORK` in your `.env` file:

```
$ docker network create --subnet=172.212.0.0/16 nginx-proxy
```

*use your network name instead `nginx-proxy`

*you can use another subnet

Run service:
```
$ docker-compose up -d
```

You also need configure `exim4` to allow it serving docker-containers.
You have to change local interfaces and relay networks.
For `exim4` just open file:
```
$ nano /etc/exim4/update-exim4.conf.conf
```
change these options by adding new docker-network subnet and the first IP in it:
```
dc_local_interfaces='127.0.0.1 ; ::1 ; 172.212.0.1'
dc_relay_nets='172.212.0.0/16'
```
and restart `exim4`:
```
$ service exim4 restart
```

##### Options in .env for Nginx

 * `NETWORK` -- name of virtual network to connect docker-containers with each other.


### Gitlab + Gitlab Registry

Go to the directory:
```
$ cd /srv/team-backoffice/gitlab
```

Create `.env` file from example one:
```
$ cp .env.example .env
```

If you want to use 22 post as gitlab's SSH, you need change the SSH-port of the host machine:
```
$ nano /etc/ssh/sshd_config
Port 2299
```
and restart `sshd`:
```
$ service ssh restart
```

Otherwise you have to change `SSH_PORT` option in `.evn` into another port number.

Set up all configs in `.env` file.

Run service:
```
$ docker-compose up -d
```

*it will take some time, be patient

##### Options in .env for Gitlab

 * `GITLAB_HOSTNAME` -- domain of your Gitlab.
 * `REGISTRY_HOSTNAME` -- domain of Gitlab Registry.
 * `LETSENCRYPT_EMAIL` -- email that will be used during getting SSL-certificates of Let's Encrypt.
 * `SSH_PORT` -- Gitlab's SSH port. It must be another than the port used on the host machine.
 * `NETWORK` -- docker-network name which is the same as used in Nginx (see above).
 * `NETWORK_HOST_IP` -- the first IP of docker-network subnet (see above).
 * `NGINX_REAL_IP_TRUSTED_ADDRESSES` -- the mask of docker-network (see above).
 * `SMTP_DOMAIN` -- SMTP-domain to send emails. See settings of your email-server on the host machine.
 * `EMAIL_FROM` -- the email from which Gitlab will send emails.
 * `EMAIL_DISPLAY_NAME` -- display name for `EMAIL_FROM`.
 * `EMAIL_REPLY_TO` -- email that will be defined in header REPLY-TO in emails Gitlab sends.
 * `EMAIL_SUBJECT_SUFFIX` -- prefix in emails Gitlab sends.
 * `TIME_ZONE` -- time zone to show correct time in Gitlab.


### Redmine

Go to the directory:
```
$ cd /srv/team-backoffice/redmine
```

Create `.env` file from example one:
```
$ cp .env.example .env
```

Set up all configs in `.env` file.

Update config files:
```
$ bash updateconf.sh
```

Run service:
```
$ docker-compose up -d
```

*it will take some time, be patient

##### Options in .env for Redmine

 * `REDMINE_HOSTNAME` -- domain of your Redmine.
 * `LETSENCRYPT_EMAIL` -- email that will be used during getting SSL-certificates of Let's Encrypt.
 * `NETWORK` -- docker-network name which is the same as used in Nginx (see above).
 * `NETWORK_HOST_IP` -- the first IP of docker-network subnet (see above).
 * `DB_NAME` -- database name that redmine uses.
 * `DB_USER` -- username to connect redmine's database.
 * `DB_PASS` -- password to connect redmine's database.
