#!/bin/bash
export PATH=${PATH}:/usr/bin:/usr/local/bin:/bin
# Get timestamp
: ${BACKUP_SUFFIX:=.$(date +"%Y%m%d-%H%M%S")}
readonly tarball=${BACKUP_NAME}_${BACKUP_SUFFIX}.tar.gz

# Create a gzip compressed tarball with the volume(s)
tar czf ${tarball} ${BACKUP_TAR_OPTION} ${PATHS_TO_BACKUP}

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aliyuncli oss GetAllBucket | grep ${OSS_BUCKET} | wc -l)
if [ ${BUCKET_EXIST} -eq 0 ];
then
  aliyuncli oss CreateBucket oss://${OSS_BUCKET}
fi

# Upload the backup to oss with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp $tarball s3://$S3_BUCKET_NAME/$tarball
aliyuncli oss MultiUpload ${tarball} $BACKUP_BUCKET_DIR --thread_num 5

# Clean up
rm $tarball
