#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2024-03-28
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 查看服务器进程情况
if pidof "GSOnlineGM"; then
  # 表示程序进再进行中
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
  echo -e "${CSUCCESS}GS游享在线GM 停止成功${CEND}"
  echo -e "${CRED}GS游享在线GM正在运行中，开启使用 [ gmstart ]命令, 重启使用 [ gmrestart ]命令！！！${CEND}"
else
  cd /tlgame/GSOnlineGM && ./GSOnlineGM stop 2>&1 >/dev/null
  if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS}GS游享在线GM停止成功${CEND}"
  fi
fi
