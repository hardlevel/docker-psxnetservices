#!bin/bash
smbd --foreground --no-process-group &
kaiengine & 
/var/www/ps3/ps3netsrv ./share &