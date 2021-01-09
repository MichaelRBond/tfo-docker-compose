#!/bin/bash

set -e

source /root/DOCKER_ENV
MYSQL_BACKUP_DIR=/mnt/tfo-volume-01/backups/mysql
mkdir -p "${MYSQL_BACKUP_DIR}"

MONTH=$(date +%m)
DAY=$(date +%d)
YEAR=$(date +%Y)

BACKUP_FILENAME="grapevine_rss.backup.${YEAR}.${MONTH}.${DAY}.sql"
docker exec src_grapevine-mysql_1 /usr/bin/mysqldump -u grapevine --password="${DB_PASSWD}" grapevine_rss > "${MYSQL_BACKUP_DIR}/${BACKUP_FILENAME}"
