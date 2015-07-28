#!/bin/bash

# Configuration
interval=60    #in seconds
critical_level=15    #percent
#icon="/usr/share/icons/elementary-xfce/notifications/48/notification-battery-low.png"     #notification icon

while true
do
        if [ "$(acpi -a | grep -o off)" == "off" ]; then
            battery_level=`acpi -b | sed 's/.*[dg], //g;s/\%,.*//g'`
            [ $battery_level -le $critical_level ] && \
            notify-send -u critical -t 15000 \
            "Battery level is low! $battery_level%"
        fi
        sleep $interval
done
