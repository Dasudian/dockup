FROM ubuntu:trusty
MAINTAINER Mengz <mz@dasudian.com>

RUN apt-get update && \
  apt-get install -y python-pip && \
  pip install aliyuncli aliyun-python-sdk-oss
  
ENV STORAGE="OSS" \
  OSS_BUCKET="xxx-backups" \
  OSS_ACCESS_ID="**DefineMe**" \
  OSS_ACCESS_KEY="**DefineMe**" \
  OSS_HOST="oss-cn-shenzhen.aliyuncs.com" \
  PATHS_TO_BACKUP="/path/to/backup" \
  BACKUP_NAME="backup" \
  RESTORE="false"
  
ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD docker-entrypoint.sh /entrypoint
RUN chmod 755 /*.sh


CMD ["/entrypoint"]
