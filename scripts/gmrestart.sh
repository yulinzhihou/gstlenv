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
  cd /tlgame/GSOnlineGM && ./GSOnlineGM stop 2>&1 >/dev/null
  cd /tlgame/GSOnlineGM && ./GSOnlineGM start -d 2>&1 >/dev/null
  echo -e "${CSUCCESS}GS游享在线GM 重启成功${CEND}"
else
  cd /tlgame/GSOnlineGM && ./GSOnlineGM start -d 2>&1 >/dev/null
  if [ $? -eq 0 ]; then
    echo -e "${CSUCCESS}GS游享在线GM重启成功${CEND}"
  fi
fi
