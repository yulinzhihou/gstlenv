#!/usr/bin/env bash
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
curl -L https://gitee.com/yulinzhihou/docker-compose/raw/master/docker-compose-$(uname -s)-$(uname -m) >/usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -sSL https://gitee.com/yulinzhihou/gstlenv/raw/master/gsenv.sh | bash
