#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键命令关闭所有
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

if [ -f ${ROOT_PATH}/${GSDIR} ];then 
  cd ${ROOT_PATH}/${GSDIR} && \
  docker exec -d gsserver /bin/bash ./Server/shm stop && \
  docker exec -d gsserver /bin/bash stop.sh && \
  docker exec -d gsserver /home/billing/billing stop
  if [ $? == 0 ]; then
    echo -e "${CSUCCESS} 服务端关闭成功，如果需要重新开启，请运行【runtlbb】命令${CEND}"
  else
    echo -e "${CRED} 服务端关闭失败！请稍后再试！${CEND}"
  fi
fi

