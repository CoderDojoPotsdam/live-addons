#!/bin/bash

cd "`dirname \"$0\"`"

sudo apt-get -y -qq install git

url="https://github.com/CodersOS/live-addon-maker.git"

if [ -d "live-addon-maker" ]; then
  (
    cd "live-addon-maker"
    git pull
  )
else
  git clone "$url"
fi

(
  cd "live-addon-maker"
  wget -c "http://de.releases.ubuntu.com/16.10/ubuntu-16.10-desktop-amd64.iso"
)
(
  cd "live-addon-maker/examples"
  rm -f *.squashfs
)

