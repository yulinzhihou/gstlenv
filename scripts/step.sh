#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 分步调试命令，手动创建新窗口，step 1,step 2,step 3,step 4
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

echo -e "${CYYAN}使用此命令需要手动创建多窗口，点当前容器标签右键---克隆/复制容器---会基于当前容器创建一个全新的容器。每个容器输入一个命令，一共需要4个窗口${CEND}" 

run_step_1() {
  cd ${ROOT_PATH}/${GSDIR} && docker-compose exec -d gsserver ./Server/shm stop && \
  docker-compose exec -d gsserver /home/billing/billing up -d  && \
  docker-compose exec -d gsserver /bin/bash Server/shm start
}

run_step_2() {
  cd ${ROOT_PATH}/${GSDIR} && \
  docker-compose exec -d gsserver /bin/bash Server/Login
}

run_step_3() {
  cd ${ROOT_PATH}/${GSDIR} && \
  docker-compose exec -d gsserver /bin/bash Server/World
}

run_step_3() {
  cd ${ROOT_PATH}/${GSDIR} && \
  docker-compose exec -d gsserver /bin/bash Server/Server
}

if [ $# == 1 ]; then
  case $1 in
    1) run_step_1 ;;
    2) run_step_2 ;;
    3) run_step_3 ;;
    4) run_step_4 ;;
    *)echo 'error';;
  esac
fi