#!/usr/bin/env bash

# TEST ONLY ON MACOS!
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
echo "Top processes - sorted by memory:"
echo "--------------------------------------------------------------------------------"
top -l 1 -n 20 -o mem

echo
echo "--------------------------------------------------------------------------------"
echo "Open files:"
echo "--------------------------------------------------------------------------------"
echo "System:"
sysctl -a | grep num_files | grep -Eo '\d+'
echo
echo "java process:"
lsof -p "${JAVA_PID}" | wc -l

echo
echo "--------------------------------------------------------------------------------"
echo "Threads - java process"
echo "--------------------------------------------------------------------------------"
# https://apple.stackexchange.com/questions/86511/thread-count-of-process-x
ps -M "${JAVA_PID}" | tail +2 | wc -l
echo
# verbose - uncomment if needed
# echo "threads stacks"
# only when jstack is available
#command -v jstack &> /dev/null && jstack "${JAVA_PID}"

echo
echo "--------------------------------------------------------------------------------"
echo "Java process memory details"
echo "--------------------------------------------------------------------------------"
# only when jstat is available
command -v jstat  &> /dev/null && jstat -gc -t "${JAVA_PID}"

echo -e "\n\n\n"
