#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp
current_year=$(date -u +"%Y")
current_month=$(date -u +"%m")

# reading config to retrieve nist nvd api key
source ~/.bb-dev_config

# output directory is created
output_folder=$home/outputs/workflow2/$current_year/$current_month/$timestamp
if ! [ -d $output_folder ]; then
  mkdir -p $output_folder
fi

# confirmation that the script started
echo "[$($home/now.sh)] workflow2.sh started at:   $output_folder"

# loops over programs/scopes
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

        # nmap
        # reads the input file from subfinder, then runs nmap on each host and appends the results in the output file
        while IFS= read -r line; do
          
          # best nmap command line options
          nmap -sV --script vulners,vuln -p- --script-args mincvss=8.0 - $line 2> /dev/null > $output_folder/nmap_$filename
          
          # CVE_ID="CVE-2021-44228"
          # echo $(echo "$(curl -s -H "apiKey: $NIST_NVD_API_KEY" "https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=$CVE_ID")" | jq -r '.vulnerabilities[0].cve.metrics.cvssMetricV31[0].cvssData.baseScore')
          # echo $(curl -s "https://services.nvd.nist.gov/rest/json/cve/2.0/$cve_id?apiKey=$nvd_api_key" | jq -r '.vulnerabilities[0].cve.metrics.cvssMetricV31[0].cvssData.baseScore // .vulnerabilities[0].cve.metrics.cvssMetricV30[0].cvssData.baseScore')
          # exit 0
        
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
