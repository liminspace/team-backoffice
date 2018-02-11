# team-backoffice
The recipe of easy installing Gitlab + Gitlab Registry + Redmine + Let's Encrypt using Docker and Docker Compose


$ docker network create --subnet 172.212.0.0/16 nginx-proxy

$ nano /etc/exim4/update-exim4.conf.conf
```
dc_eximconfig_configtype='internet'
dc_other_hostnames='localhost'
dc_local_interfaces='127.0.0.1 ; ::1 ; 172.212.0.1'
dc_readhost=''
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets='172.212.0.0/16'
dc_smarthost=''
CFILEMODE='644'
dc_use_split_config='false'
dc_hide_mailname=''
dc_mailname_in_oh='true'
dc_localdelivery='mail_spool'
```
