#!/bin/bash

# Find last backup file
: ${LAST_BACKUP:=$(aliyuncli oss List oss://${OSS_BUCKET} | grep ^$BACKUP_NAME | awk -F " " '{print $5}' | sort -r | head -n1)}
readonly last_backup_file=${LAST_BACKUP##*/}

# Download backup from oss
aliyuncli oss MultiGet ${LAST_BACKUP} ${last_backup_file} --thread_num 5

# Extract backup
tar xzf ${last_backup_file} $RESTORE_TAR_OPTION
