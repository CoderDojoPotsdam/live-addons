#!/bin/bash

cd "`dirname \"$0\"`"

(
  mkdir -p files/icons
  cd files/icons
  wget -qc 'https://github.com/CoderDojoPotsdam/organize/raw/master/logo/logo-512.png'
)

sudo live-addon-maker/make-addon.sh ./link.iso z-desktop.squashfs -H \
         -a 'files/applications/' '/home/ubuntu/Desktop/' \
         -a 'files/applications/' '/usr/share/applications/' \
         -a 'files/icons' '/opt/icons' \
         -a 'files/desktop.sh' '/opt/' \
         -s 'clean-desktop' '/opt/desktop.sh'

