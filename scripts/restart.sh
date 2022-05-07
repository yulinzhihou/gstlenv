#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键命令重启命令所有
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

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r在准备正行重启操作！！，剩余 ${CRED}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\n\r"
    echo -ne "${CYELLOW}正在重启…………\n\r${CEND}"
    # cd ${ROOT_PATH}/${GSDIR} && docker-compose restart && docker exec -it gsmysql /bin/sh /usr/local/bin/init_db.sh
    cd ${ROOT_PATH}/${GSDIR} && docker-compose restart
    if [ $? -eq 0 ]; then
      # 删除因为改版本导致引擎启动失败的dump文件
      cd ${ROOT_PATH}/${GSDIR} && rm -rf core.*
      echo -e "${CSUCCESS} 服务端已经重启成功，如果需要重新开服，请运行【runtlbb】命令 ${CEND}"
      exit 0
    else
      echo -e "${CRED} 服务端已经重启失败！可能需要重装系统或者环境了！${CEND}"
      exit 1
    fi
  done
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
