#!/bin/bash

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
