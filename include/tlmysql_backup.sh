#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 容器里面备份数据库功能和打包服务端

FILENAME=`date "+%Y-%m-%d-%H-%M-%S"`
TLBBDB_LOG_PATH='/var/lib/mysql/tlbbdb_backup.log'
WEB_LOG_PATH='/var/lib/mysql/WEB_backup.log'
mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb > /var/lib/mysql/tlbbdb-${FILENAME}.sql
#判断是否备份成功
if [[ $? -eq 0 ]]; then
    echo -e "`date "+%Y-%m-%d-%H-%M-%S"`\ttlbbdb-${FILENAME}.sql\t备份成功!!">>$TLBBDB_LOG_PATH
else
    echo -e "`date "+%Y-%m-%d-%H-%M-%S"`\ttlbbdb-${FILENAME}.sql\t备份失败">>$TLBBDB_LOG_PATH
fi

mysqldump -uroot -p"${MYSQL_ROOT_PASSWORD}" web > /var/lib/mysql/web-${FILENAME}.sql
#判断是否备份成功
if [[ $? -eq 0 ]]; then
    echo -e "`date "+%Y-%m-%d-%H-%M-%S"`\tweb-${FILENAME}.sql\t备份成功">>$WEB_LOG_PATH
else
    echo -e "`date "+%Y-%m-%d-%H-%M-%S"`\tweb-${FILENAME}.sql\t备份失败">>$WEB_LOG_PATH
fi