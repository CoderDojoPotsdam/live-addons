#!/bin/bash

cd "`dirname \"$0\"`"

wifi="CoderDojo"
pw="`echo Y29kZXJ3YW5rZW5vYmkK | base64 -d`"

log="/var/log/wifi.log"

sudo live-addon-maker/make-addon.sh ./link.iso z-wifi.squashfs \
         -a 'files/connect-to-wifi' '/usr/local/bin/' \
         -s 'wifi-autoconnect' \
            "connect-to-wifi '$wifi' '$pw' 1>>'$log' 2>>'$log'"
