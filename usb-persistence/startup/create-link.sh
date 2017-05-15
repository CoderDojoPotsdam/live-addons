#!/bin/bash

cd "/home"

for user in *; do
  echo "For user $user"
  echo "- create link"
  ln -s -t "$user/Desktop" "$1"
  echo "- own home folder `pwd`/$user"
  chown -R "$user" "$user"
done

exit 0
