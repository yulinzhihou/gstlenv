#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 连接服务器环境
# 引入全局参数
# 增加容器是否存在的判断
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
  if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
  fi
  # 颜色代码
  if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
  else
    . /usr/local/bin/color
  fi

  if [ $# -eq 0 ]; then
    cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsserver /bin/bash
  else
    case "$1" in
    'gsmysql' | 'mysql' | 'sql' | 'my' | 'm')
      cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsmysql /bin/bash
      ;;
    'gsserver' | 'server' | 'gs' | 's')
      cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsserver /bin/bash
      ;;
    'gsnginx' | 'nginx' | 'n')
      cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsnginx /bin/sh
      ;;
    'redis' | 'gsredis' | 'r')
      cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsredis /bin/bash
      ;;
    'gsphp' | 'php' | 'p')
      cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsphp /bin/sh
      ;;
    *)
      echo -e "${GSISSUE}\r\n"
      echo -e "${CRED}错误：输入有误！！请使用 link {gsmysql|mysql|sql|my|m},{gsphp|php|p},{gsredis|redis|r},{gsnginx|nginx|n},{gsserver|server|gs|s}${CEND}"
      ;;
    esac
  fi
else
  echo -e "${GSISSUE}\r\n"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
