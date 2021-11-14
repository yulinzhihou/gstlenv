#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
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

case "$1" in
'gsmysql' | 'mysql')
  cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsmysql /bin/bash
  ;;
'gsserver' | 'server' | 'gs')
  cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsserver /bin/bash
  ;;
'gsnginx' | 'nginx')
  cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsnginx /bin/sh
  ;;
'redis' | 'gsredis')
  cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsredis /bin/bash
  ;;
'gsphp' | 'php')
  cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsphp /bin/sh
  ;;
*)
  echo -e "${CRED}错误：输入有误！！请使用 link {gsmysql|mysql},{gsphp|php},{gsredis|redis},{gsnginx|nginx},{gsserver|server|gs}${CEND}"
  ;;
esac
