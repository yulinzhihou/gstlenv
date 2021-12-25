#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除所有数据
docker ps --format "{{.Names}}" | grep gsserver >/dev/null
if [ $? -eq 0 ]; then
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

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r正准备恢复出厂设置，数据全清！！，剩余 ${CBLUE}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\n\r"
    echo -ne "${CYELLOW}正在进行清除操作…………${CEND}"
    if [ -e ${ROOT_PATH}/${GSDIR} ]; then
      docker stop $(docker ps -a -q) &&
        docker rm -f $(docker ps -a -q) &&
        docker rmi -f $(docker images -q) &&
        mv /tlgame /tlgame-$(date +%Y%m%d%H%I%S) &&
        chattr -i ${GS_WHOLE_PATH} &&
        rm -rf ${GS_PROJECT} &&
        rm -rf ${ROOT_PATH}/${GSDIR} &&
        rm -rf /usr/local/bin/.env
    else
      docker stop $(docker ps -a -q) &&
        docker rm -f $(docker ps -a -q) &&
        docker rmi -f $(docker images -q) &&
        chattr -i ${GS_WHOLE_PATH} &&
        rm -rf ${GS_PROJECT} &&
        rm -rf ${ROOT_PATH}/${GSDIR} &&
        mv /tlgame /tlgame-$(date +%Y%m%d%H%I%S) &&
        rm -rf /usr/local/bin/.env
    fi

    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS} 数据清除成功，请重新安装环境!!! 可以重新输入 【 curl -sSL https://gsgameshare.com/gsenv | bash 】进行重新安装!!!${CEND}"
      exit 0
    else
      echo -e "${CRED} 数据清除失败！可能需要重装系统或者环境了！${CEND}"
      exit 1
    fi
    break
  done
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
