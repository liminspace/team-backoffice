# team-backoffice
The recipe of easy installing [GitLab](https://about.gitlab.com/) +
[GitLab Registry](https://docs.gitlab.com/ee/user/project/container_registry.html) +
[Redmine](https://www.redmine.org/) + [TeamPass](https://teampass.net/) +
[Let's Encrypt](https://letsencrypt.org/) using [Docker](https://www.docker.com/)
and [Docker Compose](https://docs.docker.com/compose/)


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

##### Options in `.env` for Nginx

 * `NETWORK` -- name of virtual network to connect docker-containers with each other.


### GitLab + GitLab Registry

Go to the directory:
```
$ cd /srv/team-backoffice/gitlab
```

Create `.env` file from example one:
```
$ cp .env.example .env
```

If you want to use 22 post as GitLab's SSH, you need change the SSH-port of the host machine:
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

##### Options in `.env` for GitLab

 * `GITLAB_HOSTNAME` -- domain of your GitLab.
 * `REGISTRY_HOSTNAME` -- domain of GitLab Registry.
 * `LETSENCRYPT_EMAIL` -- email that will be used during getting SSL-certificates of Let's Encrypt.
 * `SSH_PORT` -- GitLab's SSH port. It must be another than the port used on the host machine.
 * `NETWORK` -- docker-network name which is the same as used in Nginx (see above).
 * `NETWORK_HOST_IP` -- the first IP of docker-network subnet (see above).
 * `NGINX_REAL_IP_TRUSTED_ADDRESSES` -- the mask of docker-network (see above).
 * `SMTP_DOMAIN` -- SMTP-domain to send emails. See settings of your email-server on the host machine.
 * `EMAIL_FROM` -- the email from which GitLab will send emails.
 * `EMAIL_DISPLAY_NAME` -- display name for `EMAIL_FROM`.
 * `EMAIL_REPLY_TO` -- email that will be defined in header Reply-To in emails GitLab sends.
 * `EMAIL_SUBJECT_SUFFIX` -- prefix in emails GitLab sends.
 * `TIME_ZONE` -- time zone to show correct time in GitLab.


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

##### Options in `.env` for Redmine

 * `REDMINE_HOSTNAME` -- domain of your Redmine.
 * `LETSENCRYPT_EMAIL` -- email that will be used during getting SSL-certificates of Let's Encrypt.
 * `NETWORK` -- docker-network name which is the same as used in Nginx (see above).
 * `NETWORK_HOST_IP` -- the first IP of docker-network subnet (see above).
 * `DB_NAME` -- database name that Redmine uses.
 * `DB_USER` -- username to connect Redmine's database.
 * `DB_PASS` -- password to connect Redmine's database.


### TeamPass

Go to the directory:
```
$ cd /srv/team-backoffice/teampass
```

Create `.env` file from example one:
```
$ cp .env.example .env
```

Set up all configs in `.env` file.

Run service:
```
$ docker-compose up -d
```

Go to your https://`TEAMPASS_HOSTNAME` and follow steps there.
During steps you have to set these options:

 * Absolute path to teampass folder: don't change it, keep default value
 * Full URL to teampass: `https://teampass.example.com` (use the domain in `TEAMPASS_HOSTNAME` in `.env`)
 * Database Host: `mysql`
 * Database Port: `3306`
 * Other Database fields: see your `.env` file
 * Absolute path to SaltKey: `/var/www/html/sk`

Go to `Settings` -> `Email` and set up:

 * SMTP server address: the first IP of docker-network subnet (see above)
 * SMTP server port: `25`  (or change it according to your email server)
 * From: Email address: `teampass@example.com` (set email with domain of your email server)
 * From: Display name: `TeamPass MyTeam` (set display name you like)

See TeamPass' documentation: https://teampass.readthedocs.io/en/latest/

##### Options in `.env` for TeamPass

 * `TEAMPASS_HOSTNAME` -- domain of your TeamPass.
 * `LETSENCRYPT_EMAIL` -- email that will be used during getting SSL-certificates of Let's Encrypt.
 * `NETWORK` -- docker-network name which is the same as used in Nginx (see above).
 * `DB_NAME` -- database name that TeamPass uses.
 * `DB_USER` -- username to connect TeamPass' database.
 * `DB_PASS` -- password to connect TeamPass' database.
 * `DB_ROOT_PASS` -- password for `root` user of MySQL that TeamPass uses.


### How to update the services

Go to the directory you want to update the service there and execute the command:
```
$ docker-compose down && docker-compose pull && docker-compose up -d && docker image prune -af
```
