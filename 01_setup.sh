#!/bin/bash

cd "`dirname \"$0\"`"

sudo apt-get -y -qq install git

url="https://github.com/CodersOS/live-addon-maker.git"

echo "Checking live-addon-maker"
if [ -d "live-addon-maker" ]; then
  (
    cd "live-addon-maker"
    git pull
  )
else
  git clone --depth=1 "$url"
fi

echo "Looking for ubuntu at $url"
(
  cd "live-addon-maker"
  wget -c "http://de.releases.ubuntu.com/16.10/ubuntu-16.10-desktop-amd64.iso"
)

echo "Deleting examples"
(
  cd "live-addon-maker/examples"
  rm -f *.squashfs
)

