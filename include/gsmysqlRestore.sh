#!/usr/bin/env sh
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-11-07
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 还原数据库

if [ $# -eq 0 ]; then
    # 表示没有输出任何参数，进行还原备份
    WEBDBFILE=`ls -t /var/lib/mysql | grep "web-" | head -n1 | awk '{print $0}'`

    if [ ! -n "${WEBDBFILE}" ]; then
        cd /var/lib/mysql &&
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <./${WEBDBFILE}
    fi

    TLBBDBFILE=`ls -t /var/lib/mysql | grep "tlbbdb-" | head -n1 | awk '{print $0}'`
    if [ ! -n "${TLBBDBFILE}" ]; then
        cd /var/lib/mysql &&
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <./${TLBBDBFILE}
    fi
else
    # 表示有参数传入，可能是删档
    if [ $1 = 'reset' ]; then
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web </docker-entrypoint-initdb.d/web.sql
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb </docker-entrypoint-initdb.d/tlbbdb.sql
        exit 0
    fi
fi
