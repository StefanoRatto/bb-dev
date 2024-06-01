#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# output directory is created
output_folder=$home/outputs/workflow3/$timestamp
if ! [ -d $output_folder ]; then
  mkdir $output_folder
fi

# confirmation that the script started
echo "[$timestamp] workflow3.sh started at:   $output_folder"

# loop over programs/scopes
# all programs scope files with name starting with "urls_" are processed
# all programs scope files with name starting with "_urls_" are ignored
input_folder=$home/inputs/

for file in "$input_folder"/*; do
  if [ -f "$file" ]; then
   
    ext="${file##*.}"
    filename="$(basename "$file")"

    if [ "$ext" == "txt" ]; then
      if [[ "$filename" == urls* ]]; then
        #go and be awesome...
        #echo "GO!!:     $filename"
        sleep 1
      elif [[ "$filename" == _urls* ]]; then
        # skips "_urls" input files 
        #echo "SKIPPED:  $filename"
        :
      fi
    else
      # ignores non-text files
      #echo "IGNORED:  $filename"
      :
    fi
  fi
done

# confirmation that the script completed successfully
echo "[$timestamp] workflow3.sh completed at: $output_folder"
