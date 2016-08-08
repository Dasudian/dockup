
# Dockup

Docker image to backup your Docker container volumes, a fork implement from tutumcloud/dockup.  
Implement the ALIYUN OSS storage backend support.   

# Usage

You have a container running with one or more volumes:

```
$ docker run -d --name mysql mysql
```

From executing a `$ docker inspect mysql` we see that this container has a volumes:

```
"Volumes": {
            "/var/lib/mysql": {}
        }
```

## Backup
Launch `dockup` container with the following flags:

```
$ docker run --rm \
--env-file env.txt \
--volumes-from mysql \
--name dockup dasudian/dockup:latest
```

The contents of `env.txt` being:

```
OSS_ACCESS_ID=<id_here>
OSS_ACCESS_KEY=<key_here>
OSS_HOST=oss-cn-shenzhen.aliyuncs.com
BACKUP_NAME=mysql
PATHS_TO_BACKUP=/var/lib/mysql
OSS_BUCKET=xxx-buckups
RESTORE=false
```

`dockup` will use your ALIYUN credentials to create a new bucket with name as per the environment variable `OSS_BUCKET`, or if not defined, using the default name `xxx-buckups`. The paths in `PATHS_TO_BACKUP` will be tarballed, gzipped, time-stamped and uploaded to the OSS bucket.


## Restore
To restore your data simply set the `RESTORE` environment variable to `true` - this will restore the latest backup from OSS to your volume.

To perform a restore launch the container with the RESTORE variable set to true
