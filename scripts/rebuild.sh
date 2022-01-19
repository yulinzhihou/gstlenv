#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 服务器环境重构，删除容器，重新启动
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

  # 备份数据
  setconfig_backup() {
    echo -ne "正在备份版本数据请稍候……\r\n"
    cd /tlgame && tar zcf tlbb-setconfig-backup.tar.gz tlbb &&
      docker exec -it gsmysql /bin/sh /usr/local/bin/gsmysqlBackup.sh
  }

  # 还原数据
  setconfig_restore() {
    echo -ne "正在还原修改参数之前的数据库与版本请稍候……\r\n"
    if [ -f "/tlgame/tlbb-setconfig-backup.tar.gz" ]; then
      cd /tlgame && tar zxf tlbb-setconfig-backup.tar.gz && rm -rf /tlgame/tlbb-setconfig-backup.tar.gz
    fi

    if [ -f "/tlgame/gsmysql/*.sql" ]; then
      docker exec -it gsmysql /bin/sh /usr/local/bin/gsmysqlRestore.sh
    fi

  }

  while :; do
    echo
    for ((time = 5; time >= 0; time--)); do
      echo -ne "\r在准备正行重构操作！！，剩余 ${CYELLOW}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
      sleep 1
    done
    echo -ne "\n\r"
    echo -ne "${CYELLOW}正在重构，数据全部清空…………${CEND}"
    #重构前，先备份数据库以及版本数据。
    setconfig_backup &&
      docker stop $(docker ps -a -q) &&
      docker rm $(docker ps -a -q) &&
      rm -rf /tlgame/tlbb/* &&
      cd ${ROOT_PATH}/${GSDIR} &&
      docker-compose up -d &&
      setconfig_restore
    if [ $? -eq 0 ]; then
      echo -e "${CSUCCESS}环境已经重构成功，请上传服务端到指定位置，然后再开服操作！！可以重新上传服务端进行【untar】【setini】【runtlbb】进行开服操作！！${CEND}"
      exit 0
    else
      echo -e "${CRED}环境已经重构失败！可能需要重装系统或者环境了！${CEND}"
      exit 1
    fi
  done
else
  echo "${CRED}环境毁坏，需要重新安装或者移除现有的环境重新安装！！！${CEND}"
  exit 1
fi
