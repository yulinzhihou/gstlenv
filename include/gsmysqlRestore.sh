#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-11-07
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 还原数据库

WEBDBFILE=$(ls -t /var/lib/mysql | grep "web-" | head -n1 | awk '{print $0}')
if [ ! -n "${WEBDBFILE}" ]; then
    cd /var/lib/mysql &&
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web <./${WEBDBFILE}
fi

TLBBDBFILE=$(ls -t /var/lib/mysql | grep "tlbbdb-" | head -n1 | awk '{print $0}')
if [ ! -n "${TLBBDBFILE}" ]; then
    cd /var/lib/mysql &&
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb <./${TLBBDBFILE}
fi
