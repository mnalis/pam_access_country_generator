# pam_access_country_generator
Generates pam_access(8) config file allowing only specific country from RIPE database

Intended usage is allow only FTP access from home country for most users, to mitigate 
trojan horses which steal passwords. Only work well for small countries like 'HR'

Usage:
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
