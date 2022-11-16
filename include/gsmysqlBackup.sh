#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 容器里面备份数据库功能和打包服务端
FILENAME=$(date "+%Y-%m-%d")
DATE_FILENAME=$(date "+%Y%m%d%H%M%S")
LOG_FILE="/home/backup/backup-${FILENAME}.log"
# 如果是空库则不进行备份
WEB_FILE_NUM=$(ls -l /var/lib/mysql/web | grep '^-' | wc -l)
TLBBDB_FILE_NUM=$(ls -l /var/lib/mysql/tlbbdb | grep '^-' | wc -l)

if [ ${WEB_FILE_NUM} -gt 1 ]; then
    mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" web >/home/backup/web-${DATE_FILENAME}.sql
    #判断是否备份成功
    if [ $? -eq 0 ]; then
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\tweb-${DATE_FILENAME}.sql\t备份成功!!\r\n" | tee -a $LOG_FILE
    else
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\tweb-${DATE_FILENAME}.sql\t备份失败\r\n" | tee -a $LOG_FILE
    fi
fi

if [ ${TLBBDB_FILE_NUM} -gt 1 ]; then
    mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" --opt -R tlbbdb >/home/backup/tlbbdb-${DATE_FILENAME}.sql
    #判断是否备份成功
    if [ $? -eq 0 ]; then
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\ttlbbdb-${DATE_FILENAME}.sql\t备份成功\r\n" | tee -a $LOG_FILE
    else
        echo -e "$(date "+%Y-%m-%d-%H-%M-%S")\ttlbbdb-${DATE_FILENAME}.sql\t备份失败\r\n" | tee -a $LOG_FILE
    fi
fi
