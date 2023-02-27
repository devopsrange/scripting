#!/bin/bash

log_file=zenigma.log
script_file=zenigma.sh
killer_log=killer.log

while true
do
  count=$(wc -l < $log_file)
  if [ $count -ge 20 ]
  then
    echo "$(date +"%Y-%m-%d %H:%M:%S"): Record count is $count, killing $script_file" >> $killer_log
    pkill -f $script_file
    deletion_status=$?
    rm $log_file
    deletion_status=$((deletion_status + $?))
    if [ $deletion_status -eq 0 ]
    then
      echo "$(date +"%Y-%m-%d %H:%M:%S"): Deleted $log_file" >> $killer_log
      nohup ./$script_file > $log_file 2>&1 &
      echo "$(date +"%Y-%m-%d %H:%M:%S"): Started $script_file" >> $killer_log
    else
      echo "$(date +"%Y-%m-%d %H:%M:%S"): Failed to delete $log_file" >> $killer_log
    fi
  fi
  sleep 10
done
