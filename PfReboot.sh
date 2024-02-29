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
    # A message to the console (I dont like feedback on console)
    # Uncomment it if you like to see feedback on the console
    echo "Testing Connection at" $(date +%Y-%m-%d.%H:%M:%S) "uptime:" $utime "seconds" >> pfrebootlog.txt
    wall pfrebootlog.txt
    rm pfrebootlog.txt

    # Try 1 or 2 minutes worth of very short pings to Cloudflare public DNS servers.
    # Quit immediately if we get a single frame back.
    # If neither server responds at all, then reboot the firewall.

    firstDNS="1.0.0.1"
    secondDNS="1.1.1.1"

    counting=$(ping -o -s 0 -c 10 $firstDNS | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )

    if [ $counting -eq 0 ]; then
        php -r 'require_once("/etc/inc/notices.inc"); notify_via_telegram("First DNS ping to '$firstDNS' failed.");'

        counting=$(ping -o -s 0 -c 10 $secondDNS | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )

        if [ $counting -eq 0 ]; then
            php -r 'require_once("/etc/inc/notices.inc"); notify_via_telegram("Second DNS ping to '$secondDNS' failed.");'

            # Trying to just restart NIC.
            # Change the NIC name as per your WAN.
            nic_name="re0"
            
            php -r 'require_once("/etc/inc/notices.inc"); notify_via_telegram("Restarting '$nic_name' NIC.");'
            
            ifconfig $nic_name down
            ifconfig $nic_name up

            # Testing if we get a ping or not.
            counting=$(ping -o -s 0 -c 10 $firstDNS | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }' )

            if [ $counting -eq 0 ]; then
                php -r 'require_once("/etc/inc/notices.inc"); notify_via_telegram("DNS '$firstDNS' ping test was unsuccessful, network is down.");'

                # Network down.
                # Save RRD data.
                php -r 'require_once("/etc/inc/notices.inc"); notify_via_telegram("pfSense is rebooting now.");'
                
                /etc/rc.backup_rrd.sh
                reboot
            fi
        fi
    fi
fi
