#!/bin/bash
# We handle partitions here. Best to set -e to not cause harm.
set -e

stick="$1"
size="4G"
forbidden="/dev/sda"

if [ "$stick" == "$forbidden" ]; then
  echo "Cannot use /dev/sda as this would be the operating system."
  exit 1
fi

devices="`echo /dev/sd* /dev/hd* | grep -o -e '/dev/..[^*]' | uniq`"

if [ -z "$stick" ]; then
  echo "Possilbe first argument:"
  for dev in $devices; do
    [ "$dev" == "$forbidden" ] && continue
    echo "  \"$0\" \"$dev\""
  done
  exit 0
fi


echo "Computing partition"
echo "See http://rainbow.chard.org/2013/01/30/how-to-align-partitions-for-best-performance-using-parted/"
optimal_io_size="`cat /sys/block/sdb/queue/optimal_io_size`"
minimum_io_size="`cat /sys/block/sdb/queue/minimum_io_size`"
alignment_offset="`cat /sys/block/sdb/alignment_offset`"
physical_block_size="`cat /sys/block/sdb/queue/physical_block_size`"
echo "optimal_io_size = $optimal_io_size"
echo "minimum_io_size = $minimum_io_size"
echo "alignment_offset = $alignment_offset"
echo "physical_block_size = $physical_block_size"
if [ "$minimum_io_size" > "$optimal_io_size" ]; then
  echo "minimum io size is greater than the optimal io size"
  io_size="$minimum_io_size"
else
  io_size="$optimal_io_size"
fi
start_sector="$(((io_size + alignment_offset) / physical_block_size))"
echo "start_sector = $start_sector"

echo "Printing partitions:"
sudo parted -s "$stick" print
partitions="`sudo parted -s \"$stick\" print|awk '/^ / {print $1}'`"
echo "partitions: $partitions"

echo "Deleting partitions"
for i in $partitions; do
  sudo parted -s "$stick" rm "$i"
done

echo "Creating partition:"
sudo parted -s "$stick" mkpart primary "$start_sector"s "$size"

echo "Rereading the partition table"
echo "see http://serverfault.com/a/36047"
sudo partprobe

part_num="1"
partition="$stick$part_num"
echo "Waiting for partition to appear"
timeout 10s bash -c "while ! [ -e \"$partition\" ]; do echo -n .; sleep 0.2; done" || {
  echo "$partition does not exist"
}
echo " $partition exists."

echo "Formatting the partition"
if [ -z "`which mkdosfs`" ]; then
  sudo apt-get -y install dosfstools
fi

echo "Partition: $partition"
echo "Formatting with fat32"
sudo mkdosfs -F 32 -I "$partition"

echo "setting flags"
sudo parted -s "$stick" set "$part_num" boot on
sudo parted -s "$stick" set "$part_num" lba on
