#!/bin/bash
echo "------------------------------------------------"
date
echo

dev="/dev/sda2"
dir="/usb-data"
scripts_folder="`dirname \"$0\"`/startup"

echo "Looking for $dev"
if ! [ -e "$dev" ]; then
  echo "No $dev found. Trying to create the dev."
  (
    # see http://tldp.org/HOWTO/Partition/fdisk_partitioning.html
    # new partition
    echo "n"
    # primary partition
    echo "p"
    # partition number
    echo "${dev: -1}"
    # partition start
    echo
    # partition stop
    echo
    # write the partition
    echo "w"
  ) | fdisk "${dev:: -1}"
  partprobe
  if ! [ -e "$dev" ]; then
    echo "Failed to create $dev"
    echo "Exiting."
    exit 5
  fi
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

