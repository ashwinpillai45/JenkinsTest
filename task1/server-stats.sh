#Total CPU usage
#Total memory usage (Free vs Used including percentage)
#Total disk usage (Free vs Used including percentage)
#Top 5 processes by CPU usage
#Top 5 processes by memory usage

idle_time=$(vmstat 1 2 | tail -n 2 | awk '{ id += $15 } { id /= 2 } \
                                    { id = 100 - id }END { print id }')
echo "CPU Usage : ${idle_time}"
total_memory=$(vmstat -s | head -n 1 | awk -F " " '{ print $1 }')
free_memory=$(vmstat -s | head -n 5 | tail -n 1 | awk -F " " '{ print $1 }')
used_memory=$((total_memory - free_memory))
echo "Free memory : $((free_memory / 1024))MB ($((free_memory * 100 / total_memory))%)"
echo "Used memory : $((used_memory / 1024))MB ($((used_memory * 100 / total_memory))%)"
total_disk=$( df -h | head -n 2 | tail -n 1| awk -F " " '{ print $1 }')
use_per=$( df -h | head -n 2 | tail -n 1| awk -F " " '{ print $5 }' | tr -cd '[:digit:]' )
free_per=$((100 - use_per))
free_disk=$( df -h | head -n 2 | tail -n 1| awk -F " " '{ print $4 }')
echo "Free Disk Space : $free_disk (${free_per}%))"
used_disk=$(df -h | head -n 2 | tail -n 1| awk -F " " '{ print $3 }')
echo "Used Disk Space : $used_disk (${use_per}%))"
top_five_process_cpu=$(top | head -n 12 | tail -n 5 | awk -F " " '{ print $13 }')
echo "Top 5 process by cpu usage:" 
echo $top_five_process_cpu
top_five_process_mem=$(top --sort=%CPU | head -n 12 | tail -n 5 | awk -F " " '{print $13}')
echo "Top 5 process by memory usage:"
echo $top_five_process_mem