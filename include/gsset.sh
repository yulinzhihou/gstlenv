#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-12-24
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 设置默认充值点数
if [ $# -ne 0 ]; then
    sed -i "s/default .*/default $1/g" /usr/local/bin/alter_point.sql
else
    sed -i "s/default .*/default 0/g" /usr/local/bin/alter_point.sql
fi

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" web </usr/local/bin/alter_point.sql
