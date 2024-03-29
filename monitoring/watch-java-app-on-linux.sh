#!/usr/bin/env bash

# WORKS ONLY ON LINUX!
# --------------------
# You can run it like this and keep running for a long time
# then examine the monitor.log
# (the log file consumes a couple of KBs per run)
#      nohup watch -n 20 './watch.sh >> monitor.log' &> /dev/null &

# export JAVA_PID=<your_pid>
# or accept the default provided by $(pgrep java) - DOES NOT WORK with multiple java processes running on the machine!!
JAVA_PID=${JAVA_PID:-$(pgrep java)}

echo "================================================================================"
echo "$(date "+%FT%T")"
echo "================================================================================"

echo
echo "--------------------------------------------------------------------------------"
echo "Memory stats:"
echo "--------------------------------------------------------------------------------"
echo "System:"
free -m
echo
# more verbose - uncomment if you want
# echo "System Details: /proc/meninfo"
# cat /proc/meminfo

echo
echo "--------------------------------------------------------------------------------"
echo "Open files:"
echo "--------------------------------------------------------------------------------"
echo "System:"
cat /proc/sys/fs/file-nr
echo
echo "java process:"
ls -1 /proc/"${JAVA_PID}"/fd | wc -l


echo
echo "--------------------------------------------------------------------------------"
echo "Top processes - sorted by memory:"
echo "--------------------------------------------------------------------------------"
top -b -n1 -o %MEM | head -n20

echo
echo "--------------------------------------------------------------------------------"
echo "Threads - java process"
echo "--------------------------------------------------------------------------------"
ps -p "${JAVA_PID}" -lfT | wc -l
echo
# verbose - uncomment if needed
# echo "threads stacks"
# only when jstack is available
#command -v jstack &> /dev/null && jstack "${JAVA_PID}"

echo
echo "--------------------------------------------------------------------------------"
echo "Java process memory details"
echo "--------------------------------------------------------------------------------"
 only when jstat is available
command -v jstat  &> /dev/null && jstat -gc -t "${JAVA_PID}"

echo -e "\n\n\n"
