#!/vendor/bin/sh

exec > /dev/kmsg 2>&1

if [ -f /sbin/recovery ]; then
  exit
fi

if ! mount | grep -q /vendor/etc/msm_irqbalance.conf; then
  # Replace msm_irqbalance.conf
  echo "PRIO=1,1,1,1,1,1,0,0
# arch_timer,arch_mem_timer,arm-pmu,kgsl-3d0
IGNORED_IRQ=19,38,21,332" > /dev/msm_irqbalance.conf
  chmod 644 /dev/msm_irqbalance.conf
  mount --bind /dev/msm_irqbalance.conf /vendor/etc/msm_irqbalance.conf
  chcon "u:object_r:vendor_configs_file:s0" /vendor/etc/msm_irqbalance.conf

  # Append to post_boot
  cat /vendor/bin/init.qcom.post_boot.sh > /dev/post_boot
  echo "
killall msm_irqbalance
sleep 1
start vendor.msm_irqbalance" >> /dev/post_boot
  chmod 755 /dev/post_boot
  mount --bind /dev/post_boot /vendor/bin/init.qcom.post_boot.sh
  chcon "u:object_r:qti_init_shell_exec:s0" /vendor/bin/init.qcom.post_boot.sh

  # Setup swap
  while [ ! -e /dev/block/vbswap0 ]; do
    sleep 1
  done
  if ! grep -q vbswap /proc/swaps; then
    # 4GB
    echo 4294967296 > /sys/devices/virtual/block/vbswap0/disksize
    echo 130 > /proc/sys/vm/swappiness
    mkswap /dev/block/vbswap0
    swapon /dev/block/vbswap0
    rm /dev/mkswap
  fi
fi

# Wait until existing post_boot finishes
until getprop vendor.post_boot.parsed | grep -q 1; do
  sleep 3
done
sleep 3

# Setup readahead
find /sys/devices -name read_ahead_kb | while read node; do echo 128 > $node; done

# MIUI seems to miss out mkdir /sdcard/ramdump for some reason,
# create it on our own to prevent subsystem_ramdump_system service loops
# Try this under a loop so that it can be created safely under FBE after keyguard unlock
while [ ! -e /sdcard/ramdump ]; then
  mkdir -p /sdcard/ramdump
  sleep 1
done

rm "$0"
exit 0
