#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# confirmation that the script is running
echo "[$timestamp] runner.sh is alive with PID $$"

# enters the infinite loop
while true; do

  current_mins=$(date -u +"%M")
  
  # performs actions at the top of every hour
  if [[ "$current_mins" == "00" ]]; then
    echo "[$timestamp] runner.sh is alive with PID $$"

    # launches workflows
    $home/workflow1.sh
    
    # sleeps 30 seconds not to tax the cpu
  fi
  
  sleep 30

done
