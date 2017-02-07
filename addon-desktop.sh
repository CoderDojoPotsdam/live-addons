#!/bin/bash

cd "`dirname \"$0\"`"

(
  mkdir -p files/icons
  cd files/icons
  wget -qc 'https://github.com/CoderDojoPotsdam/organize/raw/master/logo/logo-512.png'
)

sudo live-addon-maker/make-addon.sh ./link.iso z-desktop.squashfs \
         -a 'files/Desktop/' '/home/ubuntu/Desktop/' \
         -a 'files/icons' '/opt/icons' \
         -s 'clean-desktop' 'sleep 4; rm -f examples.desktop ubiquity.desktop'
