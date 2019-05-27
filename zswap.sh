#!/bin/bash

while true
do

PAGES_STORED=$(</sys/kernel/debug/zswap/stored_pages)
POOL_SIZE=$(</sys/kernel/debug/zswap/pool_total_size)
SWAPFILE_USED_KB=`tail -n 1 /proc/swaps | awk '$1=$1' | cut -d' ' -f 4`
SAME_FILLED_PAGES=$(</sys/kernel/debug/zswap/same_filled_pages)


clear

echo -n "Compression ratio: "
echo "scale=2; ($PAGES_STORED * 4096) / $POOL_SIZE" | bc | tr -d "\n"
echo "x"

echo -n "Zswap Used: "
echo "scale=2; ($PAGES_STORED * 4096) / (1024*1024)" | bc | tr -d "\n"
echo -n " MB Stored in "
echo "scale=2; $POOL_SIZE / (1024 * 1024)" | bc | tr -d "\n"
echo " MB of RAM"

echo -n "Same filled pages: "
echo "scale=2; ($SAME_FILLED_PAGES * 4096) / (1024 * 1024)" | bc | tr -d "\n"
echo " MB"

echo -n "Swapfile Used: "
echo "scale=2; ($SWAPFILE_USED_KB - (($PAGES_STORED * 4096) / 1024)) / 1024" | bc | tr -d "\n"
echo " MB"

sleep 5
done

