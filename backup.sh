#!/bin/bash
export PATH=${PATH}:/usr/bin:/usr/local/bin:/bin
# Get timestamp
: ${BACKUP_SUFFIX:=$(date +"%Y%m%d-%H%M%S")}
readonly tarball=${BACKUP_NAME}-${BACKUP_SUFFIX}.tar.gz

# Create a gzip compressed tarball with the volume(s)
tar czf ${tarball} ${BACKUP_TAR_OPTION} ${PATHS_TO_BACKUP}

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aliyuncli oss GetAllBucket | grep ${OSS_BUCKET} | wc -l)
if [ ${BUCKET_EXIST} -eq 0 ];
then
  aliyuncli oss CreateBucket oss://${OSS_BUCKET}
fi

# Upload the backup to oss with timestamp
aliyuncli oss MultiUpload ${tarball} oss://${OSS_BUCKET}/ --thread_num 5

# Clean up
rm ${tarball}
