#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 容器里面备份数据库功能和打包服务端
FILENAME=$(date "+%Y-%m-%d")
TLBBDB_LOG_PATH="/home/backup/tlbbdb_backup_${FILENAME}.log"
WEB_LOG_PATH="/home/backup/web_backup_${FILENAME}.log"
# 如果是空库则不进行备份
WEB_FILE_NUM=$(ls -l /var/lib/mysql/web | grep '^-' | wc -l)
TLBBDB_FILE_NUM=$(ls -l /var/lib/mysql/tlbbdb | grep '^-' | wc -l)

if [ ${WEB_FILE_NUM} -gt 1 ]; then
    mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb >/home/backup/tlbbdb-${FILENAME}.sql
    #判断是否备份成功
    if [ $? -eq 0 ]; then
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\ttlbbdb-${FILENAME}.sql\t备份成功!!\r\n" | tee -a $TLBBDB_LOG_PATH
    else
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\ttlbbdb-${FILENAME}.sql\t备份失败\r\n" | tee -a $TLBBDB_LOG_PATH
    fi
fi

if [ ${TLBBDB_FILE_NUM} -gt 1 ]; then
    mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" web >/home/backup/web-${FILENAME}.sql
    #判断是否备份成功
    if [ $? -eq 0 ]; then
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\tweb-${FILENAME}.sql\t备份成功\r\n" | tee -a $WEB_LOG_PATH
    else
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\tweb-${FILENAME}.sql\t备份失败\r\n" | tee -a $WEB_LOG_PATH
    fi
fi
