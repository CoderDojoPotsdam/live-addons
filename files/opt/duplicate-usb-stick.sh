#!/bin/bash
set -e

cd "`dirname \"$0\"`"

list_devices() {
  echo /dev/sd* /dev/hd* | grep -o -e '/dev/..[^*]' | uniq
}

new_devices_attached() {
  echo "`echo \"$current_devices\" | grep -xvF \"$start_devices\"`"
}

echo "Hello, I am a friendly program which likes to duplicate"
echo "this operating system to other USB devices!"
device="$1"
if [ -z "$device" ]; then
  echo "Please attach a USB device to this computer!"

  i=0
  start_devices="`list_devices`"
  current_devices="$start_devices"
  while [ -z "`new_devices_attached`" ]; do
    start_devices="$current_devices"
#    echo "$start_devices"
    echo -n "."
    i=$((i + 1))
    sleep 0.1
    if [ "$((i % 100))" == 0 ]; then
      echo
      echo "Still waiting for a device to be attached."
    fi
    current_devices="`list_devices`"
  done
  echo

  device=`new_devices_attached | head -n 1`

  echo "I found a device! Whoohooo!"
fi

echo "Can I use the device $device?"
echo "  - Press ENTER to abort."
echo "  - write something and press ENTER"
echo "    to delete the device and duplicate this"
echo "    operating system onto thhe device"
echo "    This can be a description of the device"
echo "    in case you want to identify the stick if you run this program"
echo "    several times."
read description
if [ -z "$description" ]; then
  echo "No description provided, exiting."
  exit 1
fi

./partition-sticks.sh "$device"

dir="/tmp/usb-stick"
partition="${device}1"

mkdir -p "$dir"
sudo mount "$partition" "$dir"

sudo cp -v -r -T "/cdrom/" "$dir"

sudo umount "$dir"
sync

echo "Copied all contents successfully!"
echo "You can now remove the device $device."
echo "$description"
