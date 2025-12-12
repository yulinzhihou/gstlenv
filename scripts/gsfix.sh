#!/usr/bin/env bash
# 设置字符编码，确保中文正常显示
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2022-11-3
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# 检测是不是root用户。不是则退出
if [ -f /usr/local/bin/color ]; then
    . /usr/local/bin/color
fi
[ $(id -u) != "0" ] && {
    echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"
    exit 1
}
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
curl -L https://gitee.com/yulinzhihou/docker-compose/releases/download/v2.16.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose
curl -sSL https://gitee.com/yulinzhihou/gstlenv/raw/master/gsenv.sh | bash
