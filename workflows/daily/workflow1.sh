#!/bin/bash

# define home folder
home=$(pwd)

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp
current_year=$(date -u +"%Y")
current_month=$(date -u +"%m")

# update nuclei templates database
nuclei -ut -silent

# output directory is created
output_folder=$home/outputs/workflow1/$current_year/$current_month/$timestamp
if ! [ -d $output_folder ]; then
  mkdir -p $output_folder
fi

# confirmation that the script started
echo "[$($home/now.sh)] workflow1.sh started at:   $output_folder"

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
        #echo "Let's gooo!!:  $filename"
        
        # "cleaning" the fqdns from the scope files
        sed -i 's/*.//g' $input_folder/$filename      
        sed -i 's/http:\/\///g' $input_folder/$filename
        sed -i 's/https:\/\///g' $input_folder/$filename
       
        # creating the subfinder output file with the content of the input file
        cp $input_folder/$filename $output_folder/subfinder_$filename
        # adding a new line to solve a formatting problem
        echo >> $output_folder/subfinder_$filename
        
        # subfinder
        subfinder -dL $input_folder/$filename -silent \
          >> $output_folder/subfinder_$filename

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
  
  # copies all mediums, highs and crits to a temp file
  grep -E "medium|high|critical" "$output_folder/nuclei_$filename" > "$output_folder/temp_$filename"
  
  # replacing all tab characters with spaces
  sed -i 's/\t/ /g' "$output_folder/temp_$filename"

  # removing duplicate spaces in each line
  sed -i 's/  */ /g' "$output_folder/temp_$filename"

  # removes duplicate lines
  awk '!seen[$0]++' "$output_folder/temp_$filename" > temp && mv temp "$output_folder/temp_$filename"

  # if an entry is not in the results file, then the entry is added to the results file 
  # and also added to the notify file, which is the file that will be sent over email
  while IFS= read -r line; do
    if ! grep -Fxq "$line" "$home/outputs/workflow1/results_$filename"; then
      echo $line >> "$home/outputs/workflow1/results_$filename"
      echo $line >> "$output_folder/notify_$filename"
    fi
  done < "$output_folder/temp_$filename"
  
  rm $output_folder/temp_$filename
  
  # if there is new content to be notify over, then the email is sent
  if [ -f "$output_folder/notify_$filename" ]; then
    sed -i 's/$/ /' $output_folder/notify_$filename
    $home/email.sh "bb-dev - workflow1/$timestamp" "$output_folder/notify_$filename" > /dev/null 2>&1
  fi
fi

# confirmation that the script completed successfully
echo "[$($home/now.sh)] workflow1.sh completed at: $output_folder"
