#!/bin/bash

cd "`dirname \"$0\"`"

(
  mkdir -p files/icons
  cd files/icons
  wget -c 'https://github.com/CoderDojoPotsdam/organize/raw/master/logo/logo-512.png'
)

sudo live-addon-maker/make-addon.sh ./link.iso z-desktop.squashfs \
         -c 'echo /home/ubuntu/Desktop/* > /home/ubuntu/Desktop/.remove'
         -a 'files/Desktop/' '/home/ubuntu/Desktop/' \
         -a 'files/icons' '/opt/icons' \
         -s 'clean-desktop' 'rm -f `cat /home/ubuntu/Desktop/.remove`'
