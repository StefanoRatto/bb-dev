#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp


# welcome to runner.sh
echo "                                                                        "
echo " ██████╗ ██╗   ██╗███╗  ██╗███╗  ██╗███████╗██████╗     ██████╗██╗  ██╗ "
echo " ██╔══██╗██║   ██║████╗ ██║████╗ ██║██╔════╝██╔══██╗   ██╔════╝██║  ██║ "
echo " ██████╔╝██║   ██║██╔██╗██║██╔██╗██║█████╗  ██████╔╝   ╚█████╗ ███████║ "
echo " ██╔══██╗██║   ██║██║╚████║██║╚████║██╔══╝  ██╔══██╗    ╚═══██╗██╔══██║ "
echo " ██║  ██║╚██████╔╝██║ ╚███║██║ ╚███║███████╗██║  ██║██╗██████╔╝██║  ██║ "
echo " ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚══╝╚═╝  ╚══╝╚══════╝╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝ "
echo "      unelegant and simplistic recon automation framework by team7      "
echo "                                                                        "

# confirmation that the script is running
echo "[$timestamp] runner.sh is alive with PID $$, ctrl+c to exit"

# enters the infinite loop
while true; do

  current_mins=$(date -u +"%M")
  current_hours=$(date -u +"%H")

  # for testing
  current_mins="00"
  current_hours="00"

  # main scheduler
  if [[ "$current_mins" == "00" ]]; then
    
    echo "[$timestamp] runner.sh is alive with PID $$, ctrl+c to exit"
    
    if [[ "$current_hours" == "00" ]]; then
      # launches workflows at the top of every hour
      $home/workflow2.sh &
    fi
    
    # launches workflows at the top of every hour
    $home/workflow1.sh &
    #$home/workflow3.sh &
  fi

  # sleeps 30 seconds not to tax the cpu
  sleep 30

done
