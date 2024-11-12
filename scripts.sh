#!/bin/bash

# Start Samba in foreground
smbd --foreground --no-process-group &

# Start Kai Engine
kaiengine &

# Start PS3 Net Server
/var/www/ps3/ps3netsrv /var/www/ps3/share &

# Start UDP BD Server
/var/www/ps2/udpbd-server /var/www/ps2 &

# Wait for all background processes
wait
