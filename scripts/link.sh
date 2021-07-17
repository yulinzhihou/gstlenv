#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 连接服务器环境
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

if [[ $1 == "gsmysql" ]] || [[ $1 == "gsnginx" ]]; then
    cd ${ROOT_PATH}/${GSDIR} && docker-compose exec $1 bash
elif [ -z $1 ]; then
    cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsserver bash
else
  echo -e "${CRED}错误：输入有误！！请使用 link gsmysql|gsnginx|gsserver${CEND}";
fi