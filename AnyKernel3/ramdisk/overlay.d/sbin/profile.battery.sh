#!/system/bin/sh

# Battery
echo "blu_schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 
echo "blu_schedutil" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor 
echo "1497600" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "1094400" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_max_freq
echo "1017600" > /sys/module/cpu_input_boost/parameters/input_boost_freq_little
echo "0" > /sys/module/cpu_input_boost/parameters/input_boost_freq_big
echo "32" > /sys/module/cpu_input_boost/parameters/input_boost_duration 
echo "1497600" > /sys/module/cpu_input_boost/parameters/max_boost_freq_little
echo "1094400" > /sys/devices/system/cpu/cpu6/cpufreq/max_boost_freq_big
echo "powersave" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
