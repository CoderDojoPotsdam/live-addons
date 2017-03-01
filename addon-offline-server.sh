#!/bin/bash

cd "`dirname \"$0\"`"

modules="startup http-server lightbot blockly-games snap opentechschool-javascript-beginners opentechschool-python-beginners"
install_url="https://raw.githubusercontent.com/cdpoffline/offline-material/master/bin/download_and_install.sh"

sudo live-addon-maker/make-addon.sh ./link.iso z-offline-server.squashfs \
         -C "sed -i=.live-addon 's/restricted$/restricted multiverse universe/' /etc/apt/sources.list" \
         -C "apt-get update" \
         -c "cd /opt && wget -O- '$install_url' | bash" \
         -c "/opt/offline-material/bin/modules.sh -a $modules overview; /opt/offline-material/bin/modules.sh -u overview"
