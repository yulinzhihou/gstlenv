#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-12-25
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删档脚本

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

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r在准备正行删档操作！！，剩余 ${CYELLOW}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！如果需要备份，退出后再执行【backup】命令\r"
      sleep 1
    done
    echo -ne "\n\r"
    echo -ne "${CYELLOW}正在删档，数据全部清空…………\r${CEND}"
    #重构前，先备份数据库以及版本数据。
    docker exec -it gsmysql /bin/bash /usr/local/bin/gsmysqlRestore.sh reset
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS}已经删档成功${CEND}"
      exit 0
    else
      echo "${GSISSUE}"
      echo -e "${CRED}已经删档失败！可能需要重装系统或者环境了！${CEND}"
      exit 1
    fi
  done
else
  echo "${GSISSUE}"
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装!!!${CEND}"
  exit 1
fi
