#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-09-30
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键启动开服日志查看，暂时还未开启
# 颜色代码
# 引入全局参数
if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
else
    . /usr/local/bin/.env
fi
# 颜色代码
if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
else
    . /usr/local/bin/color
fi
