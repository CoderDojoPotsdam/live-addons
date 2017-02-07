#!/bin/bash

cd "`dirname \"$0\"`"

sudo apt-get -y -qq install git

# settings
iso_url="http://de.releases.ubuntu.com/16.10/ubuntu-16.10-desktop-amd64.iso"
expected_hash="4405c37d61b5cac6c89eaf379c035058ed7db8594abd209337276c7c4556787e"
addon_maker_url="https://github.com/CodersOS/live-addon-maker.git"

# computed settings
iso_name="`basename \"$iso_url\"`"
iso_file="live-addon-maker/$iso_name"

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

[ -e "live-addon-maker" ] || {
  echo "expected live-addon-maker directory"
  echo `ls`
  exit 1
}

(
  echo "Downloading iso"
  cd "live-addon-maker"
  wget -c "$iso_url"
)

if [ -n "$expected_hash" ]; then
  echo "Checking sha sum"
  sha_output="`sha256sum \"$iso_file\"`"
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
rm -f live-addon-maker/examples/*.squashfs live-addon-maker/*.squashfs *.squashfs

rm -f ./link.iso
ln -s -T "$iso_file" "link.iso"
