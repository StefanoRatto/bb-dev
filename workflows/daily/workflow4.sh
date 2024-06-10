#!/bin/bash

# test echo message
echo "Hello from $0"
exit 0

# define home folder
home=$(dirname "$PWD")
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# output directory is created
output_folder=$home/outputs/workflow4/$timestamp
if ! [ -d $output_folder ]; then
  mkdir $output_folder
fi

# confirmation that the script started
echo "[$($home/now.sh)] workflow4.sh started at:   $output_folder"

# loop over programs/scopes
# all programs scope files with name starting with "urls_" are processed
# all programs scope files with name starting with "_urls_" are ignored
input_folder=$home/inputs

for file in "$input_folder"/*; do
  if [ -f "$file" ]; then
   
    ext="${file##*.}"
    filename="$(basename "$file")"

    if [ "$ext" == "txt" ]; then
      if [[ "$filename" == urls* ]]; then
        #go and be awesome...
        #echo "Let's gooo!!:     $filename"
        :
      elif [[ "$filename" == _urls* ]]; then
        # skips "_urls" input files 
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

# confirmation that the script completed successfully
echo "[$($home/now.sh)] workflow4.sh completed at: $output_folder"
