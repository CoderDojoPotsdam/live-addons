#!/bin/bash

cd "`dirname \"$0\"`"

sudo apt-get -y -qq install git

url="http://cdimage.ubuntu.com/ubuntu-mate/releases/16.04.1/release/ubuntu-mate-16.04.1-desktop-amd64.iso"
expected_hash="d17ad97753c756513e1c3add89ce6fa2f0db8c2fba690408a1e5eabc8e01311b"

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

iso_hash="`sha256sum test.sh | grep -oE '^\S+'`"

[ -z "$expected_hash" ] || [ "$expected_hash" == "$iso_hash" ] || {
  echo "SHA256 hashes do not match."
  echo "Expected: '$expected_hash'"
  echo "     Got: '$iso_hash'"
  exit 1
}

echo "Deleting examples"
(
  cd "live-addon-maker/examples"
  rm -f *.squashfs
)

