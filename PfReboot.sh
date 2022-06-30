#!/bin/bash

# Testing uptime to run script only xx seconds after boot

# Current time
currtime=$(date +%s)

# Bootime in seconds
utime=$(sysctl kern.boottime | awk -F'sec = ' '{print $2}' | awk -F',' '{print $1}')

# Uptime in seconds
utime=$(($currtime - $utime))

# If boot is longer than 120 seconds ago... (To avoid bootloops)
if [ $utime -gt 120 ]; then

# A message to the console (I dont like feedback on consle)
# Uncomment it if you like to see a feedback on the consle
#echo "Testing Connection at" `date +%Y-%m-%d.%H:%M:%S` "uptime:" $utime "seconds" >> pfrebootlog.txt
#wall pfrebootlog.txt
#rm pfrebootlog.txt

# Try 1 or 2 minutes worth of very short pings to clouddlare public DNS servers.
# Quit immediately if we get a single frame back.
# If neither server responds at all then reboot the firewall.

counting=$(ping -o -s 0 -c 10 1.0.0.1 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )

if [ $counting -eq 0 ]; then

counting=$(ping -o -s 0 -c 10 1.1.1.1 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )

if [ $counting -eq 0 ]; then

# Trying to just restart NIC.
# Change the NIC name as per your wan.

ifconfig re0 down
ifconfig re0 up

# Testing if the we get a ping or not.

counting=$(ping -o -s 0 -c 10 1.0.0.1 | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )

if [ $counting -eq 0 ]; then

# network down
# Save RRD data

/etc/rc.backup_rrd.sh
reboot

fi
fi
fi
fi
