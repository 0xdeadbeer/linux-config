#!/usr/bin/bash

# debug
set -x

BACKUP_DISK=$1
if [ -z "$1" ]
  then
    echo "Setup: to adapt the script to YOUR system preferences here's some basic information for you
          \$BACKUP_LOCATION variable is the folder location where the backups will be written,
          \$DATE variable is the date format that's going to be used inside each backup's name,
          \$OUTPUT_FOLDER_LOCATION variable is the 'calculated' folder name for the new backup that's being created
          \$TO_BACKUP_FOLDER variable is the location of a folder, containing soft links to all the files and directories you want to backup
          \$TMP_BACKUP_LOCATION variable is the 'calculated' temp folder name for the new backup that's being created (first, it makes a temp backup folder -> converts into zip -> moves zip into the OUTPUT_FOLDER_LOCATION location -> removes the temp files)
          \$OUTPUT_TMP_BACKUP_LOCATION specific location of the temp backup folder
          \$BACKUP_LIMIT variable is the number of backups you want stored inside of the backup folder
              once the limit is reached, the oldest backup will be deleted!"
    echo "First argument must be the location of the backup drive"
    echo "Example: /home/chris/backup_drive"
    echo "Cronjob example: 1 18,22 * * * /home/$USER/.scripts/fsector_one_backup.sh /media/$USER/backup_drive"
    echo "Cronjob description: Run the backup script everyday at 18:01 and 22:01. With the backup location being /media/$USER/backup_drive/linux/.backups"
    echo "Warning: Backups are by default stored in \$DRIVE_LOCATION/linux/.backups/"
    exit 1
fi

TMP_BACKUP_LOCATION=/home/USER/.scripts-output/backups
BACKUP_LOCATION=$BACKUP_DISK/linux/.backups
DATE=$(date +"%Y_%m_%d_____%H_%M_%S")
OUTPUT_FOLDER_LOCATION=$BACKUP_LOCATION/backup_$DATE
OUTPUT_TMP_BACKUP_LOCATION=$TMP_BACKUP_LOCATION/backup_$DATE
TO_BACKUP_FOLDER=/home/USER/.symlinks/backup_links
ACKUPS_LIMIT=20

# if the disk is not mounted, mount it 
if ! mountpoint -q "$BACKUP_DISK"
then
  echo "disk not mounted, mounting"
  sudo mount "$BACKUP_DISK"
fi

# make the new backup subfolder 
# mkdir "$OUTPUT_FOLDER_LOCATION"
mkdir "$OUTPUT_TMP_BACKUP_LOCATION"

for link in $TO_BACKUP_FOLDER/*
do
  BASENAME=$(basename $link)
  if [[ -L "$link" && -d "$link" ]] # if the link points to a dir, copy the whole dir
  then
    mkdir "$OUTPUT_TMP_BACKUP_LOCATION/$BASENAME/"
    cp -Lrf $link/* "$OUTPUT_TMP_BACKUP_LOCATION/$BASENAME/"
  else # if the link points to a file, copy only the file 
    cp -Lrf $link "$OUTPUT_TMP_BACKUP_LOCATION/$BASENAME"
  fi 
done

# zip the folder 
zip --password zip -r "$OUTPUT_TMP_BACKUP_LOCATION.zip" "$OUTPUT_TMP_BACKUP_LOCATION"

# move the folder into the backups folder
# and remove the unnecessary tmp files 

mv "$OUTPUT_TMP_BACKUP_LOCATION.zip" "$OUTPUT_FOLDER_LOCATION.zip"

rm -rf "$OUTPUT_TMP_BACKUP_LOCATION"
rm -rf "$OUTPUT_TMP_BACKUP_LOCATION.zip"

# if there's more than 5 folders in the backup directory, delete the oldest one 
while [[ $(ls "$BACKUP_LOCATION" | wc -l) -gt "$BACKUPS_LIMIT" ]]
do
  TO_DELETE=$(ls -tr "$BACKUP_LOCATION" | head -n1)
  rm -rf "$BACKUP_LOCATION/$TO_DELETE"  
done
