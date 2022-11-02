#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键开服，适合于那种可以一键开启的服务端，如果3-5分钟后，服务端没开启，则需要使用分步开服方式
# 增加容器是否存在的判断
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
  # 引入全局参数
  if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
  fi
  # 颜色代码
  if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
  else
    . /usr/local/bin/color
  fi

  # 游戏内注册=0，登录器注册=1
  # if [ ${IS_DLQ} -eq 0 ]; then
  #   docker exec -d gsserver /home/billing/billing up -d
  #   sleep 3
  # fi

  chmod -R 777 /tlgame &&
    docker exec -d gsserver chmod -R 777 /usr/local/bin &&
    docker exec -d gsmysql chmod -R 777 /usr/local/bin &&
    chown -R root:root /tlgame &&
    cd ${ROOT_PATH}/${GSDIR} &&
    docker exec -d gsserver /bin/bash run.sh

  if [ $? -eq 0 ]; then
    # 删除因为改版本导致引擎启动失败的dump文件
    gsbak
    cd ${ROOT_PATH}/${GSDIR} && rm -rf core.*
    echo -e "${CSUCCESS}已经成功启动服务端，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！！${CEND}"
    exit 0
  else
    echo "${GSISSUE}"
    echo -e "${CRED} 启动服务端失败！${CEND}"
    exit 1
  fi
else
  echo "${GSISSUE}"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
