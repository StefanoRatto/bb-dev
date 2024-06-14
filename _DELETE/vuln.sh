#!/bin/bash

HOSTS_FILE=input.txt
NVD_API_KEY="6671d045-6683-4e4d-bc88-4cf2e9e526e7" # Replace with your actual NVD API key
OUTPUT_FILE="output.txt"
TEMP_FILE="temp.txt"

# Clear output file if it exists
> "$OUTPUT_FILE"

# Read hosts file and scan each host
while IFS= read -r HOST; do
  echo "Scanning $HOST..."

  # Run nmap scan with vulners and vulnscan scripts
  nmap --script vulners,vulscan -oN "$TEMP_FILE" "$HOST"
  
  # Extract CVE IDs from nmap results
  CVE_IDS=$(grep -oP 'CVE-\d{4}-\d+' "$TEMP_FILE")

  # Process each CVE ID
  for CVE_ID in $CVE_IDS; do
    # Fetch CVSSv3 score using NVD NIST API v2.0
    RESPONSE=$(curl -s "https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=$CVE_ID" -H "apiKey:$NVD_API_KEY")
    CVSSv3_SCORE=$(echo "$RESPONSE" | jq -r '.vulnerabilities[0].metrics.cvssMetricV2[0].cvssData.baseScore')

    # Check if CVSSv3 score is above threshold and write to output file
    if (( $(echo "$CVSSv3_SCORE > 8.0" | bc -l) )); then
      echo "$HOST - $CVE_ID: $CVSSv3_SCORE" >> "$OUTPUT_FILE"
    fi
  done

  echo "Finished scanning $HOST."
done < "$HOSTS_FILE"

echo "Vulnerability report generated in $OUTPUT_FILE"

