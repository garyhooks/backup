#!/bin/bash
############################################################
#                                                          #
#            Backup Important directories                  #
# 	     						                                       #
#	           Author: Gary Hooks                            #  
#            Web: http://www.twintel.co.uk		             #
#            Email: garyhooks@gmail.com  		               #
#            Publish Date: 15th December 2016  		         #
#            Licence: GNU GPL 				                     #
#                                                          #
############################################################


## SET BACKUP LOCATION ##
## MAKE SURE THIS EXISTS - if not then mkdir ##
BACKUP_DIR=/home/backup


## CLEAN UP THE OLDER FILES - REMOVE OLDER FILES ##
## THIS REMOVES DIRECTORIES - HOME/WEB/MYSQL - if they are older than 2 days ##
find $BACKUP_DIR/HOME/* -type f -mtime +2 -exec rm {} \;
find $BACKUP_DIR/WEB/* -type f -mtime +2 -exec rm {} \;
find $BACKUP_DIR/MYSQL/* -type f -mtime +2 -exec rm {} \;

## GET DATE ##
NOW=$(date +"%d-%B-%Y")


## BACKUP WEB DIRECTORIES TO $BACKUP ##
tar -cf $BACKUP_DIR/WEB/website1.co.uk-"$NOW" /var/www/website1.co.uk --overwrite
tar -cf $BACKUP_DIR/WEB/website2.co.uk-"$NOW" /var/www/website2.co.uk --overwrite

## BACKUP MY HOME DIRECTORY TO $BACKUP ##
tar -cf $BACKUP_DIR/HOME/john-"$NOW" /home/john --overwrite
tar -cf $BACKUP_DIR/HOME/sarah-"$NOW" /home/sarah --overwrite
tar -cf $BACKUP_DIR/HOME/bill-"$NOW" /home/bill --overwrite

## BACKUP MYSQL DATABASE ##
mysqldump -u root -pPASSWORD --all-databases > $BACKUP_DIR/MYSQL/database-"$NOW".sql

## NOW EMAIL ALL OF THE RELEVANT BACKUP FILES TO MY EMAIL ADDRESS ##
## OBVIOUSLY only works if you have SMTP or SENDMAIL set up on the server - feel free to not do this bit ##
## /home/backup/mail.txt contains the MAIL script ##

mail -a $BACKUP_DIR/WEB/website1.co.uk-"$NOW" -s "$NOW - website1" -t < /home/backup/mail.txt
mail -a $BACKUP_DIR/WEB/website2.co.uk-"$NOW" -s "$NOW - website2" -t < /home/backup/mail.txt
mail -a $BACKUP_DIR/HOME/john-"$NOW" -s "$NOW - home-john" -t < /home/backup/mail.txt
mail -a $BACKUP_DIR/HOME/sarah-"$NOW" -s "$NOW - home-sarah" -t < /home/backup/mail.txt
mail -a $BACKUP_DIR/HOME/bill-"$NOW" -s "$NOW - home-bill" -t < /home/backup/mail.txt
mail -a $BACKUP_DIR/MYSQL/database-"$NOW".sql -s "$NOW - database backup.co.uk" -t < /home/backup/mail.txt
