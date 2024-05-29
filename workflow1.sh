#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# output directory is created
output_folder=$home/output/$timestamp
#mkdir $output_folder

# loop over programs/scopes
# all programs scope files with name starting with "urls" are processed
# all programs scope files with name starting with "_" are ignored
input_folder=$home/input/

for file in "$input_folder"/*; do
  if [ -f "$file" ]; then
   
    ext="${file##*.}"
    filename="$(basename "$file")"

    if [ "$ext" == "txt" ]; then
      if [[ "$filename" == urls* ]]; then
        #echo "GO!!:     $filename"
        #go and be awesome...
      elif [[ "$filename" == _urls* ]]; then
        # skips "_urls" input files 
        #echo "SKIPPED:  $filename"
      fi
    else
      # ignores non-text files
      #echo "IGNORED:  $filename"
    fi
  fi
done

# subfinder
#subfinder -d hackerone.com -silent| httpx -title -tech-detect -status-code

# httpx
#aaa

# anything interesting?
#aaa

# send email notification
#aaa
