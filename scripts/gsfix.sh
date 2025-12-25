#!/usr/bin/env bash
# 设置字符编码，确保中文正常显示
# 尝试设置 locale，如果失败则静默处理（不显示警告）
# 使用命令块包裹并重定向所有错误输出，彻底屏蔽警告信息
{
    export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || export LANG=POSIX 2>/dev/null || true
    export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || export LC_ALL=POSIX 2>/dev/null || true
} 2>/dev/null
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
