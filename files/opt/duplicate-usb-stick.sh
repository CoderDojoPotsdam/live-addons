#!/bin/bash
set -e

device="$1"
source_device="$2"

cd "`dirname \"$0\"`"

list_devices() {
  echo /dev/sd* /dev/hd* | grep -o -e '/dev/..[^*]' | uniq
}

new_devices_attached() {
  echo "`echo \"$current_devices\" | grep -xvF \"$start_devices\"`"
}

echo "Hello, I am a friendly program which likes to duplicate"
echo "this operating system to other USB devices!"
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

if [ -z "$source_device" ]; then
  source_device="/dev/sda"
fi
partition="${device}1"

end="`sudo parted -s \"$source_device\" 'unit b print' | awk '/^ / {print $3}' | head -n 1`"
bytes="${end%B}"
bytes="${bytes%b}"
start="`sudo parted -s \"$source_device\" 'unit b print' | awk '/^ / {print $2}' | head -n 1`"

echo "Getting partitions of $device"
partitions="`sudo parted -s \"$device\" print|awk '/^ / {print $1}'`"
echo "Deleting partitions $partitions" 
for i in $partitions; do
  sudo umount "$device$i" || true
  sudo parted -s "$device" rm "$i"
done

echo "Creating a new partition table"

sudo parted -s "$device" mklabel msdos

part_num="1"
partition="$device$part_num"

sudo partprobe || true

echo "Waiting for partition to disappear"
timeout 1s bash -c "while [ -e \"$partition\" ]; do echo -n .; sleep 0.2; done" || {
  echo "$partition exists"
  exit 1
}
echo " $partition vanished."


echo "Creating partition:"
sudo parted -s "$device" mkpart primary "$start" "$end" || true

echo "Rereading the partition table"
echo "see http://serverfault.com/a/36047"
sudo partprobe || true

echo "Waiting for partition to appear"
timeout 1s bash -c "while ! [ -e \"$partition\" ]; do echo -n .; sleep 0.2; done" || {
  echo "$partition does not exist"
  exit 1
}
echo " $partition exists."

echo "Bytes to copy: $bytes"

steps=100
start=0
sec_start="`date +%s`"
for i in `seq 1 100`; do
  stop=$((bytes * i / steps))
  count="$((stop - start))"
  sudo dd if="$source_device" of="$device" count=$count seek=$start skip=$start oflag=seek_bytes iflag=skip_bytes,count_bytes
  start=$stop
  sec_now="`date +%s`"
  sec_remaining=$(( (sec_now - sec_start) * ( 100 - i) / i  ))
  echo "$i% - $((sec_remaining / 60))m $(( sec_remaining % 60 ))s remaining"
done

echo "Syncing..."
sync
sudo partprobe || true

echo "Copied all contents successfully!"
echo "You can now remove the device $device."
echo "$description"
