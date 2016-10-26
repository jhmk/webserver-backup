#!/bin/sh

##########################################
# Content
##########################################
echo "Starting backup of /var/www/„
sudo zip -r -0 /backup-script/webserver-files/webserver_`date +%Y-%m-%d`.zip /var/www/*

##########################################
# Settings
##########################################
echo "Starting backup of etc/"

sudo zip -r -0 /backup-script/etc-files/etc_`date +%Y-%m-%d`.zip /etc/*

##########################################
# Crypto with Password
# Encrypt: sudo openssl enc -aes-256-ctr -salt -in ###.zip -out ###.zip.aes -pass pass:PASSWORD
# Decrypt: sudo openssl aes-256-ctr -d -salt -in ###.zip.aes -out ###.zip -pass pass:PASSWORD

# Crypto with Key
# Encrypt: sudo openssl enc -aes-256-ctr -salt -in ###.zip -out ###.zip.aes -pass file:KEY
# Decrypt: sudo openssl aes-256-ctr -d -salt -in ###.zip.aes -out ###.zip -pass file:KEY
##########################################
echo "Starting encrypt zip files“

openssl enc -aes-256-ctr -salt -in //backup-script/webserver-files/webserver_`date +%Y-%m-%d`.zip -out /backup-script/webserver-files/webserver_`date +%Y-%m-%d`.zip.aes -pass pass:PASSWORD

openssl enc -aes-256-ctr -salt -in /backup-script/etc-files/etc_`date +%Y-%m-%d`.zip -out /backup-script/etc-files/etc_`date +%Y-%m-%d`.zip.aes -pass pass:PASSWORD

##########################################
# Remove ZIP Files
##########################################
echo "Starting removing zip files“

sudo rm /backup-script/webserver-files/webserver_`date +%Y-%m-%d`.zip
sudo rm /backup-script/etc-files/etc_`date +%Y-%m-%d`.zip

##########################################
# move the files to S3 #
##########################################

echo "Starting upload of www to S3"
sudo aws s3 cp /backup-script/webserver-files/*.aes s3://BUCKET/

echo "Starting upload of etc to S3"
sudo aws s3 cp /backup-script/etc-files/*.aes  s3://BUCKET/

echo "Upload finish"

########################
### Delete uploaded files####
#######################


echo "Delete webserver-files archive"
sudo rm /backup-script/webserver-files/*

echo "Delete redmine etc archive"
sudo rm /backup-script/etc-files/*
