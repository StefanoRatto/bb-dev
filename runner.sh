#!/bin/bash

# define home folder
home=$(pwd)
home_daily=$home/workflows/daily/
home_hourly=$home/workflows/hourly/

# define time stamp
timestamp=$($home/now.sh)

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
echo "[$($home/now.sh)] runner.sh is alive with PID $$, ctrl+c to exit"

# enters the infinite loop
while true; do

  #current_mins=$(date -u +"%M")
  #current_hours=$(date -u +"%H")
  current_mins="00"
  current_hours="06"
  
  # main scheduler
  if [[ "$current_mins" == "00" ]]; then
    
    echo "[$($home/now.sh)] runner.sh is alive with PID $$, ctrl+c to exit"
    
    if [[ "$current_hours" == "06" ]]; then
      # launches workflows every day at 6:00 AM UTC
      for file in "$home_daily"*; do
        if [ -f "$file" ]; then
        
          ext="${file##*.}"
          filename="$(basename "$file")"

          if [ "$ext" == "sh" ]; then
            if [[ "$filename" == workflow* ]]; then
              # launches the workflow
              $file &

            elif [[ "$filename" == _* ]]; then
              # skips all workflows with name starting with "_"
              #echo "SKIPPED:       $filename"
              :

            else
              # ignores text files that do not follow the naming convention
              #echo "IGNORED:       $filename"
              :

            fi
          else
            # ignores non-bash files
            #echo "IGNORED:       $filename"
            :

          fi
        fi
      done
    fi
    
    # launches workflows at the top of every hour
    for file in "$home_hourly"*; do
      if [ -f "$file" ]; then
      
        ext="${file##*.}"
        filename="$(basename "$file")"

        if [ "$ext" == "sh" ]; then
          if [[ "$filename" == workflow* ]]; then
            # launches the workflow
            $file &

          elif [[ "$filename" == _urls* ]]; then
            # skips all workflows with name starting with "_"
            #echo "SKIPPED:       $filename"
            :

          else
            # ignores text files that do not follow the naming convention
            #echo "IGNORED:       $filename"
            :

          fi
        else
          # ignores non-text files
          #echo "IGNORED:       $filename"
          :

        fi
      fi
    done
  fi

  # sleeps 1 minute not to tax the cpu
  sleep 60

done
