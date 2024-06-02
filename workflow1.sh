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
echo "[$($home/now.sh)] workflow1.sh started at:   $output_folder"

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
        #echo "Let's gooo!!:  $filename"
        
        # subfinder
        subfinder -dL $input_folder/$filename -silent \
          > $output_folder/subfinder_$filename

        # httpx
        httpx -list $output_folder/subfinder_$filename \
          -silent -no-color -title -tech-detect -status-code -no-fallback -follow-redirects \
          -mc 200 -screenshot -srd $output_folder > $output_folder/httpx_$filename

        # nuclei reads a list of urls, so the httpx output as is needs to be "cleaned"
        awk '{print $1}' $output_folder/httpx_$filename > $output_folder/temp_$filename
        # nuclei
        nuclei -l $output_folder/temp_$filename -s critical,high,medium,low \
          -silent -no-color > $output_folder/nuclei_$filename
        # the temporary file needed by nuclei gets deleted
        rm $output_folder/temp_$filename

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
  :
done

# if nuclei finds any medium, high or critical, the workflow sends an email notification
if grep -qE "medium|high|critical" "$output_folder/nuclei_$filename"; then
#if grep -qE "medium|critical" "$output_folder/nuclei_$filename"; then
  grep -E "medium|high|critical" "$output_folder/nuclei_$filename" > "$output_folder/notify_$filename"
  sed -i 's/$/\n/' $output_folder/notify_$filename
  $home/email.sh "bb-dev - workflow1/$timestamp" "$output_folder/notify_$filename" > /dev/null 2>&1
fi

# confirmation that the script completed successfully
echo "[$($home/now.sh)] workflow1.sh completed at: $output_folder"
