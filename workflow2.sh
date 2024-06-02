#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# output directory is created
output_folder=$home/outputs/workflow2/$timestamp
if ! [ -d $output_folder ]; then
  mkdir $output_folder
fi

# confirmation that the script started
echo "[$($home/now.sh)] workflow2.sh started at:   $output_folder"

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
        #echo "Let's gooo!!:     $filename"
        
        # subfinder
        subfinder -dL $input_folder/$filename -silent \
          > $output_folder/subfinder_$filename

        # nmap
        # reads the input file from subfinder, then runs nmap on each host and appends the results in the output file
        while IFS= read -r line
        do
          echo $line >> $output_folder/nmap_$filename
          # ideal and most comprehensive nmap command line options (too slow)
          #nmap -sV --script="vuln,auth,exploit,malware,intrusive" -oG output.gnmap $line >> output_folder/nmap_$filename
          # current nmap command line options (still suuuuper slow)
          nmap -sV --script=vulscan/vulscan.nse, $line 2> /dev/null >> $output_folder/nmap_$filename
          # adding an empty line in between all host scans
          echo >> $output_folder/nmap_$filename
        done < "$output_folder/subfinder_$filename"

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
echo "[$($home/now.sh)] workflow2.sh completed at: $output_folder"
