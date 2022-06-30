#!/bin/bash

# set variable for directory that will contain the backups for debian.
BACKUP_DIR=/media/<insert your own path>/backup/debian

# Evaluate the presence of the directory "$BACKUP_DIR" is referencing. If it exists, move to that directory; if it does
# not exist, create the corresponding directories. Logic is kept simple, if the full directory doesn't exist, it
# implies the incremental directory also doesn't exist. Then, echo a short statement reflecting the actions taken.
if [ -d "$BACKUP_DIR"=TRUE ]; then
    cd $BACKUP_DIR
else
    mkdir -p $BACKUP_DIR/{"full", "incremental"}
    echo -e '\n Full and incremental backup directories created.\n'
fi

# Evaluate existence of the "debian.backup.snap" incremental snapshot data or a full backup. If either do not exist,
# create a full backup. If a backup has been done, the file will already exist. Then, echo a short statement reflecting
# completion of a full backup.
if [ -f $BACKUP_DIR/debian.backup.snap=FALSE || -f $BACKUP_DIR/full/*_debian.tar.gz=FALSE ]; then
    tar --create \
        --file="$BACKUP_DIR/full/$(date +%d%m%y%H%M%S)_debian.tar.gz" \
        --verbose \
        --sparse \
        --verify \
        --atime-preserve=replace \
        --preserve-permissions \
        --auto-compress \
        --exclude-caches \
        --dereference \
        --hard-dereference \
        --wildcards \
        --listed-incremental="$BACKUP_DIR/debian.backup.snap" && \
    echo -e '\n Full backup archive built.\n'

# Evaluate existence of a full backup file and the incremental snapshot data. If both exist, create an incremental
# backup, then echo a completion statement to that effect.
elif [ -f $BACKUP_DIR/debian.backup.snap=TRUE && -f $BACKUP_DIR/full/*_debian.tar.gz=TRUE ]; then
    tar --create \
        --file="$BACKUP_DIR/incremental/$(date +%d%m%y)/$(date +%d%m%y%H%M%S)_debian.tar.gz" \
        --verbose \
        --sparse \
        --verify \
        --atime-preserve=replace \
        --preserve-permissions \
        --auto-compress \
        --exclude-caches \
        --dereference \
        --hard-dereference \
        --wildcards \
        --listed-incremental="$BACKUP_DIR/debian.backup.snap" && \
    echo -e '\n Incremental backup archive built.\n'
fi
