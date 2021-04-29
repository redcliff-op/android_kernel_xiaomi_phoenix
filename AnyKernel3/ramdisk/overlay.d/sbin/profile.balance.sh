#!/system/bin/sh

# Balance
echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 
echo "schedutil" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor 
echo "1804800" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "2208000" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
echo "1248000" > /sys/module/cpu_input_boost/parameters/input_boost_freq_little
echo "1094400" > /sys/module/cpu_input_boost/parameters/input_boost_freq_big
echo "64" > /sys/module/cpu_input_boost/parameters/input_boost_duration 
echo "1804800" > /sys/module/cpu_input_boost/parameters/max_boost_freq_little
echo "2208000" > /sys/devices/system/cpu/cpu6/cpufreq/max_boost_freq_big
echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor

