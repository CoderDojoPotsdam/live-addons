#!/bin/bash

cd "`dirname \"$0\"`"
if ./duplicate-usb-stick.sh; then
  echo "All OK, you can press ENTER to exit."
else
  echo "There seems to be an error!"
  echo "Please Report it here: "
  echo "  https://github.com/CoderDojoPotsdam/live-addons/issues"
  echo "along with this file: \"/opt/duplicate-usb-stick.sh\"."
fi
read
