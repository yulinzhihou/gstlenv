#!/usr/bin/env sh
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-11-07
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 还原数据库

if [ $# -eq 0 ]; then
    # 表示没有输出任何参数，进行还原备份
    WEBDBFILE=$(ls -t /home/backup | grep "web-" | head -n1 | awk '{print $0}')
    if [ -n "${WEBDBFILE}" ]; then
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web </home/backup/${WEBDBFILE}
        echo "正在还原 web 库"
    fi

    TLBBDBFILE=$(ls -t /home/backup | grep "tlbbdb-" | head -n1 | awk '{print $0}')
    if [ -n "${TLBBDBFILE}" ]; then
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb </home/backup/${TLBBDBFILE}
        echo "正在还原 tlbbdb 库"
    fi
elif [ $# -eq 2 ]; then
    if [ ! -f $2 ]; then
        echo "参数2，数据库文件不存在或者路径不正确，请输入正确文件路径。如：【/tlgame/backup/web-2022-05-06.sql】"
        exit 1
    else
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" $1 <$2
        [ $? -eq 0 ] && exit 0 || exit 1
    fi
else
    # 表示有参数传入，可能是删档
    if [ $1 == 'reset' ]; then
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web </docker-entrypoint-initdb.d/web.sql
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" tlbbdb </docker-entrypoint-initdb.d/tlbbdb.sql
        exit 0
    fi
fi
