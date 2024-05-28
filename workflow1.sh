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
input_folder=$home/input

for file in "input_folder"/*; do
  # check if it's a regular file and skip anything else
  if [[ -f "$file" ]]; then
    # extract filename without path
    filename=$(basename "$file")

    echo $filename

    if [[ "${filename}" =~ \.txt$ ]]; then
      if [[ "${filename}" =~ ^urls ]]; then
        echo "GO"
      elif [[ "${filename}" =~ ^_urls ]]; then
        echo "OLD"
      fi
    else
      echo "IGNORE"
    fi
  fi
done

# subfinder
#subfinder -d hackerone.com -silent| httpx -title -tech-detect -status-code

# httpx
# aaa

# anything interesting?
# aaa

# send email
#sender_email = "c3rlzmfuby5yyxr0bw@gmail.com"
#receiver_email = "team7261737465@gmail.com"
#password = "kavj hhkd zpak ryqo"
#body = f"[{datetime.now().astimezone().isoformat()}] [PID:{os.getpid()}] [{target}] has CHANGED!"
#message = MIMEText(f"{body} Please check it out...", 'plain')
#message['From'] = "@gmail.com"
#message['To'] = "@gmail.com"
#message['Subject'] = body
#server = smtplib.SMTP('smtp.gmail.com', 587) 
#server.starttls()
#server.login(sender_email, password)
#server.sendmail(sender_email, receiver_email, message.as_string())

