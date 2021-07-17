#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除所有数据
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

while :; do echo
    for ((time = 10; time > 0; time--)); do
      sleep 1
      echo -ne "\r在准备正行清除操作！！，剩余 ${CBLUE}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
    done
    echo -ne "\n\r"
    if [ -e ${ROOT_PATH}/${GSDIR} ]; then
      docker stop $(docker ps -a -q) && \
      docker rm -f $(docker ps -a -q) && \
      docker rmi -f $(docker images -q) && \
      mv /tlgame  /tlgame-`date +%Y%m%d%H%I%S` && \
      rm -rf ${ROOT_PATH}/${GSDIR}
    else
      docker stop $(docker ps -a -q) && \
      docker rm -f $(docker ps -a -q) && \
      docker rmi -f $(docker images -q) && \
      mv /tlgame  /tlgame-`date +%Y%m%d%H%I%S`
    fi

    if [ $? == 0 ]; then
      echo -e "${CSUCCESS} 数据清除成功，请重新安装环境！！${CEND}"
    else
      echo -e "${CRED} 数据清除失败！可能需要重装系统或者环境了！${CEND}"
    fi
    break
done