# pam_access_country_generator
Generates ipset(8) ruleset and pam_access(8) config file allowing only specific country from RIPE database

Intended usage is to allow FTP access only from home country for most users, to mitigate 
trojan horses which steal passwords. Probably only works well for small countries like 'HR'.
ipset(8) should be generic firewall working for big countries too.

Usage (ipset):
- edit vsftpd_get_country_hr to suit your country and your config file location
- run vsftpd_get_country_hr and put it in /etc/cron.monthly (so it updates)
- install ipset(8) on your firewall (apt-get install ipset)
- edit your firewall to use it (see examples/ipset_firewall.sh)
- that's it!


Usage (pam_access):
- install vsftpd (for example)
- cp examples/pam.d/vsftpd  /etc/pam.d/vsftpd (and edit as needed)
- edit vsftpd_get_country_hr to suit your country and your config file location
- run vsftpd_get_country_hr and put it in /etc/cron.monthly (so it updates)
- make sure vsftpd uses "pam_service_name=vsftpd" in /etc/vsftpd.conf
- restart vsftpd
- edit /etc/vsftpd_pam_access.conf to manually tweak setting for some users 
  for which access only from specified country is too limited (it will be 
  retained on cron runs). See examples/vsftpd_pam_access.conf for example
- that's it! new FTP connections will be only allowed from specified country, 
  unless overriden in config file
