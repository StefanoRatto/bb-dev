#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# update nuclei templates database
nuclei -ut -silent

# output directory is created
output_folder=$home/outputs/workflow1/$timestamp
if ! [ -d $output_folder ]; then
  mkdir $output_folder
fi

# confirmation that the script started
echo "[$timestamp] workflow1.sh started at:   $output_folder"

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
        
        # subfinder
        subfinder -dL $input_folder/$filename -silent \
          > $output_folder/subfinder_$filename

        # httpx
        httpx -list $output_folder/subfinder_$filename \
          -silent -no-color -title -tech-detect -status-code -no-fallback -follow-redirects \
          -mc 200 -screenshot -srd $output_folder > $output_folder/httpx_$filename

        # nuclei
        nuclei -l $output_folder/httpx_$filename -s critical,high,medium,low -silent \
          > $output_folder/nuclei_$filename

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

# anything interesting?
#aaa

# send email notification
#aaa

# confirmation that the script completed successfully
echo "[$timestamp] workflow1.sh completed at: $output_folder"
