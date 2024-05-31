#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# output directory is created
output_folder=$home/output/workflow1/$timestamp
mkdir $output_folder

# confirmation that the script started
echo "[$timestamp] workflow1.sh started at $output_folder"

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
        #go and be awesome...
        #echo "GO!!:     $filename"
        
        # subfinder
        subfinder -dL $input_folder/$filename -silent \
          > $output_folder/subfinder_$filename

        # httpx
        httpx -list $output_folder/subfinder_$filename \
          -silent -title -tech-detect -status-code \
          -screenshot -srd $output_folder > $output_folder/httpx_$filename

        # nuclei
        #doawesomenucleistuff

      elif [[ "$filename" == _urls* ]]; then
        # skips "_urls" input files 
        #echo "SKIPPED:  $filename"
        sleep 1
      fi
    else
      # ignores non-text files
      #echo "IGNORED:  $filename"
      sleep 1
    fi
  fi
done

# anything interesting?
#aaa

# send email notification
#aaa

# confirmation that the script completed successfully
echo "[$timestamp] workflow1.sh completed at $output_folder"
