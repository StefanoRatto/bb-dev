#!/bin/bash

# define home folder
home=$(pwd)
#echo $home

# define time stamp
timestamp=$($home/now.sh)
#echo $timestamp

# reading email config
source ~/.bb-dev_config

# sending the email
sendemail -l email.log				\
    -f $EMAIL_SENDER				\
    -u "runner.sh at $timestamp"	\
    -t $EMAIL_RECIPIENT				\
    -s "smtp.aol.com:587"			\
    -o tls=yes						\
    -xu $EMAIL_SENDER_USERNAME		\
    -xp $EMAIL_SENDER_PASSWORD	    \
    -m "hello from bb-dev"