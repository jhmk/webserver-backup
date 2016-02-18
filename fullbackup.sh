#!/bin/sh

##################
# Zip & Copy Website #
##################

echo "Zip & Copy Website"
7za a -tzip '-pPASSWORD' -mem=AES256 /PATH/website-files/`date +%Y-%m-%d`-website-files.zip /usr/share/nginx/*

##################
# Zip & Copy NGINX #
##################

echo "Zip & Copy NGINX"
7za a -tzip '-pPASSWORD' -mem=AES256 /PATH/nginx-files/`date +%Y-%m-%d`-nginx-files.zip /etc/nginx/*

##################
# MySQL Dump #
##################

echo "Starting MySQL Dump"
mysqldump --all-databases --user=root --password=PASSWORT --events  > mysql-database/all-db.sql
7za a -tzip '-pPASSWORD' -mem=AES256 /PATH/mysql-database/`date +%Y-%m-%d`-all-db.sql.zip mysql-database/all-db.sql
rm mysql-database/all-db.sql

##########################################
# move the files to S3 #
##########################################

echo "Starting Website Files upload to S3"
aws s3 mv /PATH/website-files/* s3://URL/

echo "Starting NGINGX Files upload to S3"
aws s3 mv /PATH/nginx-files/* s3://URL/

echo "Starting MySQL Dump upload to S3"
aws s3 mv /PATH/mysql-database/* s3://URL/

#######
# END #
#######
