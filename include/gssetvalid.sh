#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-12-24
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 设置解号封号
INVALID_SQL_FILE='change_valid'
if [ $# -ne 0 ]; then
    if [ -z $2 ] && [[ $2 -eq 1 ]]; then
        # 封号
        INVALID_SQL_FILE='change_invalid'
    fi
    sed -i "s/accname = .*/accname = '$1'/g" /usr/local/bin/${INVALID_SQL_FILE}.sql
fi

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb </usr/local/bin/${INVALID_SQL_FILE}.sql
