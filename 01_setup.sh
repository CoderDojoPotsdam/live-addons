#!/bin/bash

cd "`dirname \"$0\"`"

sudo apt-get -y -qq install git

iso_name="ubuntu-mate-16.04.1-desktop-amd64.iso"
iso_url="http://cdimage.ubuntu.com/ubuntu-mate/releases/16.04.1/release/$iso_name"
expected_hash="d17ad97753c756513e1c3add89ce6fa2f0db8c2fba690408a1e5eabc8e01311b"
addon_maker_url="https://github.com/CoderDojoPotsdam/live-addons.git"

echo "Checking live-addon-maker"
if [ -e "live-addon-maker" ]; then
  (
    cd "live-addon-maker"
    git pull
  )
else
  git clone --depth=1 "$addon_maker_url" || {
    echo "Could not clone live-addon-maker"
    exit 1
  }
fi

(
  echo "Downloading iso"
  cd "live-addon-maker"
  wget -c "$iso_url"
)

if [ -n "$expected_hash" ]; then
  echo "Checking sha sum"
  sha_output="`sha256sum live-addon-maker/$iso_name`"
  echo "sha256sum output: $sha_output"
  iso_hash="`echo \"$sha_output\" | grep -oE '^\S+'`"

  [ "$expected_hash" == "$iso_hash" ] || {
    echo "SHA256 hashes do not match."
    echo "Expected: '$expected_hash'"
    echo "     Got: '$iso_hash'"
    exit 1
  }
fi

echo "Deleting examples"
(
  cd "live-addon-maker/examples"
  rm -f *.squashfs
)

