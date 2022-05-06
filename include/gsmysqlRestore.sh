#!/usr/bin/env sh
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-11-07
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 还原数据库

if [ $# -eq 0 ]; then
    # 表示没有输出任何参数，进行还原备份
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
elif [ $# -eq 2 ]; then
    if [ $1 -ne 'web' ] || [ $1 -ne 'tlbbdb' ]; then
        echo "${CRED}参数1不正确，请输入 【web】 或者 【tlbbdb】 ${CEND}"
        exit 1
    else
        if [ ! -f $2 ]; then
            echo "参数2，数据库文件不存在或者路径不正确，请输入正确文件路径。如：【/tlgame/backup/web-2022-05-06.sql】"
            exit 1
        else
            mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" $1 <$2
            exit 1
        fi
    fi
else
    # 表示有参数传入，可能是删档
    if [ $1 = 'reset' ]; then
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web </docker-entrypoint-initdb.d/web.sql
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb </docker-entrypoint-initdb.d/tlbbdb.sql
        exit 0
    fi
fi
