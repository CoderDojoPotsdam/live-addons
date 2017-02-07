#!/bin/bash
echo "------------------------------------------------"
date
echo

dev="/dev/sda2"
dir="/usb-data"
scripts_folder="`dirname \"$0\"`/startup"

echo "Looking for $dev"
if ! [ -e "$dev" ]; then
  echo "No $dev found. Exiting."
  exit 1
fi

echo "Creating $dir to mount $dev"
mkdir -p "$dir"

echo "Mounting $dev in $dir"
mount "$dev" "$dir" && mounted=true

if [ "$mounted" == "true" ]; then
  echo "Mounted $dev to $dir"
else
  echo "Could not mount $dev to $dir"
  echo "Trying to create filesystem."
  mkfs.ext2 "$dev" && has_filesystem=true
  if [ "$has_filesystem" == "true" ]; then
    echo "Successfully created filesystem"
    echo "Mounting again"
    mount "$dev" "$dir" && mounted=true
    if [ "$mounted" == "true" ]; then
      echo "Mounted successfully at last"
    else
      echo "Could not mount $dev. Exiting."
      exit 2
    fi
  else
    echo "Could not create filesystem on $dev"
    echo "Exiting."
    exit 3
  fi
fi

for script in "$scripts_folder"/*; do
  echo
  echo "---------------------------------------------"
  echo "Starting script:"
  echo "  $script $dir"
  echo
  "$script" "$dir"
done

