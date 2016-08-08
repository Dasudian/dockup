#!/bin/bash

# Configure the ALIYUN OSS CLI
aliyuncli oss Config --host ${OSS_HOST} --accessid ${OSS_ACCESS_ID} --accesskey ${OSS_ACCESS_KEY}

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh
fi

if [ -n "$CRON_TIME" ]; then
  echo "${CRON_TIME} /backup.sh >> /dockup.log 2>&1" > /crontab.conf
  crontab  /crontab.conf
  echo "=> Running dockup backups as a cronjob for ${CRON_TIME}"
  exec cron -f
fi
